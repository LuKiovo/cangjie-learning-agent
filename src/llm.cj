package cangjie_learning_agent

import std.process.*

func defaultLlmEndpoint(): String {
    return "https://api.openai.com/v1/chat/completions"
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
    let marker = "\"${key}\""
    let markerIndex = json.indexOf(marker) ?? -1
    if (markerIndex < 0) {
        return ""
    }
    let colonIndex = json.indexOf(":", markerIndex + marker.size) ?? -1
    if (colonIndex < 0) {
        return ""
    }
    var quoteIndex = json.indexOf("\"", colonIndex + 1) ?? -1
    if (quoteIndex < 0) {
        return ""
    }
    var endIndex = quoteIndex + 1
    var escaped = false
    while (endIndex < json.size) {
        let current = json[endIndex..(endIndex + 1)]
        if (escaped) {
            escaped = false
        } else if (current == "\\") {
            escaped = true
        } else if (current == "\"") {
            return jsonUnescape(json[(quoteIndex + 1)..endIndex])
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
    let endpoint = envOrDefault("CANGJIE_AGENT_LLM_ENDPOINT", defaultLlmEndpoint())
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
    println("Endpoint: ${envOrDefault("CANGJIE_AGENT_LLM_ENDPOINT", defaultLlmEndpoint())}")
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
