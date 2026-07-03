# Cangjie Answer Report: match

## Question

match

## Local Source Result

- Match count: 2
- Primary source: F:\学校の\小学期\make_agent\knowledge_base/official\course_match_note.md

## Answer Draft

The local knowledge base has related Cangjie material. Read the primary source, identify the syntax rule, and answer with the cited source path.

Suggested answer structure:

1. State the syntax point in beginner-friendly words.
2. Give one tiny Cangjie example when useful.
3. Mention the primary source path as evidence.
4. Save any personal understanding with `add-note` or `add-example`.

## Source Context

````text
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

````

