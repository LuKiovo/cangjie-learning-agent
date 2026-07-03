package cangjie_learning_agent

func printPrimarySource(source: String): Unit {
    if (!source.isEmpty()) {
        println("Primary source: ${source}")
    }
}

func printAgentAnswer(totalMatches: Int64, primarySource: String): Unit {
    println("Agent answer:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        println("I found local knowledge sources related to your Cangjie syntax question. Please review the matched sources above.")
        println("Learning suggestion: open the matched source, read the related syntax note, then add your own example with add-example.")
    } else {
        println("I did not find a local source for this Cangjie syntax question. Add official docs or user notes, then ask again.")
        println("Learning suggestion: add a note with add-note, add-example, or add-error after checking official Cangjie documents.")
    }
}

func printPractice(topic: String, totalMatches: Int64, primarySource: String): Unit {
    println("Practice:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        println("Task: write a small Cangjie example about '${topic}', then save it with add-example.")
        println("Checklist: include one syntax point, one println output, and one short note explaining the result.")
        println("Reference: use the matched sources above before writing your answer.")
    } else {
        println("Task: no local source matched '${topic}'. Add a syntax note first, then generate this practice again.")
        println("Checklist: add a source with add-note, search it, then write a small example with add-example.")
    }
}

func printErrorReview(keyword: String, totalMatches: Int64, primarySource: String): Unit {
    println("Error review:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        println("I found local error-related sources for '${keyword}'.")
        println("Debug checklist: read the matched source, identify the compiler message, compare it with your code, then save the fix with add-error.")
    } else {
        println("No local error note matched '${keyword}'.")
        println("Debug checklist: copy the compiler message into add-error after you solve it, so the knowledge base improves next time.")
    }
}
