package cangjie_learning_agent

func printPromptPreview(question: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("LLM prompt preview:")
    println("System:")
    println("You are a Cangjie language learning assistant for beginners.")
    println("Use the local knowledge base first. If sources are missing, say that the local knowledge base has no matching source.")
    println("Always mention the source path when a local source is available.")
    println("User question: ${question}")
    println("Local source count: ${totalMatches}")
    if (!primarySource.isEmpty()) {
        println("Primary source: ${primarySource}")
    } else {
        println("Primary source: none")
    }
    if (!sourceText.isEmpty()) {
        println("Local source context:")
        println(sourceText)
    } else {
        println("Local source context: none")
    }
    println("Answer rules:")
    println("- Explain the syntax point in beginner-friendly language.")
    println("- Give one small Cangjie example when useful.")
    println("- Mark assumptions clearly when local sources are not enough.")
    println("- Suggest a note, example, or error entry that the user can add to the local knowledge base.")
}
