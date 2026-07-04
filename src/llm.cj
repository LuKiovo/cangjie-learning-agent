package cangjie_learning_agent

import std.process.*
import std.collection.*

func defaultLlmEndpoint(): String {
    return "https://api.deepseek.com/chat/completions"
}

func normalizeLlmEndpoint(endpoint: String): String {
    if (endpoint.endsWith("/chat/completions")) {
        return endpoint
    }
    if (endpoint.endsWith("/")) {
        return endpoint + "chat/completions"
    }
    return endpoint + "/chat/completions"
}

func configuredLlmEndpoint(): String {
    return normalizeLlmEndpoint(envOrDefault("CANGJIE_AGENT_LLM_ENDPOINT", defaultLlmEndpoint()))
}

func jsonEscape(text: String): String {
    return text
        .replace("\\", "\\\\")
        .replace("\"", "\\\"")
        .replace("\r", "\\r")
        .replace("\n", "\\n")
        .replace("\t", "\\t")
}

func jsonUnescape(text: String): String {
    return text
        .replace("\\n", "\n")
        .replace("\\r", "\r")
        .replace("\\t", "\t")
        .replace("\\\"", "\"")
        .replace("\\\\", "\\")
}

func bytesIndexOf(data: Array<Byte>, pattern: Array<Byte>, startIndex: Int64): Int64 {
    if (pattern.size == 0 || data.size < pattern.size || startIndex >= data.size) {
        return -1
    }

    var index = startIndex
    while (index <= data.size - pattern.size) {
        var matched = true
        var patternIndex: Int64 = 0
        while (patternIndex < pattern.size) {
            if (data[index + patternIndex] != pattern[patternIndex]) {
                matched = false
                break
            }
            patternIndex += 1
        }
        if (matched) {
            return index
        }
        index += 1
    }
    return -1
}

func bytesToString(data: Array<Byte>, startIndex: Int64, endIndex: Int64): String {
    let bytes = ArrayList<Byte>()
    var index = startIndex
    while (index < endIndex) {
        bytes.add(data[index])
        index += 1
    }
    return String.fromUtf8(bytes.toArray())
}

func buildChatCompletionJson(model: String, prompt: String): String {
    var text = "{"
    text += "\"model\":\"${jsonEscape(model)}\","
    text += "\"messages\":["
    text += "{\"role\":\"system\",\"content\":\"You are a Cangjie language learning assistant. Answer in Chinese. Always cite the local source path when one is provided.\"},"
    text += "{\"role\":\"user\",\"content\":\"${jsonEscape(prompt)}\"}"
    text += "],"
    text += "\"temperature\":0.2"
    text += "}"
    return text
}

func extractJsonStringValue(json: String, key: String): String {
    let data = json.toArray()
    let marker = "\"${key}\"".toArray()
    let markerIndex = bytesIndexOf(data, marker, 0)
    if (markerIndex < 0) {
        return ""
    }
    let colonIndex = bytesIndexOf(data, ":".toArray(), markerIndex + marker.size)
    if (colonIndex < 0) {
        return ""
    }
    let quoteIndex = bytesIndexOf(data, "\"".toArray(), colonIndex + 1)
    if (quoteIndex < 0) {
        return ""
    }
    var endIndex = quoteIndex + 1
    var escaped = false
    while (endIndex < data.size) {
        let current = data[endIndex]
        if (escaped) {
            escaped = false
        } else if (current == 92) {
            escaped = true
        } else if (current == 34) {
            return jsonUnescape(bytesToString(data, quoteIndex + 1, endIndex))
        }
        endIndex += 1
    }
    return ""
}

func extractLlmContent(response: String): String {
    let content = extractJsonStringValue(response, "content")
    if (!content.isEmpty()) {
        return content
    }
    let message = extractJsonStringValue(response, "message")
    if (!message.isEmpty()) {
        return message
    }
    let errorType = extractJsonStringValue(response, "type")
    if (!errorType.isEmpty()) {
        return "API error: ${errorType}"
    }
    return ""
}

func callLlmApi(prompt: String): (Int64, Array<Byte>, Array<Byte>) {
    let endpoint = configuredLlmEndpoint()
    let model = envOrDefault("CANGJIE_AGENT_LLM_MODEL", "")
    let apiKey = envOrDefault("CANGJIE_AGENT_API_KEY", "")

    if (model.isEmpty()) {
        return (1, Array<Byte>(), "Missing CANGJIE_AGENT_LLM_MODEL.".toArray())
    }
    if (apiKey.isEmpty()) {
        return (1, Array<Byte>(), "Missing CANGJIE_AGENT_API_KEY.".toArray())
    }

    let payload = buildChatCompletionJson(model, prompt)
    let arguments = [
        "-sS",
        "--fail-with-body",
        "-X",
        "POST",
        endpoint,
        "-H",
        "Content-Type: application/json",
        "-H",
        "Authorization: Bearer ${apiKey}",
        "-d",
        payload
    ]
    return executeWithOutput("curl", arguments)
}

func printLlmApiAnswer(question: String, totalMatches: Int64, primarySource: String, sourceText: String): Int64 {
    let prompt = buildLlmPromptText(question, totalMatches, primarySource, sourceText)
    println("LLM transport: curl HTTPS POST from Cangjie std.process")
    println("Endpoint: ${configuredLlmEndpoint()}")
    println("Model configured: ${isConfigured(envOrDefault("CANGJIE_AGENT_LLM_MODEL", ""))}")
    println("API key configured: ${isConfigured(envOrDefault("CANGJIE_AGENT_API_KEY", ""))}")
    println("Security: API key is read from environment variables and is not stored.")

    let result = callLlmApi(prompt)
    let exitCode = result[0]
    let stdoutText = String.fromUtf8(result[1])
    let stderrText = String.fromUtf8(result[2])

    if (exitCode != 0) {
        println("LLM API call failed.")
        if (!stderrText.isEmpty()) {
            println(stderrText)
        }
        if (!stdoutText.isEmpty()) {
            println(stdoutText)
        }
        return exitCode
    }

    let answer = extractLlmContent(stdoutText)
    println("LLM answer:")
    if (!answer.isEmpty()) {
        println(answer)
    } else {
        println("Could not extract message.content. Raw response follows:")
        println(stdoutText)
    }
    if (!primarySource.isEmpty()) {
        println("Source: ${primarySource}")
    } else {
        println("Source: none matched locally")
    }
    return 0
}

func buildLlmApiAnswerText(question: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    let prompt = buildLlmPromptText(question, totalMatches, primarySource, sourceText)
    let result = callLlmApi(prompt)
    let exitCode = result[0]
    let stdoutText = String.fromUtf8(result[1])
    let stderrText = String.fromUtf8(result[2])

    var diagnostic = "LLM transport: curl HTTPS POST from Cangjie std.process\n"
    diagnostic += "Endpoint: ${configuredLlmEndpoint()}\n"
    diagnostic += "Model configured: ${isConfigured(envOrDefault("CANGJIE_AGENT_LLM_MODEL", ""))}\n"
    diagnostic += "API key configured: ${isConfigured(envOrDefault("CANGJIE_AGENT_API_KEY", ""))}\n"

    if (exitCode != 0) {
        var text = "AI 回答\n\n"
        text += "LLM API call failed.\n\n"
        text += "诊断信息\n\n"
        text += diagnostic
        if (!stderrText.isEmpty()) {
            text += stderrText
            text += "\n"
        }
        if (!stdoutText.isEmpty()) {
            text += stdoutText
            text += "\n"
        }
        return text
    }

    let answer = extractLlmContent(stdoutText)
    var text = "AI 回答\n\n"
    if (!answer.isEmpty()) {
        text += answer
        text += "\n\n"
    } else {
        text += "Could not extract message.content. Raw response follows:\n"
        text += stdoutText
        text += "\n\n"
    }
    text += "资料来源\n\n"
    if (!primarySource.isEmpty()) {
        text += "- Primary source: ${primarySource}\n"
    } else {
        text += "- Primary source: none matched locally\n"
    }
    text += "\n诊断信息\n\n"
    text += diagnostic
    return text
}
