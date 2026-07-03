package cangjie_learning_agent

import std.fs.*

func isKnowledgeFile(name: String): Bool {
    return name.endsWith(".md") || name.endsWith(".txt")
}

func countKnowledgeFiles(path: Path): Int64 {
    if (!exists(path)) {
        return 0
    }

    var count: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            count += countKnowledgeFiles(item.path)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            count += 1
        }
    }
    return count
}

func readKnowledgeText(path: Path): String {
    let bytes = File.readFrom(path)
    return String.fromUtf8(bytes)
}

func countKnowledgeCharacters(path: Path): Int64 {
    if (!exists(path)) {
        return 0
    }

    var count: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            count += countKnowledgeCharacters(item.path)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            count += text.size
        }
    }
    return count
}

func printKnowledgeFiles(label: String, path: Path): Unit {
    if (!exists(path)) {
        return
    }

    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            printKnowledgeFiles(label, item.path)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            println("- ${label}: ${item.path.toString()}")
        }
    }
}

func searchKnowledgeFiles(label: String, path: Path, query: String): Int64 {
    if (!exists(path)) {
        return 0
    }

    var matches: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            matches += searchKnowledgeFiles(label, item.path, query)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (text.contains(query)) {
                println("- ${label}: ${item.path.toString()}")
                matches += 1
            }
        }
    }
    return matches
}

func findFirstKnowledgeSource(path: Path, query: String): String {
    if (!exists(path)) {
        return ""
    }

    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            let source = findFirstKnowledgeSource(item.path, query)
            if (!source.isEmpty()) {
                return source
            }
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (text.contains(query)) {
                return item.path.toString()
            }
        }
    }
    return ""
}

func addUserKnowledge(category: String, name: String, content: String): Path {
    let path = Path("knowledge_base/user_notes").join(category).join(name + ".md")
    File.writeTo(path, content.toArray())
    return path
}

func addOfficialKnowledge(name: String, content: String): Path {
    let path = Path("knowledge_base/official").join(name + ".md")
    File.writeTo(path, content.toArray())
    return path
}
