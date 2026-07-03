package cangjie_learning_agent

import std.env.*
import std.fs.*

func printHelp(): Unit {
    println("Cangjie Learning Agent commands:")
    println("- ask <question>: ask a Cangjie syntax question")
    println("- practice <topic>: generate a source-backed practice task")
    println("- quiz <topic>: generate a source-backed mini quiz")
    println("- example <topic>: generate a source-backed Cangjie example draft")
    println("- stats: show local knowledge base statistics")
    println("- sources <keyword>: list matched source files only")
    println("- show-source <keyword>: print the first matched source content")
    println("- prompt <question>: preview a source-backed LLM prompt")
    println("- review-error <keyword>: review local compiler error notes")
    println("- fix-error <keyword>: generate a source-backed error fix suggestion")
    println("- demo: show a recommended classroom demo flow")
    println("- summary: show implemented capabilities and current limits")
    println("- version: show project version and engineering identity")
    println("- llm-status: show LLM API configuration status")
    println("- <keyword>: search local knowledge files")
    println("- add-note <name> <content>: add a syntax note")
    println("- add-example <name> <content>: add example code notes")
    println("- add-error <name> <content>: add compiler error notes")
    println("- add-official <name> <content>: add official or course-summary knowledge")
    println("- import-note <name> <file-path>: import a .md or .txt syntax note")
    println("- import-example <name> <file-path>: import a .md or .txt example note")
    println("- import-error <name> <file-path>: import a .md or .txt error note")
    println("- import-official <name> <file-path>: import a .md or .txt official/course file")
    println("- categories: show local knowledge categories")
    println("- help: show command help")
}

func printKnowledgeCategories(): Unit {
    println("Knowledge categories:")
    println("- official: knowledge_base/official")
    println("- syntax notes: knowledge_base/user_notes/syntax_notes")
    println("- examples: knowledge_base/user_notes/examples")
    println("- errors: knowledge_base/user_notes/errors")
}

func printUsageError(command: String, usage: String): Unit {
    println("Invalid command usage: ${command}")
    println("Usage: ${usage}")
    println("Tip: use help to show all commands.")
}

func printNameError(name: String): Unit {
    println("Invalid knowledge name: ${name}")
    println("Use a simple file name without path separators or '..'.")
}

func printImportFileError(sourcePath: String): Unit {
    println("Invalid import file: ${sourcePath}")
    println("Use an existing .md or .txt file.")
}

func printKnowledgeStats(officialCount: Int64, userNotesCount: Int64, officialCharacters: Int64, userNotesCharacters: Int64): Unit {
    println("Knowledge files:")
    println("- official: ${officialCount}")
    println("- user notes: ${userNotesCount}")
    println("Knowledge characters:")
    println("- official: ${officialCharacters}")
    println("- user notes: ${userNotesCharacters}")
}

func printProjectSummary(officialCount: Int64, userNotesCount: Int64, officialCharacters: Int64, userNotesCharacters: Int64): Unit {
    println("Project summary:")
    println("Target user: Cangjie beginners")
    println("Implementation language: Cangjie")
    println("Knowledge base: local .md and .txt files")
    printKnowledgeStats(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
    println("Implemented capabilities:")
    println("- source-backed syntax question answering")
    println("- source-backed prompt preview for future LLM API calls")
    println("- examples, quizzes, practice tasks, error review, and error fix suggestions")
    println("- personalized notes, examples, error notes, and official/course summaries")
    println("- .md and .txt import for personalized and official/course knowledge")
    println("- matched source listing, source content inspection, and scored primary source selection")
    println("Current limits:")
    println("- no real LLM API request yet")
    println("- no desktop GUI or web UI yet")
    println("- no PDF-to-text import inside the Cangjie app yet")
    println("- no vector search yet")
}

func printVersion(): Unit {
    println("Cangjie Learning Agent")
    println("Version: 0.1.0")
    println("Repository: cangjie-learning-agent")
    println("Implementation language: Cangjie")
    println("Knowledge format: local .md and .txt files")
}

func joinArgs(args: Array<String>, startIndex: Int64): String {
    var text = ""
    var index = startIndex
    while (index < args.size) {
        if (!text.isEmpty()) {
            text += " "
        }
        text += args[index]
        index += 1
    }
    return text
}

func findBestLocalSource(officialPath: Path, userNotesPath: Path, query: String, terms: Array<String>, startIndex: Int64): String {
    let officialScore = findBestKnowledgeScore(officialPath, query, terms, startIndex)
    let userNotesScore = findBestKnowledgeScore(userNotesPath, query, terms, startIndex)
    if (officialScore >= userNotesScore && officialScore > 0) {
        return findKnowledgeSourceByScore(officialPath, query, terms, startIndex, officialScore)
    }
    if (userNotesScore > 0) {
        return findKnowledgeSourceByScore(userNotesPath, query, terms, startIndex, userNotesScore)
    }
    return ""
}

main(): Int64 {
    let args = getCommandLine()
    let officialPath = Path("knowledge_base/official")
    let userNotesPath = Path("knowledge_base/user_notes")

    if (args.size > 1 && args[1] == "help") {
        printHelp()
        return 0
    }

    if (args.size > 1 && args[1] == "demo") {
        println("Recommended demo flow:")
        println("1. target\\manual\\main.exe help")
        println("2. target\\manual\\main.exe summary")
        println("3. target\\manual\\main.exe stats")
        println("4. target\\manual\\main.exe sources ArrayList")
        println("5. target\\manual\\main.exe show-source ArrayList")
        println("6. target\\manual\\main.exe ask match")
        println("7. target\\manual\\main.exe prompt match")
        println("8. target\\manual\\main.exe example ArrayList")
        println("9. target\\manual\\main.exe practice ArrayList")
        println("10. target\\manual\\main.exe quiz ArrayList")
        println("11. target\\manual\\main.exe review-error Cangjie-error-note")
        println("12. target\\manual\\main.exe fix-error Cangjie-error-note")
        println("13. target\\manual\\main.exe add-note my_note Cangjie-my-note")
        println("14. target\\manual\\main.exe ask Cangjie-my-note")
        println("15. target\\manual\\main.exe add-official course_if_note Cangjie-if-expression-note")
        println("16. target\\manual\\main.exe categories")
        return 0
    }

    if (args.size > 1 && args[1] == "llm-status") {
        printLlmStatus()
        return 0
    }

    if (args.size > 1 && args[1] == "categories") {
        printKnowledgeCategories()
        return 0
    }

    if (args.size > 1 && args[1] == "version") {
        printVersion()
        return 0
    }

    if (args.size > 1 && args[1] == "ask" && args.size <= 2) {
        printUsageError("ask", "target\\manual\\main.exe ask <question>")
        return 1
    }

    if (args.size > 1 && args[1] == "practice" && args.size <= 2) {
        printUsageError("practice", "target\\manual\\main.exe practice <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "quiz" && args.size <= 2) {
        printUsageError("quiz", "target\\manual\\main.exe quiz <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "example" && args.size <= 2) {
        printUsageError("example", "target\\manual\\main.exe example <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "sources" && args.size <= 2) {
        printUsageError("sources", "target\\manual\\main.exe sources <keyword>")
        return 1
    }

    if (args.size > 1 && args[1] == "show-source" && args.size <= 2) {
        printUsageError("show-source", "target\\manual\\main.exe show-source <keyword>")
        return 1
    }

    if (args.size > 1 && args[1] == "prompt" && args.size <= 2) {
        printUsageError("prompt", "target\\manual\\main.exe prompt <question>")
        return 1
    }

    if (args.size > 1 && args[1] == "review-error" && args.size <= 2) {
        printUsageError("review-error", "target\\manual\\main.exe review-error <keyword>")
        return 1
    }

    if (args.size > 1 && args[1] == "fix-error" && args.size <= 2) {
        printUsageError("fix-error", "target\\manual\\main.exe fix-error <keyword>")
        return 1
    }

    if (args.size > 1 && args[1] == "add-note" && args.size <= 3) {
        printUsageError("add-note", "target\\manual\\main.exe add-note <name> <content>")
        return 1
    }

    if (args.size > 1 && args[1] == "add-example" && args.size <= 3) {
        printUsageError("add-example", "target\\manual\\main.exe add-example <name> <content>")
        return 1
    }

    if (args.size > 1 && args[1] == "add-error" && args.size <= 3) {
        printUsageError("add-error", "target\\manual\\main.exe add-error <name> <content>")
        return 1
    }

    if (args.size > 1 && args[1] == "add-official" && args.size <= 3) {
        printUsageError("add-official", "target\\manual\\main.exe add-official <name> <content>")
        return 1
    }

    if (args.size > 1 && args[1] == "import-note" && args.size <= 3) {
        printUsageError("import-note", "target\\manual\\main.exe import-note <name> <file-path>")
        return 1
    }

    if (args.size > 1 && args[1] == "import-example" && args.size <= 3) {
        printUsageError("import-example", "target\\manual\\main.exe import-example <name> <file-path>")
        return 1
    }

    if (args.size > 1 && args[1] == "import-error" && args.size <= 3) {
        printUsageError("import-error", "target\\manual\\main.exe import-error <name> <file-path>")
        return 1
    }

    if (args.size > 1 && args[1] == "import-official" && args.size <= 3) {
        printUsageError("import-official", "target\\manual\\main.exe import-official <name> <file-path>")
        return 1
    }

    if (args.size > 3 && args[1] == "add-note") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let notePath = addUserKnowledge("syntax_notes", args[2], joinArgs(args, 3))
        println("Added syntax note: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "add-official") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let notePath = addOfficialKnowledge(args[2], joinArgs(args, 3))
        println("Added official knowledge: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "add-example") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let notePath = addUserKnowledge("examples", args[2], joinArgs(args, 3))
        println("Added example: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "add-error") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let notePath = addUserKnowledge("errors", args[2], joinArgs(args, 3))
        println("Added error note: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "import-note") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourcePath = joinArgs(args, 3)
        if (!canImportKnowledgeFile(sourcePath)) {
            printImportFileError(sourcePath)
            return 1
        }
        let notePath = importUserKnowledge("syntax_notes", args[2], sourcePath)
        println("Imported syntax note: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "import-example") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourcePath = joinArgs(args, 3)
        if (!canImportKnowledgeFile(sourcePath)) {
            printImportFileError(sourcePath)
            return 1
        }
        let notePath = importUserKnowledge("examples", args[2], sourcePath)
        println("Imported example: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "import-error") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourcePath = joinArgs(args, 3)
        if (!canImportKnowledgeFile(sourcePath)) {
            printImportFileError(sourcePath)
            return 1
        }
        let notePath = importUserKnowledge("errors", args[2], sourcePath)
        println("Imported error note: ${notePath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "import-official") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourcePath = joinArgs(args, 3)
        if (!canImportKnowledgeFile(sourcePath)) {
            printImportFileError(sourcePath)
            return 1
        }
        let notePath = importOfficialKnowledge(args[2], sourcePath)
        println("Imported official knowledge: ${notePath.toString()}")
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
    } else if (args.size > 1 && args[1] == "summary") {
        printProjectSummary(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
    } else if (args.size > 2 && args[1] == "sources") {
        let query = joinArgs(args, 2)
        println("Source query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, query, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, query, args, 2)
        println("Total matches: ${officialMatches + userNotesMatches}")
    } else if (args.size > 2 && args[1] == "show-source") {
        let query = joinArgs(args, 2)
        println("Source query: ${query}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, query, args, 2)
        printPrimarySource(primarySource)
        printFirstKnowledgeSourceText(primarySource)
    } else if (args.size > 2 && args[1] == "review-error") {
        let keyword = joinArgs(args, 2)
        println("Error keyword: ${keyword}")
        println("Matched error sources:")
        let errorMatches = searchKnowledgeFilesByTerms("error notes", Path("knowledge_base/user_notes/errors"), keyword, args, 2)
        println("Total matches: ${errorMatches}")
        let errorPath = Path("knowledge_base/user_notes/errors")
        let errorScore = findBestKnowledgeScore(errorPath, keyword, args, 2)
        let primarySource = findKnowledgeSourceByScore(errorPath, keyword, args, 2, errorScore)
        printErrorReview(keyword, errorMatches, primarySource)
    } else if (args.size > 2 && args[1] == "fix-error") {
        let keyword = joinArgs(args, 2)
        println("Error keyword: ${keyword}")
        println("Matched error sources:")
        let errorPath = Path("knowledge_base/user_notes/errors")
        let errorMatches = searchKnowledgeFilesByTerms("error notes", errorPath, keyword, args, 2)
        println("Total matches: ${errorMatches}")
        let errorScore = findBestKnowledgeScore(errorPath, keyword, args, 2)
        let primarySource = findKnowledgeSourceByScore(errorPath, keyword, args, 2, errorScore)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printErrorFix(keyword, errorMatches, primarySource, sourceText)
    } else if (args.size > 2 && args[1] == "prompt") {
        let query = joinArgs(args, 2)
        println("Question: ${query}")
        println("Search query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, query, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, query, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, query, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printPromptPreview(query, totalMatches, primarySource, sourceText)
    } else if (args.size > 2 && args[1] == "ask") {
        let query = joinArgs(args, 2)
        println("Question: ${query}")
        println("Search query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, query, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, query, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, query, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printAgentAnswer(totalMatches, primarySource, sourceText)
    } else if (args.size > 2 && args[1] == "practice") {
        let topic = joinArgs(args, 2)
        println("Practice topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        printPractice(topic, totalMatches, primarySource)
    } else if (args.size > 2 && args[1] == "quiz") {
        let topic = joinArgs(args, 2)
        println("Quiz topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printQuiz(topic, totalMatches, primarySource, sourceText)
    } else if (args.size > 2 && args[1] == "example") {
        let topic = joinArgs(args, 2)
        println("Example topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printExample(topic, totalMatches, primarySource, sourceText)
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
        println("Tip: use quiz <topic> to generate a source-backed mini quiz.")
        println("Tip: use example <topic> to generate a source-backed Cangjie example draft.")
        println("Tip: use stats to show local knowledge base statistics.")
        println("Tip: use sources <keyword> to list matched source files only.")
        println("Tip: use show-source <keyword> to print the first matched source content.")
        println("Tip: use prompt <question> to preview a source-backed LLM prompt.")
        println("Tip: use review-error <keyword> to review compiler error notes.")
        println("Tip: use fix-error <keyword> to generate a source-backed error fix suggestion.")
        println("Tip: use demo to show a recommended classroom demo flow.")
        println("Tip: use summary to show implemented capabilities and current limits.")
        println("Tip: use version to show project version and engineering identity.")
        println("Tip: use llm-status to check LLM API configuration.")
        println("Tip: pass a keyword after the executable to search local knowledge files.")
        println("Tip: use add-note <name> <content> to add a syntax note.")
        println("Tip: use add-example <name> <content> to add example code notes.")
        println("Tip: use add-error <name> <content> to add compiler error notes.")
        println("Tip: use add-official <name> <content> to add official or course-summary knowledge.")
        println("Tip: use import-note <name> <file-path> to import a .md or .txt syntax note.")
        println("Tip: use import-example <name> <file-path> to import a .md or .txt example note.")
        println("Tip: use import-error <name> <file-path> to import a .md or .txt error note.")
        println("Tip: use import-official <name> <file-path> to import a .md or .txt official/course file.")
        println("Tip: use categories to show local knowledge categories.")
        println("Tip: use help to show all commands.")
    }
    return 0
}
