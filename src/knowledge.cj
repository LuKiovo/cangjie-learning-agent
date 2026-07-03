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

func textMatchesQuery(text: String, query: String, terms: Array<String>, startIndex: Int64): Bool {
    if (text.contains(query)) {
        return true
    }

    var index = startIndex
    while (index < terms.size) {
        if (text.contains(terms[index])) {
            return true
        }
        index += 1
    }
    return false
}

func searchKnowledgeFilesByTerms(label: String, path: Path, query: String, terms: Array<String>, startIndex: Int64): Int64 {
    if (!exists(path)) {
        return 0
    }

    var matches: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            matches += searchKnowledgeFilesByTerms(label, item.path, query, terms, startIndex)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (textMatchesQuery(text, query, terms, startIndex)) {
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

func findFirstKnowledgeSourceByTerms(path: Path, query: String, terms: Array<String>, startIndex: Int64): String {
    if (!exists(path)) {
        return ""
    }

    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            let source = findFirstKnowledgeSourceByTerms(item.path, query, terms, startIndex)
            if (!source.isEmpty()) {
                return source
            }
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (textMatchesQuery(text, query, terms, startIndex)) {
                return item.path.toString()
            }
        }
    }
    return ""
}

func printFirstKnowledgeSourceText(source: String): Unit {
    if (source.isEmpty()) {
        println("Source content: none")
        return
    }

    println("Source content:")
    println(readKnowledgeText(Path(source)))
}

func readSourceTextOrEmpty(source: String): String {
    if (source.isEmpty()) {
        return ""
    }
    return readKnowledgeText(Path(source))
}

func isSafeKnowledgeName(name: String): Bool {
    return !name.isEmpty() && !name.contains("/") && !name.contains("\\") && !name.contains("..")
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
