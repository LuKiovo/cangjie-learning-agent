package cangjie_learning_agent

import std.collection.*
import std.convert.*
import std.fs.*
import std.net.*

func htmlEscape(text: String): String {
    return text
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
}

func hexValue(text: String): Byte {
    return Byte.parse(text, radix: 16)
}

func urlDecode(text: String): String {
    let bytes = ArrayList<Byte>()
    var index: Int64 = 0
    while (index < text.size) {
        let current = text[index..(index + 1)]
        if (current == "+" ) {
            bytes.add(32)
            index += 1
        } else if (current == "%" && index + 2 < text.size) {
            let hex = text[(index + 1)..(index + 3)]
            bytes.add(hexValue(hex))
            index += 3
        } else {
            let raw = current.toArray()
            var rawIndex: Int64 = 0
            while (rawIndex < raw.size) {
                bytes.add(raw[rawIndex])
                rawIndex += 1
            }
            index += 1
        }
    }
    return String.fromUtf8(bytes.toArray())
}

func getFormValue(body: String, name: String): String {
    let marker = name + "="
    let start = body.indexOf(marker) ?? -1
    if (start < 0) {
        return ""
    }
    let valueStart = start + marker.size
    let end = body.indexOf("&", valueStart) ?? body.size
    return urlDecode(body[valueStart..end])
}

func buildQueryTerms(query: String): Array<String> {
    if (query.contains(" ")) {
        return query.split(" ")
    }
    return [query]
}

func countMatchesForWeb(path: Path, query: String, terms: Array<String>): Int64 {
    return countMatchesForWebRecursive(path, query, terms, 0)
}

func countMatchesForWebRecursive(path: Path, query: String, terms: Array<String>, startIndex: Int64): Int64 {
    if (!exists(path)) {
        return 0
    }
    var matches: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            matches += countMatchesForWebRecursive(item.path, query, terms, startIndex)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (textMatchesQuery(text, query, terms, startIndex)) {
                matches += 1
            }
        }
    }
    return matches
}

func buildWebAnswer(question: String, mode: String): String {
    let officialPath = Path("knowledge_base/official")
    let userNotesPath = Path("knowledge_base/user_notes")
    let terms = buildQueryTerms(question)
    let officialMatches = countMatchesForWeb(officialPath, question, terms)
    let userNotesMatches = countMatchesForWeb(userNotesPath, question, terms)
    let totalMatches = officialMatches + userNotesMatches
    let primarySource = findBestLocalSource(officialPath, userNotesPath, question, terms, 0)
    let sourceText = readSourceTextOrEmpty(primarySource)

    var text = "Question: ${question}\n"
    text += "Mode: ${mode}\n"
    text += "Matched sources: ${totalMatches}\n"
    if (!primarySource.isEmpty()) {
        text += "Primary source: ${primarySource}\n\n"
    } else {
        text += "Primary source: none\n\n"
    }

    if (mode == "api") {
        text += buildLlmApiAnswerText(question, totalMatches, primarySource, sourceText)
    } else {
        text += buildAnswerReportText(question, totalMatches, primarySource, sourceText)
    }
    return text
}

func addWebNote(name: String, content: String): String {
    if (!isSafeKnowledgeName(name)) {
        return "Invalid note name. Use a simple file name without path separators or '..'."
    }
    let path = addUserKnowledge("syntax_notes", name, content)
    return "Saved syntax note: ${path.toString()}"
}

func buildWebPage(answer: String, notice: String): String {
    let endpoint = envOrDefault("CANGJIE_AGENT_LLM_ENDPOINT", defaultLlmEndpoint())
    let modelReady = isConfigured(envOrDefault("CANGJIE_AGENT_LLM_MODEL", ""))
    let keyReady = isConfigured(envOrDefault("CANGJIE_AGENT_API_KEY", ""))
    var html = "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'>"
    html += "<meta name='viewport' content='width=device-width,initial-scale=1'>"
    html += "<title>仓颉语言学习助手 Agent</title>"
    html += "<style>"
    html += "body{margin:0;font-family:Arial,'Microsoft YaHei',sans-serif;background:#f6f7f2;color:#1f2933}"
    html += ".shell{max-width:1120px;margin:0 auto;padding:28px}"
    html += "header{display:flex;justify-content:space-between;gap:16px;align-items:flex-start;border-bottom:3px solid #1f2933;padding-bottom:18px}"
    html += "h1{font-size:32px;margin:0 0 8px}p{line-height:1.65}.badge{display:inline-block;border:1px solid #1f2933;padding:5px 9px;margin:3px;background:#fff}"
    html += ".grid{display:grid;grid-template-columns:1.3fr .7fr;gap:18px;margin-top:22px}.panel{background:#fff;border:2px solid #1f2933;padding:18px}"
    html += "label{font-weight:700;display:block;margin:12px 0 6px}textarea,input,select{width:100%;box-sizing:border-box;border:2px solid #1f2933;padding:10px;font-size:15px;background:#fff}"
    html += "button{margin-top:14px;background:#1f2933;color:#fff;border:0;padding:11px 16px;font-weight:700;cursor:pointer}"
    html += "pre{white-space:pre-wrap;background:#111827;color:#f9fafb;padding:16px;overflow:auto;min-height:220px}.hint{font-size:14px;color:#52606d}"
    html += "@media(max-width:820px){.grid,header{display:block}.shell{padding:16px}}"
    html += "</style></head><body><div class='shell'>"
    html += "<header><div><h1>仓颉语言学习助手 Agent</h1><p>本地知识库检索、来源标注、语法问答与真实 API 调用。</p></div>"
    html += "<div><span class='badge'>仓颉实现</span><span class='badge'>本地 .md/.txt</span><span class='badge'>Web 交互</span></div></header>"
    html += "<section class='grid'><main class='panel'><h2>提问</h2>"
    html += "<form method='post' action='/ask'><label>问题</label><textarea name='question' rows='5'>match 表达式怎么用</textarea>"
    html += "<label>回答模式</label><select name='mode'><option value='local'>本地知识库回答</option><option value='api'>真实 API 回答</option></select>"
    html += "<button type='submit'>发送问题</button></form>"
    html += "<h2>回答与来源</h2><pre>${htmlEscape(answer)}</pre></main>"
    html += "<aside class='panel'><h2>API 状态</h2><p class='hint'>Endpoint: ${htmlEscape(endpoint)}</p>"
    html += "<p>Model configured: ${modelReady}<br>API key configured: ${keyReady}</p>"
    html += "<h2>新增语法笔记</h2><form method='post' action='/note'><label>文件名</label><input name='name' value='web_note'>"
    html += "<label>笔记内容</label><textarea name='content' rows='5'>这里写你的仓颉语法笔记</textarea><button type='submit'>保存到本地知识库</button></form>"
    html += "<p class='hint'>${htmlEscape(notice)}</p>"
    html += "<h2>演示提示</h2><p class='hint'>先用本地模式证明来源检索，再切换真实 API 模式展示联网回答。</p></aside></section>"
    html += "</div></body></html>"
    return html
}

func sendHttp(socket: TcpSocket, status: String, body: String): Unit {
    let response = "HTTP/1.1 ${status}\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: ${body.toArray().size}\r\nConnection: close\r\n\r\n${body}"
    socket.write(response.toArray())
}

func handleWebRequest(request: String): String {
    let bodyStart = request.indexOf("\r\n\r\n") ?? -1
    let body = if (bodyStart >= 0) {
        request[(bodyStart + 4)..request.size]
    } else {
        ""
    }

    if (request.startsWith("POST /ask")) {
        let question = getFormValue(body, "question")
        let mode = getFormValue(body, "mode")
        if (question.isEmpty()) {
            return buildWebPage("请输入问题。", "")
        }
        return buildWebPage(buildWebAnswer(question, mode), "")
    }

    if (request.startsWith("POST /note")) {
        let name = getFormValue(body, "name")
        let content = getFormValue(body, "content")
        return buildWebPage("", addWebNote(name, content))
    }

    return buildWebPage("", "")
}

func runWebServer(port: UInt16): Int64 {
    let server = TcpServerSocket(bindAt: port)
    server.bind()
    println("Cangjie Learning Agent Web is running:")
    println("http://127.0.0.1:${port}")
    println("Press Ctrl+C to stop.")
    while (true) {
        let client = server.accept()
        let buffer = Array<Byte>(65536, repeat: 0)
        let count = client.read(buffer)
        let request = String.fromUtf8(buffer[0..count])
        let page = handleWebRequest(request)
        sendHttp(client, "200 OK", page)
        client.close()
    }
    return 0
}
