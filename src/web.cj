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

func jsStringEscape(text: String): String {
    return text
        .replace("\\", "\\\\")
        .replace("'", "\\'")
        .replace("\r", " ")
        .replace("\n", " ")
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

    var text = ""
    if (mode == "api") {
        text += buildLlmApiAnswerText(question, totalMatches, primarySource, sourceText)
    } else {
        text += buildAnswerReportText(question, totalMatches, primarySource, sourceText)
    }
    text += "\n诊断信息\n\n"
    text += "Question: ${question}\n"
    text += "Mode: ${mode}\n"
    text += "Matched sources: ${totalMatches}\n"
    if (!primarySource.isEmpty()) {
        text += "Primary source: ${primarySource}\n"
    } else {
        text += "Primary source: none\n"
    }
    return text
}

func addWebNote(name: String, content: String): String {
    if (!isSafeKnowledgeName(name)) {
        return "Invalid note name. Use a simple file name without path separators or '..'."
    }
    addUserKnowledge("syntax_notes", name, content)
    return "笔记已经保存"
}

func webHistoryPath(): Path {
    return Path(".local_state").join("web_history.txt")
}

func ensureWebStateDirectory(): Unit {
    let path = Path(".local_state")
    if (!exists(path)) {
        Directory.create(path, recursive: true)
    }
}

func cleanHistoryField(text: String): String {
    return text.replace("\r", " ").replace("\n", " ").replace("\t", " ")
}

func appendWebHistory(question: String, mode: String): Unit {
    ensureWebStateDirectory()
    let path = webHistoryPath()
    let nextLine = cleanHistoryField(mode) + "\t" + cleanHistoryField(question)
    var text = ""
    if (exists(path)) {
        text = readKnowledgeText(path)
        let lines = text.split("\n")
        var index = lines.size - 1
        while (index >= 0) {
            let line = lines[index]
            if (!line.isEmpty()) {
                if (line == nextLine) {
                    return
                }
                break
            }
            index -= 1
        }
    }
    text += nextLine
    text += "\n"
    File.writeTo(path, text.toArray())
}

func readWebHistoryText(): String {
    let path = webHistoryPath()
    if (!exists(path)) {
        return ""
    }
    return readKnowledgeText(path)
}

func buildHistoryHtml(): String {
    let text = readWebHistoryText()
    if (text.isEmpty()) {
        return "<div class='emptyHistory'>还没有历史记录</div>"
    }
    let lines = text.split("\n")
    var startIndex: Int64 = 0
    if (lines.size > 20) {
        startIndex = lines.size - 20
    }
    var index = lines.size - 1
    var html = ""
    while (index >= startIndex) {
        let line = lines[index]
        if (!line.isEmpty()) {
            let parts = line.split("\t")
            let mode = if (parts.size > 0) { parts[0] } else { "local" }
            let question = if (parts.size > 1) { parts[1] } else { line }
            html += "<form class='historyItem' method='post' action='/ask-frame' target='answerFrame' onsubmit=\"return parent.prepareHistoryAsk('${htmlEscape(jsStringEscape(question))}','${htmlEscape(jsStringEscape(mode))}',this)\">"
            html += "<input type='hidden' name='question' value='${htmlEscape(question)}'>"
            html += "<input type='hidden' name='mode' value='${htmlEscape(mode)}'>"
            html += "<input type='hidden' name='recordHistory' value='0'>"
            html += "<button type='submit'><span>${htmlEscape(question)}</span><small>${htmlEscape(mode)}</small></button>"
            html += "</form>"
        }
        index -= 1
    }
    return html
}

func buildHistoryFramePage(): String {
    var html = "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'>"
    html += "<style>"
    html += "*{box-sizing:border-box}body{margin:0;background:transparent;font-family:Arial,'Microsoft YaHei',sans-serif}.history{display:flex;flex-direction:column;gap:8px;padding-right:2px}.emptyHistory{border:1px dashed #cbd1ce;border-radius:12px;padding:14px;color:#777;background:rgba(255,255,255,.45)}"
    html += ".historyItem{margin:0}.historyItem button{width:100%;border:1px solid #d9dddb;background:rgba(255,255,255,.72);border-radius:12px;padding:10px 12px;text-align:left;cursor:pointer;font-family:inherit}.historyItem button:hover{background:#fff}.historyItem span{display:block;font-size:14px;font-weight:800;color:#292d30;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.historyItem small{display:block;font-size:11px;color:#7a7f83;margin-top:3px}"
    html += "</style></head><body><section class='history'>${buildHistoryHtml()}</section></body></html>"
    return html
}

func buildAnswerContentHtml(answer: String): String {
    if (answer.isEmpty()) {
        return "<section class='answer emptyAnswer'><h2>回答与来源</h2><p>回答将在这里显示。</p></section>"
    }
    let sourceIndex = answer.indexOf("资料来源") ?? -1
    let diagnosticIndex = answer.indexOf("诊断信息") ?? -1
    var mainText = answer
    var metaText = ""
    if (sourceIndex >= 0) {
        mainText = answer[0..sourceIndex]
        metaText = answer[sourceIndex..answer.size]
    } else if (diagnosticIndex >= 0) {
        mainText = answer[0..diagnosticIndex]
        metaText = answer[diagnosticIndex..answer.size]
    }
    var html = "<section class='answer'><h2>回答与来源</h2>"
    html += "<pre class='answerMain'>${htmlEscape(mainText)}</pre>"
    if (!metaText.isEmpty()) {
        html += "<pre class='answerMeta'>${htmlEscape(metaText)}</pre>"
    }
    html += "</section>"
    return html
}

func buildAnswerFramePage(answer: String): String {
    var html = "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'>"
    html += "<style>"
    html += "*{box-sizing:border-box}body{margin:0;background:transparent;color:#24272a;font-family:Arial,'Microsoft YaHei',sans-serif}.answer{min-height:330px;text-align:left;background:rgba(255,255,255,.88);border:1px solid #dfe2e1;border-radius:18px;box-shadow:0 10px 24px rgba(31,35,40,.07);padding:18px;overflow:auto}.answer h2{font-size:18px;margin:0 0 12px}.answerMain{margin:0;white-space:pre-wrap;font:16px/1.75 Consolas,'Microsoft YaHei',monospace;color:#202124}.answerMeta{margin:18px 0 0;padding-top:14px;border-top:1px solid #e4e7e5;white-space:pre-wrap;font:12px/1.55 Consolas,'Microsoft YaHei',monospace;color:#6a6f73}.emptyAnswer p{margin:0;color:#777;font-size:14px}"
    html += "</style></head><body>${buildAnswerContentHtml(answer)}</body></html>"
    return html
}

func buildWebPage(answer: String, notice: String): String {
    let endpoint = configuredLlmEndpoint()
    let modelReady = isConfigured(envOrDefault("CANGJIE_AGENT_LLM_MODEL", ""))
    let keyReady = isConfigured(envOrDefault("CANGJIE_AGENT_API_KEY", ""))
    let answerFrameSource = if (answer.isEmpty()) { "/answer-frame" } else { "/answer-frame" }
    var html = "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'>"
    html += "<meta name='viewport' content='width=device-width,initial-scale=1'>"
    html += "<title>Cangjie Agent</title>"
    html += "<style>"
    html += ":root{--bg:#fbfbfa;--panel:#eef0ef;--panel2:#e4e7e5;--line:#d9dddb;--text:#202124;--muted:#686d70;--soft:#ffffff;--ink:#17181a}"
    html += "*{box-sizing:border-box}body{margin:0;background:radial-gradient(#d5dad7 1px,transparent 1px) 0 0/18px 18px,var(--bg);color:var(--text);font-family:Arial,'Microsoft YaHei',sans-serif}"
    html += ".app{min-height:100vh;display:grid;grid-template-columns:350px 1fr}.brandTop{position:fixed;left:22px;top:18px;font-size:28px;font-weight:900;letter-spacing:0}.beta{font-size:12px;border:1px solid #222;border-radius:999px;padding:3px 8px;margin-left:8px;vertical-align:middle}"
    html += ".side{margin:72px 0 18px 16px;border:1px solid var(--line);border-radius:18px;background:rgba(236,239,237,.9);box-shadow:0 10px 30px rgba(31,35,40,.08);padding:18px;display:flex;flex-direction:column;gap:16px;min-height:calc(100vh - 90px)}"
    html += ".sideTitle{display:flex;align-items:flex-end;justify-content:space-between;gap:12px}.sideTitle h2{margin:0;font-size:22px}.sideTitle span{font-size:12px;color:#6b7074}.historyFrame{width:100%;height:318px;border:0;background:transparent}"
    html += ".historyItem{margin:0}.historyItem button{width:100%;border:1px solid #d9dddb;background:rgba(255,255,255,.72);border-radius:12px;padding:10px 12px;text-align:left;cursor:pointer;font-family:inherit}.historyItem button:hover{background:#fff}.historyMode{display:block;font-size:11px;color:#7a7f83;margin-bottom:3px}.historyQuestion{display:block;font-size:14px;font-weight:800;color:#292d30;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}"
    html += ".noteBox{margin-top:4px;background:#202124;color:#fff;border-radius:18px;padding:16px;box-shadow:0 14px 30px rgba(31,35,40,.12)}.noteBox h2{margin:0 0 4px;font-size:19px}.noteBox p{margin:0 0 10px;color:#c5c9c7;font-size:13px;line-height:1.45}.noteBox input,.noteBox textarea{width:100%;border:1px solid #414448;background:#2b2d30;color:#fff;border-radius:12px;padding:10px;margin-top:8px;font-family:inherit}.noteBox input::placeholder,.noteBox textarea::placeholder{color:#a8adb0}.noteBox textarea{height:78px;resize:none}.noteBox button{border:0;border-radius:999px;background:#fff;color:#202124;padding:9px 15px;font-weight:900;margin-top:10px}.noteMsg{font-size:12px;color:#d9dcda;margin-top:8px;line-height:1.45}.sideFoot{margin-top:auto;font-size:13px;color:#666}"
    html += ".main{min-width:0;position:relative;padding:24px 30px}.hero{min-height:640px;display:flex;align-items:flex-start;justify-content:center;padding-top:130px}.center{width:min(860px,100%);text-align:center}h1{font-size:72px;line-height:1;margin:0 0 34px;letter-spacing:0;font-weight:500}"
    html += ".composer{background:#e6e9e8;border:1px solid #cfd4d1;border-radius:24px;box-shadow:0 12px 34px rgba(31,35,40,.1);padding:18px;text-align:left}.composer textarea{width:100%;height:106px;border:0;outline:0;resize:none;background:transparent;font-size:19px;line-height:1.5;font-family:inherit;color:#2f3337}.composer textarea::placeholder{color:#858b8f}.bar{display:flex;align-items:center;gap:10px;margin-top:14px}.mode{display:flex;background:#dde1df;border-radius:999px;padding:4px}.mode select{border:0;background:#fff;border-radius:999px;padding:9px 16px;font-weight:900;outline:0}.status{margin-left:auto;display:flex;gap:8px;align-items:center;color:#555;font-size:13px}.send{width:44px;height:44px;border:0;border-radius:50%;background:#202124;color:#fff;font-size:21px;font-weight:900;cursor:pointer}"
    html += ".tools{margin:12px auto 0;color:#6a6f73;font-size:12px;max-width:760px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.tools span{font-weight:900;color:#303336;margin-right:8px}.answerFrame{margin:28px auto 0;width:100%;height:380px;border:0;background:transparent}"
    html += ".savedPopup{position:fixed;inset:0;background:rgba(32,33,36,.18);display:flex;align-items:center;justify-content:center;z-index:8}.savedPopupBox{background:#fff;border:1px solid #dfe2e1;border-radius:18px;box-shadow:0 18px 44px rgba(31,35,40,.18);padding:24px 32px;text-align:center}.savedPopupBox b{display:block;font-size:22px;margin-bottom:14px}.savedPopupBox a{display:inline-block;border-radius:999px;background:#202124;color:#fff;text-decoration:none;padding:9px 18px;font-weight:900}"
    html += "@media(max-width:980px){.app{grid-template-columns:1fr}.brandTop{position:static;padding:16px 16px 0}.side{margin:14px 16px;min-height:auto}.main{padding:16px}.hero{min-height:auto;padding:42px 0}h1{font-size:42px}.composer textarea{height:112px}.status{display:none}}"
    html += "</style></head><body><div class='brandTop'>Cangjie <span class='beta'>AGENT</span></div><div class='app'>"
    html += "<aside class='side'><div class='sideTitle'><h2>历史记录</h2><span>最近 20 条</span></div><iframe class='historyFrame' name='historyFrame' src='/history-frame'></iframe>"
    html += "<section class='noteBox'><h2>新增语法笔记</h2><p>保存后进入本地知识库，下一次提问可检索。</p><form method='post' action='/note'><input name='name' placeholder='笔记文件名，例如 web_note'><textarea name='content' placeholder='这里写你的仓颉语法笔记'></textarea><button type='submit'>保存笔记</button></form><div class='noteMsg'>${htmlEscape(notice)}</div></section>"
    html += "<div class='sideFoot'>仓颉实现 · 本地 .md/.txt · 来源标注</div></aside>"
    html += "<main class='main'><section class='hero'><div class='center'><h1>Welcome to Cangjie.</h1>"
    html += "<form class='composer' method='post' action='/ask-frame' target='answerFrame' onsubmit='return prepareAsk(this)'><textarea id='questionInput' name='question' placeholder='请输入你的仓颉语法问题'></textarea><input type='hidden' name='recordHistory' value='1'><div class='bar'><div class='mode'><select id='modeSelect' name='mode'><option value='local'>本地回答</option><option value='api'>API 回答</option></select></div><div class='status'>Model ${modelReady} · Key ${keyReady}</div><button class='send' type='submit'>↑</button></div></form>"
    html += "<div class='tools'><span>Endpoint</span>${htmlEscape(endpoint)}</div>"
    html += "<iframe class='answerFrame' name='answerFrame' src='${answerFrameSource}'></iframe>"
    html += "</div></section></main></div>"
    html += "<script>"
    html += "var historyRefreshPending=false;var thinkingFrameLoading=false;"
    html += "function showThinking(){var f=document.getElementsByName('answerFrame')[0];if(f){thinkingFrameLoading=true;f.srcdoc='<!doctype html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><style>body{margin:0;background:transparent;font-family:Arial,\\'Microsoft YaHei\\',sans-serif}.answer{min-height:330px;text-align:left;background:rgba(255,255,255,.88);border:1px solid #dfe2e1;border-radius:18px;box-shadow:0 10px 24px rgba(31,35,40,.07);padding:18px;color:#202124}.thinking{font-size:18px;font-weight:800}</style></head><body><section class=\"answer\"><h2>回答与来源</h2><div class=\"thinking\">正在思考......</div></section></body></html>';}}"
    html += "function delayedSubmit(form){setTimeout(function(){form.submit();},120);}"
    html += "function prepareAsk(form){historyRefreshPending=true;showThinking();delayedSubmit(form);return false;}"
    html += "function prepareHistoryAsk(q,m,form){var input=document.getElementById('questionInput');var mode=document.getElementById('modeSelect');if(input){input.value=q;}if(mode){mode.value=m;}historyRefreshPending=true;showThinking();delayedSubmit(form);return false;}"
    html += "window.addEventListener('load',function(){var answer=document.getElementsByName('answerFrame')[0];if(answer){answer.addEventListener('load',function(){if(thinkingFrameLoading){thinkingFrameLoading=false;return;}if(historyRefreshPending){historyRefreshPending=false;var h=document.getElementsByName('historyFrame')[0];if(h){h.contentWindow.location.reload();}}});}});"
    html += "</script>"
    if (notice == "笔记已经保存") {
        html += "<div class='savedPopup'><div class='savedPopupBox'><b>笔记已经保存</b><a href='/'>知道了</a></div></div>"
    }
    html += "</body></html>"
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

    if (request.startsWith("GET /history-frame")) {
        return buildHistoryFramePage()
    }

    if (request.startsWith("GET /answer-frame")) {
        return buildAnswerFramePage("")
    }

    if (request.startsWith("POST /ask-frame")) {
        let question = getFormValue(body, "question")
        let mode = getFormValue(body, "mode")
        if (question.isEmpty()) {
            return buildAnswerFramePage("请输入问题。")
        }
        if (getFormValue(body, "recordHistory") != "0") {
            appendWebHistory(question, mode)
        }
        return buildAnswerFramePage(buildWebAnswer(question, mode))
    }

    if (request.startsWith("POST /ask")) {
        let question = getFormValue(body, "question")
        let mode = getFormValue(body, "mode")
        if (question.isEmpty()) {
            return buildWebPage("请输入问题。", "")
        }
        appendWebHistory(question, mode)
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
