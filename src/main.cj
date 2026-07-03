package cangjie_learning_agent

import std.env.*
import std.fs.*

func printHelp(): Unit {
    println("Cangjie Learning Agent commands:")
    println("- ask <question>: ask a Cangjie syntax question")
    println("- practice <topic>: generate a source-backed practice task")
    println("- stats: show local knowledge base statistics")
    println("- sources <keyword>: list matched source files only")
    println("- <keyword>: search local knowledge files")
    println("- add-note <name> <content>: add a syntax note")
    println("- add-example <name> <content>: add example code notes")
    println("- add-error <name> <content>: add compiler error notes")
    println("- help: show command help")
}

func printKnowledgeStats(officialCount: Int64, userNotesCount: Int64, officialCharacters: Int64, userNotesCharacters: Int64): Unit {
    println("Knowledge files:")
    println("- official: ${officialCount}")
    println("- user notes: ${userNotesCount}")
    println("Knowledge characters:")
    println("- official: ${officialCharacters}")
    println("- user notes: ${userNotesCharacters}")
}

main(): Int64 {
    let args = getCommandLine()
    let officialPath = Path("knowledge_base/official")
    let userNotesPath = Path("knowledge_base/user_notes")

    if (args.size > 1 && args[1] == "help") {
        printHelp()
        return 0
    }

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
    printKnowledgeStats(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
    if (args.size > 1 && args[1] == "stats") {
        return 0
    } else if (args.size > 2 && args[1] == "sources") {
        let query = args[2]
        println("Source query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFiles("official", officialPath, query)
        let userNotesMatches = searchKnowledgeFiles("user notes", userNotesPath, query)
        println("Total matches: ${officialMatches + userNotesMatches}")
    } else if (args.size > 2 && args[1] == "ask") {
        let query = args[2]
        println("Question: ${query}")
        println("Search query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFiles("official", officialPath, query)
        let userNotesMatches = searchKnowledgeFiles("user notes", userNotesPath, query)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        printAgentAnswer(totalMatches)
    } else if (args.size > 2 && args[1] == "practice") {
        let topic = args[2]
        println("Practice topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFiles("official", officialPath, topic)
        let userNotesMatches = searchKnowledgeFiles("user notes", userNotesPath, topic)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        printPractice(topic, totalMatches)
    } else if (args.size > 1) {
        let query = args[1]
        println("Search query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFiles("official", officialPath, query)
        let userNotesMatches = searchKnowledgeFiles("user notes", userNotesPath, query)
        println("Total matches: ${officialMatches + userNotesMatches}")
    } else {
        println("Sources:")
        printKnowledgeFiles("official", officialPath)
        printKnowledgeFiles("user notes", userNotesPath)
        println("Search query: none")
        println("Tip: use ask <question> to ask a Cangjie syntax question.")
        println("Tip: use practice <topic> to generate a practice task.")
        println("Tip: use stats to show local knowledge base statistics.")
        println("Tip: use sources <keyword> to list matched source files only.")
        println("Tip: pass a keyword after the executable to search local knowledge files.")
        println("Tip: use add-note <name> <content> to add a syntax note.")
        println("Tip: use add-example <name> <content> to add example code notes.")
        println("Tip: use add-error <name> <content> to add compiler error notes.")
        println("Tip: use help to show all commands.")
    }
    return 0
}
