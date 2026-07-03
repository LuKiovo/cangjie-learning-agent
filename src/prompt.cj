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

func buildLlmPromptText(question: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    var text = "System:\n"
    text += "You are a Cangjie language learning assistant for beginners.\n"
    text += "Use the local knowledge base first. If sources are missing, say that the local knowledge base has no matching source.\n"
    text += "Always mention the source path when a local source is available.\n\n"
    text += "User question:\n"
    text += question
    text += "\n\nLocal source count:\n"
    text += "${totalMatches}\n\n"
    if (!primarySource.isEmpty()) {
        text += "Primary source:\n"
        text += primarySource
        text += "\n\n"
    } else {
        text += "Primary source:\nnone\n\n"
    }
    text += "Local source context:\n"
    if (!sourceText.isEmpty()) {
        text += sourceText
        text += "\n\n"
    } else {
        text += "none\n\n"
    }
    text += "Answer rules:\n"
    text += "- Explain the syntax point in beginner-friendly language.\n"
    text += "- Give one small Cangjie example when useful.\n"
    text += "- Mark assumptions clearly when local sources are not enough.\n"
    text += "- Suggest a note, example, or error entry that the user can add to the local knowledge base.\n"
    return text
}

func buildLlmRequestDraft(question: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    var text = "# LLM Request Draft\n\n"
    text += "## Configuration\n\n"
    text += "- Endpoint env: CANGJIE_AGENT_LLM_ENDPOINT\n"
    text += "- Model env: CANGJIE_AGENT_LLM_MODEL\n"
    text += "- API key env: CANGJIE_AGENT_API_KEY\n"
    text += "- API key policy: read from environment variables only; never store in repository files\n\n"
    text += "## Request Intent\n\n"
    text += "- Task: answer a Cangjie beginner syntax question\n"
    text += "- Question: ${question}\n"
    text += "- Local match count: ${totalMatches}\n"
    if (!primarySource.isEmpty()) {
        text += "- Primary source: ${primarySource}\n\n"
    } else {
        text += "- Primary source: none\n\n"
    }
    text += "## Prompt Payload\n\n"
    text += "````text\n"
    text += buildLlmPromptText(question, totalMatches, primarySource, sourceText)
    text += "\n````\n\n"
    text += "## Future HTTP Mapping\n\n"
    text += "When a Cangjie HTTP client is connected, send the prompt payload as the user message/content field, together with the configured model and authorization header.\n"
    return text
}

func printLlmRequestDraft(question: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println(buildLlmRequestDraft(question, totalMatches, primarySource, sourceText))
}
