package cangjie_learning_agent

import std.env.*
import std.fs.*

func printHelp(): Unit {
    println("Cangjie Learning Agent commands:")
    println("- ask <question>: ask a Cangjie syntax question")
    println("- session <topic>: run a source-backed learning session")
    println("- practice <topic>: generate a source-backed practice task")
    println("- study-plan <topic>: generate a source-backed beginner study plan")
    println("- card <topic>: generate a source-backed study card")
    println("- export-card <name> <topic>: export a Markdown study card under docs")
    println("- quiz <topic>: generate a source-backed mini quiz")
    println("- example <topic>: generate a source-backed Cangjie example draft")
    println("- stats: show local knowledge base statistics")
    println("- category-stats: show knowledge file counts by category")
    println("- source-map: show local knowledge source distribution")
    println("- export-source-map <name>: export a Markdown source distribution report under docs")
    println("- dashboard: show dashboard summary")
    println("- export-dashboard <name>: export a static HTML dashboard under docs")
    println("- final-check: show final acceptance readiness")
    println("- export-final-check <name>: export a Markdown final readiness report under docs")
    println("- trace <topic>: show the source-backed agent operation trace")
    println("- export-trace <name> <topic>: export a Markdown agent trace under docs")
    println("- roadmap: show remaining engineering roadmap")
    println("- export-roadmap <name>: export a Markdown roadmap under docs")
    println("- command-sheet: show classroom command sheet")
    println("- export-command-sheet <name>: export a Markdown command sheet under docs")
    println("- delivery-index: show project delivery artifact index")
    println("- export-delivery-index <name>: export a Markdown delivery artifact index under docs")
    println("- rubric: show grading rubric alignment")
    println("- export-rubric <name>: export a Markdown grading rubric under docs")
    println("- teacher-summary: show a teacher-facing project summary")
    println("- export-teacher-summary <name>: export a Markdown teacher summary under docs")
    println("- rehearsal: show classroom rehearsal checklist")
    println("- export-rehearsal <name>: export a Markdown rehearsal checklist under docs")
    println("- sources <keyword>: list matched source files only")
    println("- why-source <keyword>: explain primary source score selection")
    println("- show-source <keyword>: print the first matched source content")
    println("- prompt <question>: preview a source-backed LLM prompt")
    println("- llm-request <question>: build a source-backed LLM request draft")
    println("- export-llm-request <name> <question>: export a Markdown LLM request draft under docs")
    println("- import-llm-response <name> <file-path>: save a .md or .txt LLM response locally")
    println("- show-llm-response <name>: print a saved LLM response")
    println("- review-error <keyword>: review local compiler error notes")
    println("- fix-error <keyword>: generate a source-backed error fix suggestion")
    println("- demo: show a recommended classroom demo flow")
    println("- summary: show implemented capabilities and current limits")
    println("- version: show project version and engineering identity")
    println("- self-check: run a local acceptance self-check")
    println("- export-report <name>: export a Markdown acceptance report under docs")
    println("- export-index <name>: export a Markdown knowledge source index under docs")
    println("- export-answer <name> <question>: export a Markdown answer report under docs")
    println("- export-session <name> <topic>: export a Markdown learning session under docs")
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

func printCategoryStats(): Unit {
    let officialCount = countKnowledgeFiles(Path("knowledge_base/official"))
    let syntaxCount = countKnowledgeFiles(Path("knowledge_base/user_notes/syntax_notes"))
    let examplesCount = countKnowledgeFiles(Path("knowledge_base/user_notes/examples"))
    let errorsCount = countKnowledgeFiles(Path("knowledge_base/user_notes/errors"))
    println("Knowledge category stats:")
    println("- official: ${officialCount}")
    println("- syntax notes: ${syntaxCount}")
    println("- examples: ${examplesCount}")
    println("- errors: ${errorsCount}")
}

func printSourceMap(): Unit {
    let officialPath = Path("knowledge_base/official")
    let syntaxPath = Path("knowledge_base/user_notes/syntax_notes")
    let examplesPath = Path("knowledge_base/user_notes/examples")
    let errorsPath = Path("knowledge_base/user_notes/errors")
    println("Knowledge source map:")
    println("- official/course: files=${countKnowledgeFiles(officialPath)}, characters=${countKnowledgeCharacters(officialPath)}")
    println("- syntax notes: files=${countKnowledgeFiles(syntaxPath)}, characters=${countKnowledgeCharacters(syntaxPath)}")
    println("- examples: files=${countKnowledgeFiles(examplesPath)}, characters=${countKnowledgeCharacters(examplesPath)}")
    println("- error notes: files=${countKnowledgeFiles(errorsPath)}, characters=${countKnowledgeCharacters(errorsPath)}")
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
    println("- source-backed LLM request drafts and local LLM response archive")
    println("- static web dashboard generated by Cangjie")
    println("- examples, quizzes, practice tasks, error review, and error fix suggestions")
    println("- source-backed study cards and Markdown study card export")
    println("- answer/session/source-map Markdown exports for classroom review")
    println("- personalized notes, examples, error notes, and official/course summaries")
    println("- .md and .txt import for personalized and official/course knowledge")
    println("- matched source listing, source content inspection, and scored primary source selection")
    println("- source-backed operation trace and engineering roadmap")
    println("- classroom command sheet and delivery artifact index")
    println("- rubric, teacher summary, and rehearsal checklist")
    println("Current limits:")
    println("- no real LLM API request yet")
    println("- no interactive desktop GUI yet")
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

func printSelfCheck(officialCount: Int64, userNotesCount: Int64): Unit {
    println("Self-check:")
    if (officialCount > 0) {
        println("PASS official knowledge files: ${officialCount}")
    } else {
        println("FAIL official knowledge files: 0")
    }
    if (userNotesCount > 0) {
        println("PASS user knowledge files: ${userNotesCount}")
    } else {
        println("FAIL user knowledge files: 0")
    }
    println("PASS implementation language: Cangjie")
    println("PASS supported knowledge formats: .md and .txt")
    println("PASS source-backed commands: ask, prompt, study-plan, card, example, practice, quiz, review-error, fix-error")
    println("PASS source-backed exports: export-answer, export-session, export-card, export-source-map, export-llm-request")
    println("PASS LLM archive commands: import-llm-response, show-llm-response")
    println("PASS web dashboard commands: dashboard, export-dashboard")
    println("PASS final readiness commands: final-check, export-final-check")
    println("PASS engineering trace commands: trace, export-trace")
    println("PASS roadmap commands: roadmap, export-roadmap")
    println("PASS delivery commands: command-sheet, export-command-sheet, delivery-index, export-delivery-index")
    println("PASS review package commands: rubric, teacher-summary, rehearsal")
    println("PASS review package exports: export-rubric, export-teacher-summary, export-rehearsal")
    println("PASS source explanation command: why-source")
    println("PASS personalization commands: add-note, add-example, add-error, add-official")
    println("PASS import commands: import-note, import-example, import-error, import-official")
    println("Manual check still needed: real LLM HTTP transport and interactive desktop GUI are not completed.")
}

func buildReportText(officialCount: Int64, userNotesCount: Int64, officialCharacters: Int64, userNotesCharacters: Int64): String {
    var text = "# Cangjie Learning Agent Acceptance Report\n\n"
    text += "## Project Identity\n\n"
    text += "- Target user: Cangjie beginners\n"
    text += "- Implementation language: Cangjie\n"
    text += "- Repository: cangjie-learning-agent\n"
    text += "- Knowledge format: local .md and .txt files\n\n"
    text += "## Knowledge Base\n\n"
    text += "- Official files: ${officialCount}\n"
    text += "- User note files: ${userNotesCount}\n"
    text += "- Official characters: ${officialCharacters}\n"
    text += "- User note characters: ${userNotesCharacters}\n\n"
    text += "## Implemented Capabilities\n\n"
    text += "- Source-backed syntax question answering\n"
    text += "- Source-backed prompt preview for future LLM API calls\n"
    text += "- Source-backed LLM request draft export and local response archive\n"
    text += "- Example draft, mini quiz, practice task, error review, and error fix suggestion\n"
    text += "- Source-backed study card generation and Markdown export\n"
    text += "- Source-backed answer, session, and source-map Markdown exports\n"
    text += "- Static web dashboard generated by Cangjie\n"
    text += "- Personalized knowledge add/import commands\n"
    text += "- Matched source listing, source content inspection, and scored primary source selection\n"
    text += "- Source-backed operation trace and engineering roadmap\n"
    text += "- Classroom command sheet and delivery artifact index\n"
    text += "- Rubric, teacher summary, and rehearsal checklist\n"
    text += "- Local summary, version, and self-check commands\n\n"
    text += "## Current Limits\n\n"
    text += "- Real LLM API request is not completed yet\n"
    text += "- Interactive desktop GUI is not completed yet\n"
    text += "- PDF-to-text import inside the Cangjie app is not completed yet\n"
    text += "- Vector search is not completed yet\n"
    return text
}

func exportReport(name: String, officialCount: Int64, userNotesCount: Int64, officialCharacters: Int64, userNotesCharacters: Int64): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildReportText(officialCount, userNotesCount, officialCharacters, userNotesCharacters).toArray())
    return path
}

func buildKnowledgeIndexReport(): String {
    var text = "# Cangjie Learning Agent Knowledge Index\n\n"
    text += "## Official And Course Knowledge\n\n"
    text += buildKnowledgeIndex("official", Path("knowledge_base/official"))
    text += "\n## User Syntax Notes\n\n"
    text += buildKnowledgeIndex("syntax notes", Path("knowledge_base/user_notes/syntax_notes"))
    text += "\n## User Examples\n\n"
    text += buildKnowledgeIndex("examples", Path("knowledge_base/user_notes/examples"))
    text += "\n## User Error Notes\n\n"
    text += buildKnowledgeIndex("errors", Path("knowledge_base/user_notes/errors"))
    return text
}

func exportKnowledgeIndex(name: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildKnowledgeIndexReport().toArray())
    return path
}

func exportStudyCard(name: String, topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildStudyCardText(topic, totalMatches, primarySource, sourceText).toArray())
    return path
}

func exportAnswerReport(name: String, question: String, totalMatches: Int64, primarySource: String, sourceText: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildAnswerReportText(question, totalMatches, primarySource, sourceText).toArray())
    return path
}

func exportLearningSession(name: String, topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildLearningSessionText(topic, totalMatches, primarySource, sourceText).toArray())
    return path
}

func buildSourceMapReport(): String {
    let officialPath = Path("knowledge_base/official")
    let syntaxPath = Path("knowledge_base/user_notes/syntax_notes")
    let examplesPath = Path("knowledge_base/user_notes/examples")
    let errorsPath = Path("knowledge_base/user_notes/errors")
    var text = "# Cangjie Learning Agent Source Map\n\n"
    text += "## Distribution\n\n"
    text += "- Official/course: files=${countKnowledgeFiles(officialPath)}, characters=${countKnowledgeCharacters(officialPath)}\n"
    text += "- Syntax notes: files=${countKnowledgeFiles(syntaxPath)}, characters=${countKnowledgeCharacters(syntaxPath)}\n"
    text += "- Examples: files=${countKnowledgeFiles(examplesPath)}, characters=${countKnowledgeCharacters(examplesPath)}\n"
    text += "- Error notes: files=${countKnowledgeFiles(errorsPath)}, characters=${countKnowledgeCharacters(errorsPath)}\n\n"
    text += "## Source Lists\n\n"
    text += "### Official/course\n\n"
    text += buildKnowledgeIndex("official", officialPath)
    text += "\n### Syntax notes\n\n"
    text += buildKnowledgeIndex("syntax notes", syntaxPath)
    text += "\n### Examples\n\n"
    text += buildKnowledgeIndex("examples", examplesPath)
    text += "\n### Error notes\n\n"
    text += buildKnowledgeIndex("error notes", errorsPath)
    return text
}

func exportSourceMap(name: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildSourceMapReport().toArray())
    return path
}

func exportLlmRequest(name: String, question: String, totalMatches: Int64, primarySource: String, sourceText: String): Path {
    let path = Path("docs").join(name + ".md")
    File.writeTo(path, buildLlmRequestDraft(question, totalMatches, primarySource, sourceText).toArray())
    return path
}

func saveLlmResponse(name: String, sourcePath: String): Path {
    let path = Path("llm_responses").join(name + ".md")
    File.writeTo(path, readKnowledgeText(Path(sourcePath)).toArray())
    return path
}

func showSavedLlmResponse(name: String): Bool {
    let path = Path("llm_responses").join(name + ".md")
    if (!exists(path)) {
        println("Saved LLM response not found: ${path.toString()}")
        return false
    }
    println("Saved LLM response: ${path.toString()}")
    println(readKnowledgeText(path))
    return true
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
        println("2. target\\manual\\main.exe version")
        println("3. target\\manual\\main.exe summary")
        println("4. target\\manual\\main.exe self-check")
        println("5. target\\manual\\main.exe stats")
        println("6. target\\manual\\main.exe category-stats")
        println("7. target\\manual\\main.exe sources ArrayList")
        println("8. target\\manual\\main.exe why-source ArrayList")
        println("9. target\\manual\\main.exe show-source ArrayList")
        println("10. target\\manual\\main.exe ask match")
        println("11. target\\manual\\main.exe session ArrayList")
        println("12. target\\manual\\main.exe prompt match")
        println("13. target\\manual\\main.exe llm-request match")
        println("14. target\\manual\\main.exe export-llm-request match_llm_request match")
        println("15. target\\manual\\main.exe import-llm-response sample_response docs\\match_answer.md")
        println("16. target\\manual\\main.exe show-llm-response sample_response")
        println("17. target\\manual\\main.exe study-plan ArrayList")
        println("18. target\\manual\\main.exe card ArrayList")
        println("19. target\\manual\\main.exe export-card arraylist_card ArrayList")
        println("20. target\\manual\\main.exe export-answer match_answer match")
        println("21. target\\manual\\main.exe export-session arraylist_session ArrayList")
        println("22. target\\manual\\main.exe source-map")
        println("23. target\\manual\\main.exe export-source-map source_map")
        println("24. target\\manual\\main.exe dashboard")
        println("25. target\\manual\\main.exe export-dashboard dashboard")
        println("26. target\\manual\\main.exe final-check")
        println("27. target\\manual\\main.exe export-final-check final_check")
        println("28. target\\manual\\main.exe trace match")
        println("29. target\\manual\\main.exe export-trace match_trace match")
        println("30. target\\manual\\main.exe roadmap")
        println("31. target\\manual\\main.exe export-roadmap roadmap")
        println("32. target\\manual\\main.exe command-sheet")
        println("33. target\\manual\\main.exe export-command-sheet command_sheet")
        println("34. target\\manual\\main.exe delivery-index")
        println("35. target\\manual\\main.exe export-delivery-index delivery_index")
        println("36. target\\manual\\main.exe rubric")
        println("37. target\\manual\\main.exe export-rubric rubric")
        println("38. target\\manual\\main.exe teacher-summary")
        println("39. target\\manual\\main.exe export-teacher-summary teacher_summary")
        println("40. target\\manual\\main.exe rehearsal")
        println("41. target\\manual\\main.exe export-rehearsal rehearsal")
        println("42. target\\manual\\main.exe example ArrayList")
        println("43. target\\manual\\main.exe practice ArrayList")
        println("44. target\\manual\\main.exe quiz ArrayList")
        println("45. target\\manual\\main.exe review-error Cangjie-error-note")
        println("46. target\\manual\\main.exe fix-error Cangjie-error-note")
        println("47. target\\manual\\main.exe export-report acceptance_report")
        println("48. target\\manual\\main.exe add-note my_note Cangjie-my-note")
        println("49. target\\manual\\main.exe ask Cangjie-my-note")
        println("50. target\\manual\\main.exe add-official course_if_note Cangjie-if-expression-note")
        println("51. target\\manual\\main.exe categories")
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

    if (args.size > 1 && args[1] == "category-stats") {
        printCategoryStats()
        return 0
    }

    if (args.size > 1 && args[1] == "source-map") {
        printSourceMap()
        return 0
    }

    if (args.size > 1 && args[1] == "dashboard") {
        let officialCount = countKnowledgeFiles(officialPath)
        let userNotesCount = countKnowledgeFiles(userNotesPath)
        let officialCharacters = countKnowledgeCharacters(officialPath)
        let userNotesCharacters = countKnowledgeCharacters(userNotesPath)
        printDashboardSummary(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        return 0
    }

    if (args.size > 1 && args[1] == "final-check") {
        let officialCount = countKnowledgeFiles(officialPath)
        let userNotesCount = countKnowledgeFiles(userNotesPath)
        let officialCharacters = countKnowledgeCharacters(officialPath)
        let userNotesCharacters = countKnowledgeCharacters(userNotesPath)
        printFinalCheck(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        return 0
    }

    if (args.size > 1 && args[1] == "roadmap") {
        printRoadmap()
        return 0
    }

    if (args.size > 1 && args[1] == "command-sheet") {
        printCommandSheet()
        return 0
    }

    if (args.size > 1 && args[1] == "delivery-index") {
        let officialCount = countKnowledgeFiles(officialPath)
        let userNotesCount = countKnowledgeFiles(userNotesPath)
        let officialCharacters = countKnowledgeCharacters(officialPath)
        let userNotesCharacters = countKnowledgeCharacters(userNotesPath)
        printDeliveryIndex(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        return 0
    }

    if (args.size > 1 && args[1] == "rubric") {
        printRubric()
        return 0
    }

    if (args.size > 1 && args[1] == "teacher-summary") {
        let officialCount = countKnowledgeFiles(officialPath)
        let userNotesCount = countKnowledgeFiles(userNotesPath)
        printTeacherSummary(officialCount, userNotesCount)
        return 0
    }

    if (args.size > 1 && args[1] == "rehearsal") {
        printRehearsal()
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

    if (args.size > 1 && args[1] == "session" && args.size <= 2) {
        printUsageError("session", "target\\manual\\main.exe session <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "practice" && args.size <= 2) {
        printUsageError("practice", "target\\manual\\main.exe practice <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "study-plan" && args.size <= 2) {
        printUsageError("study-plan", "target\\manual\\main.exe study-plan <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "card" && args.size <= 2) {
        printUsageError("card", "target\\manual\\main.exe card <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-card" && args.size <= 3) {
        printUsageError("export-card", "target\\manual\\main.exe export-card <name> <topic>")
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

    if (args.size > 1 && args[1] == "why-source" && args.size <= 2) {
        printUsageError("why-source", "target\\manual\\main.exe why-source <keyword>")
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

    if (args.size > 1 && args[1] == "llm-request" && args.size <= 2) {
        printUsageError("llm-request", "target\\manual\\main.exe llm-request <question>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-llm-request" && args.size <= 3) {
        printUsageError("export-llm-request", "target\\manual\\main.exe export-llm-request <name> <question>")
        return 1
    }

    if (args.size > 1 && args[1] == "import-llm-response" && args.size <= 3) {
        printUsageError("import-llm-response", "target\\manual\\main.exe import-llm-response <name> <file-path>")
        return 1
    }

    if (args.size > 1 && args[1] == "show-llm-response" && args.size <= 2) {
        printUsageError("show-llm-response", "target\\manual\\main.exe show-llm-response <name>")
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

    if (args.size > 1 && args[1] == "export-report" && args.size <= 2) {
        printUsageError("export-report", "target\\manual\\main.exe export-report <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-index" && args.size <= 2) {
        printUsageError("export-index", "target\\manual\\main.exe export-index <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-answer" && args.size <= 3) {
        printUsageError("export-answer", "target\\manual\\main.exe export-answer <name> <question>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-session" && args.size <= 3) {
        printUsageError("export-session", "target\\manual\\main.exe export-session <name> <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-source-map" && args.size <= 2) {
        printUsageError("export-source-map", "target\\manual\\main.exe export-source-map <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-dashboard" && args.size <= 2) {
        printUsageError("export-dashboard", "target\\manual\\main.exe export-dashboard <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-final-check" && args.size <= 2) {
        printUsageError("export-final-check", "target\\manual\\main.exe export-final-check <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "trace" && args.size <= 2) {
        printUsageError("trace", "target\\manual\\main.exe trace <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-trace" && args.size <= 3) {
        printUsageError("export-trace", "target\\manual\\main.exe export-trace <name> <topic>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-roadmap" && args.size <= 2) {
        printUsageError("export-roadmap", "target\\manual\\main.exe export-roadmap <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-command-sheet" && args.size <= 2) {
        printUsageError("export-command-sheet", "target\\manual\\main.exe export-command-sheet <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-delivery-index" && args.size <= 2) {
        printUsageError("export-delivery-index", "target\\manual\\main.exe export-delivery-index <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-rubric" && args.size <= 2) {
        printUsageError("export-rubric", "target\\manual\\main.exe export-rubric <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-teacher-summary" && args.size <= 2) {
        printUsageError("export-teacher-summary", "target\\manual\\main.exe export-teacher-summary <name>")
        return 1
    }

    if (args.size > 1 && args[1] == "export-rehearsal" && args.size <= 2) {
        printUsageError("export-rehearsal", "target\\manual\\main.exe export-rehearsal <name>")
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

    if (args.size > 3 && args[1] == "import-llm-response") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourcePath = joinArgs(args, 3)
        if (!canImportKnowledgeFile(sourcePath)) {
            printImportFileError(sourcePath)
            return 1
        }
        let responsePath = saveLlmResponse(args[2], sourcePath)
        println("Imported LLM response: ${responsePath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "show-llm-response") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        if (showSavedLlmResponse(args[2])) {
            return 0
        }
        return 1
    }

    let officialCount = countKnowledgeFiles(officialPath)
    let userNotesCount = countKnowledgeFiles(userNotesPath)
    let officialCharacters = countKnowledgeCharacters(officialPath)
    let userNotesCharacters = countKnowledgeCharacters(userNotesPath)

    if (args.size > 2 && args[1] == "export-report") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let reportPath = exportReport(args[2], officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        println("Exported report: ${reportPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-index") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let indexPath = exportKnowledgeIndex(args[2])
        println("Exported knowledge index: ${indexPath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "export-card") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let topic = joinArgs(args, 3)
        println("Study card topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 3)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 3)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 3)
        let sourceText = readSourceTextOrEmpty(primarySource)
        let cardPath = exportStudyCard(args[2], topic, totalMatches, primarySource, sourceText)
        println("Exported study card: ${cardPath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "export-answer") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let question = joinArgs(args, 3)
        println("Question: ${question}")
        println("Search query: ${question}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, question, args, 3)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, question, args, 3)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, question, args, 3)
        let sourceText = readSourceTextOrEmpty(primarySource)
        let answerPath = exportAnswerReport(args[2], question, totalMatches, primarySource, sourceText)
        println("Exported answer report: ${answerPath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "export-session") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let topic = joinArgs(args, 3)
        println("Session topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 3)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 3)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 3)
        let sourceText = readSourceTextOrEmpty(primarySource)
        let sessionPath = exportLearningSession(args[2], topic, totalMatches, primarySource, sourceText)
        println("Exported learning session: ${sessionPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-source-map") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let sourceMapPath = exportSourceMap(args[2])
        println("Exported source map: ${sourceMapPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-dashboard") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let dashboardPath = exportDashboard(args[2], officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        println("Exported dashboard: ${dashboardPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-final-check") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let finalCheckPath = exportFinalCheck(args[2], officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        println("Exported final check: ${finalCheckPath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "export-trace") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let topic = joinArgs(args, 3)
        println("Trace topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 3)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 3)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let officialScore = findBestKnowledgeScore(officialPath, topic, args, 3)
        let userNotesScore = findBestKnowledgeScore(userNotesPath, topic, args, 3)
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 3)
        let sourceText = readSourceTextOrEmpty(primarySource)
        let tracePath = exportTraceReport(args[2], topic, totalMatches, officialScore, userNotesScore, primarySource, sourceText)
        println("Exported trace report: ${tracePath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-roadmap") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let roadmapPath = exportRoadmap(args[2])
        println("Exported roadmap: ${roadmapPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-command-sheet") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let commandSheetPath = exportCommandSheet(args[2])
        println("Exported command sheet: ${commandSheetPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-delivery-index") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let deliveryIndexPath = exportDeliveryIndex(args[2], officialCount, userNotesCount, officialCharacters, userNotesCharacters)
        println("Exported delivery index: ${deliveryIndexPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-rubric") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let rubricPath = exportRubric(args[2])
        println("Exported rubric: ${rubricPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-teacher-summary") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let teacherSummaryPath = exportTeacherSummary(args[2], officialCount, userNotesCount)
        println("Exported teacher summary: ${teacherSummaryPath.toString()}")
        return 0
    }

    if (args.size > 2 && args[1] == "export-rehearsal") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let rehearsalPath = exportRehearsal(args[2])
        println("Exported rehearsal checklist: ${rehearsalPath.toString()}")
        return 0
    }

    if (args.size > 3 && args[1] == "export-llm-request") {
        if (!isSafeKnowledgeName(args[2])) {
            printNameError(args[2])
            return 1
        }
        let question = joinArgs(args, 3)
        println("Question: ${question}")
        println("Search query: ${question}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, question, args, 3)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, question, args, 3)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, question, args, 3)
        let sourceText = readSourceTextOrEmpty(primarySource)
        let requestPath = exportLlmRequest(args[2], question, totalMatches, primarySource, sourceText)
        println("Exported LLM request draft: ${requestPath.toString()}")
        return 0
    }

    println("Cangjie Learning Agent")
    println("Status: project skeleton is ready.")
    println("Knowledge base:")
    println("- official: knowledge_base/official")
    println("- user notes: knowledge_base/user_notes")
    printKnowledgeStats(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
    if (args.size > 1 && args[1] == "stats") {
        return 0
    } else if (args.size > 1 && args[1] == "self-check") {
        printSelfCheck(officialCount, userNotesCount)
    } else if (args.size > 1 && args[1] == "summary") {
        printProjectSummary(officialCount, userNotesCount, officialCharacters, userNotesCharacters)
    } else if (args.size > 2 && args[1] == "sources") {
        let query = joinArgs(args, 2)
        println("Source query: ${query}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, query, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, query, args, 2)
        println("Total matches: ${officialMatches + userNotesMatches}")
    } else if (args.size > 2 && args[1] == "why-source") {
        let query = joinArgs(args, 2)
        println("Source query: ${query}")
        let officialScore = findBestKnowledgeScore(officialPath, query, args, 2)
        let userNotesScore = findBestKnowledgeScore(userNotesPath, query, args, 2)
        println("Best official score: ${officialScore}")
        println("Best user notes score: ${userNotesScore}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, query, args, 2)
        printPrimarySource(primarySource)
        if (primarySource.isEmpty()) {
            println("Reason: no local source matched the query.")
        } else if (officialScore >= userNotesScore) {
            println("Reason: official/course knowledge had the highest score or tied with user notes.")
        } else {
            println("Reason: user notes had the highest score.")
        }
    } else if (args.size > 2 && args[1] == "show-source") {
        let query = joinArgs(args, 2)
        println("Source query: ${query}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, query, args, 2)
        printPrimarySource(primarySource)
        printFirstKnowledgeSourceText(primarySource)
    } else if (args.size > 2 && args[1] == "trace") {
        let topic = joinArgs(args, 2)
        println("Trace topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let officialScore = findBestKnowledgeScore(officialPath, topic, args, 2)
        let userNotesScore = findBestKnowledgeScore(userNotesPath, topic, args, 2)
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printTraceReport(topic, totalMatches, officialScore, userNotesScore, primarySource, sourceText)
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
    } else if (args.size > 2 && args[1] == "llm-request") {
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
        printLlmRequestDraft(query, totalMatches, primarySource, sourceText)
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
    } else if (args.size > 2 && args[1] == "session") {
        let topic = joinArgs(args, 2)
        println("Session topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printLearningSession(topic, totalMatches, primarySource, sourceText)
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
    } else if (args.size > 2 && args[1] == "study-plan") {
        let topic = joinArgs(args, 2)
        println("Study topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printStudyPlan(topic, totalMatches, primarySource, sourceText)
    } else if (args.size > 2 && args[1] == "card") {
        let topic = joinArgs(args, 2)
        println("Study card topic: ${topic}")
        println("Search query: ${topic}")
        println("Matched sources:")
        let officialMatches = searchKnowledgeFilesByTerms("official", officialPath, topic, args, 2)
        let userNotesMatches = searchKnowledgeFilesByTerms("user notes", userNotesPath, topic, args, 2)
        let totalMatches = officialMatches + userNotesMatches
        println("Total matches: ${totalMatches}")
        let primarySource = findBestLocalSource(officialPath, userNotesPath, topic, args, 2)
        let sourceText = readSourceTextOrEmpty(primarySource)
        printStudyCard(topic, totalMatches, primarySource, sourceText)
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
        println("Tip: use session <topic> to run a source-backed learning session.")
        println("Tip: use practice <topic> to generate a practice task.")
        println("Tip: use study-plan <topic> to generate a source-backed beginner study plan.")
        println("Tip: use card <topic> to generate a source-backed study card.")
        println("Tip: use export-card <name> <topic> to export a Markdown study card under docs.")
        println("Tip: use quiz <topic> to generate a source-backed mini quiz.")
        println("Tip: use example <topic> to generate a source-backed Cangjie example draft.")
        println("Tip: use stats to show local knowledge base statistics.")
        println("Tip: use category-stats to show knowledge file counts by category.")
        println("Tip: use sources <keyword> to list matched source files only.")
        println("Tip: use why-source <keyword> to explain primary source score selection.")
        println("Tip: use show-source <keyword> to print the first matched source content.")
        println("Tip: use prompt <question> to preview a source-backed LLM prompt.")
        println("Tip: use llm-request <question> to build a source-backed LLM request draft.")
        println("Tip: use export-llm-request <name> <question> to export a Markdown LLM request draft.")
        println("Tip: use import-llm-response <name> <file-path> to save a .md or .txt LLM response locally.")
        println("Tip: use show-llm-response <name> to print a saved LLM response.")
        println("Tip: use review-error <keyword> to review compiler error notes.")
        println("Tip: use fix-error <keyword> to generate a source-backed error fix suggestion.")
        println("Tip: use demo to show a recommended classroom demo flow.")
        println("Tip: use summary to show implemented capabilities and current limits.")
        println("Tip: use version to show project version and engineering identity.")
        println("Tip: use self-check to run a local acceptance self-check.")
        println("Tip: use export-report <name> to export a Markdown acceptance report under docs.")
        println("Tip: use export-index <name> to export a Markdown knowledge source index under docs.")
        println("Tip: use export-answer <name> <question> to export a Markdown answer report.")
        println("Tip: use export-session <name> <topic> to export a Markdown learning session.")
        println("Tip: use source-map to show local knowledge source distribution.")
        println("Tip: use export-source-map <name> to export a Markdown source map.")
        println("Tip: use dashboard to show static web dashboard data.")
        println("Tip: use export-dashboard <name> to export a static HTML dashboard.")
        println("Tip: use final-check to show final acceptance readiness.")
        println("Tip: use export-final-check <name> to export a final readiness report.")
        println("Tip: use trace <topic> to show the source-backed operation trace.")
        println("Tip: use export-trace <name> <topic> to export a Markdown trace report.")
        println("Tip: use roadmap to show remaining engineering work.")
        println("Tip: use export-roadmap <name> to export a Markdown roadmap.")
        println("Tip: use command-sheet to show classroom commands.")
        println("Tip: use export-command-sheet <name> to export classroom commands.")
        println("Tip: use delivery-index to show delivery artifacts.")
        println("Tip: use export-delivery-index <name> to export delivery artifacts.")
        println("Tip: use rubric to show grading alignment.")
        println("Tip: use export-rubric <name> to export grading alignment.")
        println("Tip: use teacher-summary to show a teacher-facing summary.")
        println("Tip: use export-teacher-summary <name> to export a teacher summary.")
        println("Tip: use rehearsal to show a classroom rehearsal checklist.")
        println("Tip: use export-rehearsal <name> to export a rehearsal checklist.")
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
