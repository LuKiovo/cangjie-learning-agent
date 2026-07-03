package agent_flow_diagram

import std.fs.*

func box(x: Int64, y: Int64, w: Int64, h: Int64, title: String, body: String, fill: String, stroke: String): String {
    var text = ""
    text += "<rect x='${x}' y='${y}' width='${w}' height='${h}' rx='14' fill='${fill}' stroke='${stroke}' stroke-width='2'/>\n"
    text += "<text x='${x + 22}' y='${y + 34}' class='title'>${title}</text>\n"
    text += "<text x='${x + 22}' y='${y + 64}' class='body'>${body}</text>\n"
    return text
}

func arrow(x1: Int64, y1: Int64, x2: Int64, y2: Int64, label: String): String {
    var text = ""
    text += "<path d='M ${x1} ${y1} C ${x1 + 48} ${y1}, ${x2 - 48} ${y2}, ${x2} ${y2}' class='arrow'/>\n"
    if (!label.isEmpty()) {
        let lx = (x1 + x2) / 2 - 34
        let ly = (y1 + y2) / 2 - 10
        text += "<text x='${lx}' y='${ly}' class='label'>${label}</text>\n"
    }
    return text
}

func buildSvg(): String {
    var svg = ""
    svg += "<svg xmlns='http://www.w3.org/2000/svg' width='1400' height='920' viewBox='0 0 1400 920'>\n"
    svg += "<defs>\n"
    svg += "<linearGradient id='bg' x1='0' y1='0' x2='1' y2='1'><stop offset='0%' stop-color='#f6f8fb'/><stop offset='100%' stop-color='#eef7f2'/></linearGradient>\n"
    svg += "<marker id='arrowHead' markerWidth='12' markerHeight='12' refX='10' refY='6' orient='auto'><path d='M 0 0 L 12 6 L 0 12 z' fill='#25636f'/></marker>\n"
    svg += "<style>\n"
    svg += "text{font-family:Segoe UI,Arial,sans-serif}.headline{font-size:34px;font-weight:800;fill:#17323a}.subtitle{font-size:17px;fill:#51666d}.title{font-size:20px;font-weight:800;fill:#17323a}.body{font-size:15px;fill:#385158}.label{font-size:14px;font-weight:700;fill:#25636f}.arrow{fill:none;stroke:#25636f;stroke-width:3;marker-end:url(#arrowHead)}.lane{fill:#ffffff;stroke:#d7e2e5;stroke-width:1.5}.tag{font-size:13px;font-weight:700;fill:#fff}\n"
    svg += "</style>\n"
    svg += "</defs>\n"
    svg += "<rect width='1400' height='920' fill='url(#bg)'/>\n"
    svg += "<text x='70' y='72' class='headline'>Cangjie Learning Agent Flow</text>\n"
    svg += "<text x='70' y='106' class='subtitle'>Local .md/.txt knowledge base + source-backed retrieval + Cangjie engineering implementation</text>\n"
    svg += "<rect x='70' y='135' width='1260' height='650' rx='28' class='lane'/>\n"
    svg += "<rect x='92' y='156' width='190' height='30' rx='15' fill='#25636f'/><text x='115' y='177' class='tag'>Runtime Pipeline</text>\n"
    svg += box(110, 235, 230, 105, "1. User Question", "syntax / code / error / quiz", "#e8f1ff", "#5e86c7")
    svg += box(420, 235, 250, 105, "2. Command Router", "ask / session / prompt / fix", "#fff3df", "#d89a36")
    svg += box(760, 185, 250, 105, "3. Local Knowledge", "official docs + personal notes", "#ebf8ef", "#4e9b67")
    svg += box(760, 335, 250, 105, "4. Retrieval Score", "full query + keyword fallback", "#f5edff", "#8b67c7")
    svg += box(1090, 235, 220, 105, "5. Primary Source", "path + context shown", "#e9fbfb", "#3e9da0")
    svg += box(420, 520, 250, 105, "6. Prompt Preview", "grounded LLM-ready input", "#edf4ff", "#4f78bd")
    svg += box(760, 520, 250, 105, "7. Agent Output", "answer / plan / example / quiz", "#fff0f0", "#c76666")
    svg += box(1090, 520, 220, 105, "8. Personalization", "add/import notes and errors", "#f1f7e7", "#7da144")
    svg += arrow(340, 288, 420, 288, "route")
    svg += arrow(670, 288, 760, 238, "read")
    svg += arrow(885, 290, 885, 335, "scan")
    svg += arrow(1010, 388, 1090, 288, "select")
    svg += arrow(1200, 340, 545, 520, "source")
    svg += arrow(670, 572, 760, 572, "compose")
    svg += arrow(1010, 572, 1090, 572, "save")
    svg += arrow(1200, 520, 1200, 358, "improve KB")
    svg += "<rect x='110' y='820' width='1180' height='48' rx='16' fill='#17323a'/>\n"
    svg += "<text x='138' y='850' fill='#ffffff' font-size='17' font-weight='700'>Key idea: every answer is traceable to local sources, and every new note makes the next retrieval more personal.</text>\n"
    svg += "</svg>\n"
    return svg
}

main(): Int64 {
    let path = Path("agent_flow.svg")
    File.writeTo(path, buildSvg().toArray())
    println("Generated diagram: ${path.toString()}")
    return 0
}
