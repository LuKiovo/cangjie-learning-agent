# LLM Request Draft

## Configuration

- Endpoint env: CANGJIE_AGENT_LLM_ENDPOINT
- Model env: CANGJIE_AGENT_LLM_MODEL
- API key env: CANGJIE_AGENT_API_KEY
- API key policy: read from environment variables only; never store in repository files

## Request Intent

- Task: answer a Cangjie beginner syntax question
- Question: match
- Local match count: 2
- Primary source: F:\学校の\小学期\make_agent\knowledge_base/official\course_match_note.md

## Prompt Payload

````text
System:
You are a Cangjie language learning assistant for beginners.
Use the local knowledge base first. If sources are missing, say that the local knowledge base has no matching source.
Always mention the source path when a local source is available.

User question:
match

Local source count:
2

Primary source:
F:\学校の\小学期\make_agent\knowledge_base/official\course_match_note.md

Local source context:
# Cangjie Match And Control Flow

Topic keywords: Cangjie match expression, if expression, while loop, for in loop, enum.

Beginner note:

- `if` is useful for two-way or multi-way conditions.
- `match` is useful when a value should be compared against several cases.
- Loops such as `while` and `for in` help repeat work.
- A terminal menu can use `match` to dispatch user commands.

Tiny example:

```cangjie
main(): Int64 {
    let command = "help"
    match (command) {
        case "help" => println("show help")
        case "quit" => println("quit")
        case _ => println("unknown command")
    }
    return 0
}
```


Answer rules:
- Explain the syntax point in beginner-friendly language.
- Give one small Cangjie example when useful.
- Mark assumptions clearly when local sources are not enough.
- Suggest a note, example, or error entry that the user can add to the local knowledge base.

````

## Future HTTP Mapping

When a Cangjie HTTP client is connected, send the prompt payload as the user message/content field, together with the configured model and authorization header.
