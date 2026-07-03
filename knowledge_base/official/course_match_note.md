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
