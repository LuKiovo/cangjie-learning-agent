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

main(): Int64 {
    let officialPath = Path("knowledge_base/official")
    let userNotesPath = Path("knowledge_base/user_notes")
    let officialCount = countKnowledgeFiles(officialPath)
    let userNotesCount = countKnowledgeFiles(userNotesPath)

    println("Cangjie Learning Agent")
    println("Status: project skeleton is ready.")
    println("Knowledge base:")
    println("- official: knowledge_base/official")
    println("- user notes: knowledge_base/user_notes")
    println("Knowledge files:")
    println("- official: ${officialCount}")
    println("- user notes: ${userNotesCount}")
    println("Sources:")
    printKnowledgeFiles("official", officialPath)
    printKnowledgeFiles("user notes", userNotesPath)
    return 0
}
