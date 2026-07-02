package cangjie_learning_agent

func printAgentAnswer(totalMatches: Int64): Unit {
    println("Agent answer:")
    if (totalMatches > 0) {
        println("I found local knowledge sources related to your Cangjie syntax question. Please review the matched sources above.")
        println("Learning suggestion: open the matched source, read the related syntax note, then add your own example with add-example.")
    } else {
        println("I did not find a local source for this Cangjie syntax question. Add official docs or user notes, then ask again.")
        println("Learning suggestion: add a note with add-note, add-example, or add-error after checking official Cangjie documents.")
    }
}
