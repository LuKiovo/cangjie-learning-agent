package cangjie_learning_agent

import std.env.*
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

func addUserKnowledge(category: String, name: String, content: String): Path {
    let path = Path("knowledge_base/user_notes").join(category).join(name + ".md")
    File.writeTo(path, content.toArray())
    return path
}

main(): Int64 {
    let args = getCommandLine()
    let officialPath = Path("knowledge_base/official")
    let userNotesPath = Path("knowledge_base/user_notes")

    if (args.size > 3 && args[1] == "add-note") {
        let notePath = addUserKnowledge("syntax_notes", args[2], args[3])
        println("Added syntax note: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "add-example") {
        let notePath = addUserKnowledge("examples", args[2], args[3])
        println("Added example: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "add-error") {
        let notePath = addUserKnowledge("errors", args[2], args[3])
        println("Added error note: ${notePath.toString()}")
        return 0
    }

    let officialCount = countKnowledgeFiles(officialPath)
    let userNotesCount = countKnowledgeFiles(userNotesPath)
    let officialCharacters = countKnowledgeCharacters(officialPath)
    let userNotesCharacters = countKnowledgeCharacters(userNotesPath)

    println("Cangjie Learning Agent")
    println("Status: project skeleton is ready.")
    println("Knowledge base:")
    println("- official: knowledge_base/official")
    println("- user notes: knowledge_base/user_notes")
    println("Knowledge files:")
    println("- official: ${officialCount}")
    println("- user notes: ${userNotesCount}")
    println("Knowledge characters:")
    println("- official: ${officialCharacters}")
    println("- user notes: ${userNotesCharacters}")
    println("Sources:")
    printKnowledgeFiles("official", officialPath)
    printKnowledgeFiles("user notes", userNotesPath)
    if (args.size > 1) {
        let query = args[1]
        println("Search query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFiles("official", officialPath, query)
        let userNotesMatches = searchKnowledgeFiles("user notes", userNotesPath, query)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        println("Agent answer:")
        if (totalMatches > 0) {
            println("I found local knowledge sources related to '${query}'. Please review the matched sources above.")
        } else {
            println("I did not find a local source for '${query}'. Add official docs or user notes, then search again.")
        }
    } else {
        println("Search query: none")
        println("Tip: pass a keyword after the executable to search local knowledge files.")
        println("Tip: use add-note <name> <content> to add a syntax note.")
        println("Tip: use add-example <name> <content> to add example code notes.")
        println("Tip: use add-error <name> <content> to add compiler error notes.")
    }
    return 0
}
