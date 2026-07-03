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

func buildKnowledgeIndex(label: String, path: Path): String {
    if (!exists(path)) {
        return ""
    }

    var text = ""
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            text += buildKnowledgeIndex(label, item.path)
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            text += "- ${label}: ${item.path.toString()}\n"
        }
    }
    return text
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
    return queryMatchScore(text, query, terms, startIndex) > 0
}

func queryMatchScore(text: String, query: String, terms: Array<String>, startIndex: Int64): Int64 {
    var score: Int64 = 0
    if (text.contains(query)) {
        score += 10
    }
    var index = startIndex
    while (index < terms.size) {
        if (text.contains(terms[index])) {
            score += 1
        }
        index += 1
    }
    return score
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

func findBestKnowledgeScore(path: Path, query: String, terms: Array<String>, startIndex: Int64): Int64 {
    if (!exists(path)) {
        return 0
    }

    var bestScore: Int64 = 0
    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            let childScore = findBestKnowledgeScore(item.path, query, terms, startIndex)
            if (childScore > bestScore) {
                bestScore = childScore
            }
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            let score = queryMatchScore(text, query, terms, startIndex)
            if (score > bestScore) {
                bestScore = score
            }
        }
    }
    return bestScore
}

func findKnowledgeSourceByScore(path: Path, query: String, terms: Array<String>, startIndex: Int64, targetScore: Int64): String {
    if (!exists(path) || targetScore <= 0) {
        return ""
    }

    let items = Directory.readFrom(path)
    for (item in items) {
        if (item.isDirectory()) {
            let source = findKnowledgeSourceByScore(item.path, query, terms, startIndex, targetScore)
            if (!source.isEmpty()) {
                return source
            }
        } else if (item.isRegular() && isKnowledgeFile(item.name)) {
            let text = readKnowledgeText(item.path)
            if (queryMatchScore(text, query, terms, startIndex) == targetScore) {
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

func canImportKnowledgeFile(sourcePath: String): Bool {
    let path = Path(sourcePath)
    return exists(path) && isKnowledgeFile(sourcePath)
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

func importUserKnowledge(category: String, name: String, sourcePath: String): Path {
    let content = readKnowledgeText(Path(sourcePath))
    return addUserKnowledge(category, name, content)
}

func importOfficialKnowledge(name: String, sourcePath: String): Path {
    let content = readKnowledgeText(Path(sourcePath))
    return addOfficialKnowledge(name, content)
}
