package cangjie_learning_agent

func printPrimarySource(source: String): Unit {
    if (!source.isEmpty()) {
        println("Primary source: ${source}")
    }
}

func printSourceContext(sourceText: String): Unit {
    if (!sourceText.isEmpty()) {
        println("Primary source context:")
        println(sourceText)
    }
}

func printAgentAnswer(totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Agent answer:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("I found local knowledge sources related to your Cangjie syntax question. Please review the matched sources above.")
        println("Learning suggestion: open the matched source, read the related syntax note, then add your own example with add-example.")
    } else {
        println("I did not find a local source for this Cangjie syntax question. Add official docs or user notes, then ask again.")
        println("Learning suggestion: add a note with add-note, add-example, or add-error after checking official Cangjie documents.")
    }
}

func buildAnswerReportText(question: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    var text = "本地库回答\n\n"
    text += "问题：${question}\n\n"
    if (totalMatches > 0) {
        text += "The local knowledge base has related Cangjie material. Read the primary source, identify the syntax rule, and answer with the cited source path.\n\n"
        text += "Suggested answer structure:\n\n"
        text += "1. State the syntax point in beginner-friendly words.\n"
        text += "2. Give one tiny Cangjie example when useful.\n"
        text += "3. Mention the primary source path as evidence.\n"
        text += "4. Save any personal understanding with `add-note` or `add-example`.\n\n"
    } else {
        text += "No matching local source was found. Add or import official/course knowledge before giving a confident answer.\n\n"
    }
    text += "资料来源\n\n"
    text += "- Match count: ${totalMatches}\n"
    if (!primarySource.isEmpty()) {
        text += "- Primary source: ${primarySource}\n\n"
    } else {
        text += "- Primary source: none\n\n"
    }
    text += "来源内容\n\n"
    if (!sourceText.isEmpty()) {
        text += "````text\n"
        text += sourceText
        text += "\n````\n\n"
    } else {
        text += "No local source context is available.\n\n"
    }
    return text
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

func printQuiz(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Quiz:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("Question 1: Which local source should you read first for '${topic}'?")
        println("A. The primary source shown above")
        println("B. An unrelated note")
        println("Answer: A")
        println("Question 2: Write one sentence explaining how '${topic}' appears in the source context.")
        println("Suggested answer: Use the primary source context above, then add your own summary as a note.")
    } else {
        println("No local source matched '${topic}'.")
        println("Quiz suggestion: add a note or official summary first, then generate this quiz again.")
    }
}

func printStudyPlan(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Study plan:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("Step 1: Read the primary source context and identify the key syntax words for '${topic}'.")
        println("Step 2: Run show-source ${topic} to inspect the local material again.")
        println("Step 3: Run example ${topic} and rewrite the draft in your own style.")
        println("Step 4: Run quiz ${topic} to check whether you can explain the source.")
        println("Step 5: Save your own summary with add-note <name> <content>.")
    } else {
        println("No local source matched '${topic}'.")
        println("Step 1: add or import an official/course note for this topic.")
        println("Step 2: run sources ${topic} to confirm it can be retrieved.")
        println("Step 3: ask again after the local knowledge base has a matching source.")
    }
}

func printLearningSession(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Learning session:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("Session flow:")
        println("1. Read the primary source context.")
        println("2. Explain '${topic}' in one sentence.")
        println("3. Run example ${topic} and adapt the draft.")
        println("4. Run quiz ${topic} and check your answer.")
        println("5. Save your personal summary with add-note.")
        println("Mini task: create one tiny Cangjie program that prints a message about '${topic}'.")
        println("Review question: which source line or section helped you most?")
    } else {
        println("No local source matched '${topic}'.")
        println("Session flow: import or add a local source, run sources ${topic}, then start the session again.")
    }
}

func buildLearningSessionText(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    var text = "# Cangjie Learning Session: ${topic}\n\n"
    text += "## Topic\n\n"
    text += "${topic}\n\n"
    text += "## Source\n\n"
    text += "- Match count: ${totalMatches}\n"
    if (!primarySource.isEmpty()) {
        text += "- Primary source: ${primarySource}\n\n"
    } else {
        text += "- Primary source: none\n\n"
    }
    text += "## Session Flow\n\n"
    if (totalMatches > 0) {
        text += "1. Read the primary source context.\n"
        text += "2. Explain `${topic}` in one beginner-friendly sentence.\n"
        text += "3. Draft one small Cangjie example.\n"
        text += "4. Run `quiz ${topic}` to check understanding.\n"
        text += "5. Save a personal summary with `add-note`.\n\n"
        text += "Mini task: create one tiny Cangjie program that demonstrates `${topic}`.\n\n"
        text += "Review question: which source line or section supports your explanation?\n\n"
    } else {
        text += "No local source matched `${topic}`. Import a `.md` or `.txt` note first, then regenerate this session.\n\n"
    }
    text += "## Source Context\n\n"
    if (!sourceText.isEmpty()) {
        text += "````text\n"
        text += sourceText
        text += "\n````\n\n"
    } else {
        text += "No local source context is available.\n\n"
    }
    return text
}

func buildStudyCardText(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): String {
    var text = "# Cangjie Study Card: ${topic}\n\n"
    text += "## Source\n\n"
    if (totalMatches > 0 && !primarySource.isEmpty()) {
        text += "- Match count: ${totalMatches}\n"
        text += "- Primary source: ${primarySource}\n\n"
    } else {
        text += "- Match count: 0\n"
        text += "- Primary source: none\n\n"
    }

    text += "## Beginner Explanation\n\n"
    if (totalMatches > 0) {
        text += "Read the primary source first, then explain `${topic}` with one concrete Cangjie syntax rule.\n\n"
    } else {
        text += "No local source matched `${topic}`. Add or import a `.md` or `.txt` note before trusting this card.\n\n"
    }

    text += "## Source Context\n\n"
    if (!sourceText.isEmpty()) {
        text += "````text\n"
        text += sourceText
        text += "\n````\n\n"
    } else {
        text += "No local source context is available.\n\n"
    }

    text += "## Memory Points\n\n"
    text += "1. Name the syntax point in one short sentence.\n"
    text += "2. Write a tiny Cangjie example that uses `${topic}`.\n"
    text += "3. Save your own note with `add-note` or `add-example` after practicing.\n\n"
    text += "## Practice\n\n"
    text += "- Task: write a minimal Cangjie program or expression about `${topic}`.\n"
    text += "- Check: explain which line in the primary source supports your answer.\n"
    text += "- Follow-up: run `quiz ${topic}` or `session ${topic}` for review.\n"
    return text
}

func printStudyCard(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Study card:")
    println(buildStudyCardText(topic, totalMatches, primarySource, sourceText))
}

func printExample(topic: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Example draft:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("Cangjie example:")
        println("main(): Int64 {")
        println("    println(\"Cangjie topic: ${topic}\")")
        println("    return 0")
        println("}")
        println("Next step: run add-example <name> <content> to save your improved version into the local knowledge base.")
    } else {
        println("No local source matched '${topic}'.")
        println("Add a source first, then generate the example again so the draft can cite local knowledge.")
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

func printErrorFix(keyword: String, totalMatches: Int64, primarySource: String, sourceText: String): Unit {
    println("Error fix suggestion:")
    if (totalMatches > 0) {
        printPrimarySource(primarySource)
        printSourceContext(sourceText)
        println("Likely fix path:")
        println("1. Read the compiler message and find the exact syntax token mentioned there.")
        println("2. Compare the line with the primary source context above.")
        println("3. Apply the smallest syntax change, then save the solved case with add-error.")
        println("Cangjie fix draft:")
        println("main(): Int64 {")
        println("    println(\"Fixed topic: ${keyword}\")")
        println("    return 0")
        println("}")
    } else {
        println("No local error note matched '${keyword}'.")
        println("Add the compiler message with add-error after checking the official Cangjie documents.")
    }
}
