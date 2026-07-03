# Classroom Demo Script

This script demonstrates the current CLI learning assistant milestone.

## Build

```powershell
New-Item -ItemType Directory -Force target\manual
cjc -p src --output-dir target\manual
```

## Demo Flow

1. Show available commands:

```powershell
target\manual\main.exe help
```

2. Show project summary:

```powershell
target\manual\main.exe summary
```

Expected result: implemented capabilities, knowledge statistics, and current limits.

3. Show knowledge base statistics:

```powershell
target\manual\main.exe stats
```

4. Show matched source files:

```powershell
target\manual\main.exe sources ArrayList
```

5. Show the first matched source content:

```powershell
target\manual\main.exe show-source ArrayList
```

Expected result: primary source path and source text.

6. Ask a Cangjie syntax question:

```powershell
target\manual\main.exe ask match
```

Expected result: matched sources and an answer section with `Primary source` and `Primary source context`.

Multi-word questions are also supported:

```powershell
target\manual\main.exe ask ArrayList match expression
```

Expected result: if the full question does not match directly, the CLI falls back to matching individual words and still lists useful local sources.

7. Preview a source-backed LLM prompt:

```powershell
target\manual\main.exe prompt match
```

Expected result: matched sources, source count, primary source, local source context, and prompt answer rules.

8. Generate a source-backed Cangjie example draft:

```powershell
target\manual\main.exe example ArrayList
```

Expected result: matched sources, `Primary source`, source context, and a Cangjie code draft.

9. Generate a source-backed practice task:

```powershell
target\manual\main.exe practice ArrayList
```

Expected result: matched sources, `Primary source`, and a checklist.

10. Generate a source-backed mini quiz:

```powershell
target\manual\main.exe quiz ArrayList
```

Expected result: matched sources, primary source context, quiz questions, and suggested answers.

11. Review a compiler error note:

```powershell
target\manual\main.exe review-error Cangjie-error-note
```

Expected result: matched error sources, `Primary source`, and a debugging checklist.

12. Generate a source-backed error fix suggestion:

```powershell
target\manual\main.exe fix-error Cangjie-error-note
```

Expected result: matched error sources, primary source context, fix steps, and a Cangjie fix draft.

13. Add a personal syntax note:

```powershell
target\manual\main.exe add-note my_note Cangjie-my-note
```

Multi-word note content is supported:

```powershell
target\manual\main.exe add-note my_note Cangjie personal syntax note
```

14. Search the added note:

```powershell
target\manual\main.exe ask Cangjie-my-note
```

15. Add a course-summary knowledge item:

```powershell
target\manual\main.exe add-official course_if_note Cangjie-if-expression-note
```

16. Show knowledge categories:

```powershell
target\manual\main.exe categories
```
