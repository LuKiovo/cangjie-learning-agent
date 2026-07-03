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

2. Show project version:

```powershell
target\manual\main.exe version
```

Expected result: version, repository name, implementation language, and knowledge format.

3. Show project summary:

```powershell
target\manual\main.exe summary
```

Expected result: implemented capabilities, knowledge statistics, and current limits.

4. Run local self-check:

```powershell
target\manual\main.exe self-check
```

Expected result: pass/fail style local acceptance checks.

5. Show knowledge base statistics:

```powershell
target\manual\main.exe stats
```

6. Show knowledge category statistics:

```powershell
target\manual\main.exe category-stats
```

Expected result: official, syntax note, example, and error note file counts.

7. Show matched source files:

```powershell
target\manual\main.exe sources ArrayList
```

8. Explain primary source selection:

```powershell
target\manual\main.exe why-source ArrayList
```

Expected result: best official/user note scores and the selected primary source.

9. Show the first matched source content:

```powershell
target\manual\main.exe show-source ArrayList
```

Expected result: primary source path and source text.

10. Ask a Cangjie syntax question:

```powershell
target\manual\main.exe ask match
```

Expected result: matched sources and an answer section with `Primary source` and `Primary source context`.

Multi-word questions are also supported:

```powershell
target\manual\main.exe ask ArrayList match expression
```

Expected result: if the full question does not match directly, the CLI falls back to matching individual words and still lists useful local sources.

11. Run a source-backed learning session:

```powershell
target\manual\main.exe session ArrayList
```

Expected result: matched sources, primary source context, session flow, mini task, and review question.

12. Preview a source-backed LLM prompt:

```powershell
target\manual\main.exe prompt match
```

Expected result: matched sources, source count, primary source, local source context, and prompt answer rules.

13. Generate a source-backed beginner study plan:

```powershell
target\manual\main.exe study-plan ArrayList
```

Expected result: matched sources, primary source context, and ordered beginner learning steps.

14. Generate a source-backed study card:

```powershell
target\manual\main.exe card ArrayList
```

Expected result: matched sources, primary source, source context, memory points, and practice guidance.

15. Export a source-backed Markdown study card:

```powershell
target\manual\main.exe export-card arraylist_card ArrayList
```

Expected result: `docs/arraylist_card.md` is created with source-backed context and beginner review tasks.

16. Generate a source-backed Cangjie example draft:

```powershell
target\manual\main.exe example ArrayList
```

Expected result: matched sources, `Primary source`, source context, and a Cangjie code draft.

17. Generate a source-backed practice task:

```powershell
target\manual\main.exe practice ArrayList
```

Expected result: matched sources, `Primary source`, and a checklist.

18. Generate a source-backed mini quiz:

```powershell
target\manual\main.exe quiz ArrayList
```

Expected result: matched sources, primary source context, quiz questions, and suggested answers.

19. Review a compiler error note:

```powershell
target\manual\main.exe review-error Cangjie-error-note
```

Expected result: matched error sources, `Primary source`, and a debugging checklist.

20. Generate a source-backed error fix suggestion:

```powershell
target\manual\main.exe fix-error Cangjie-error-note
```

Expected result: matched error sources, primary source context, fix steps, and a Cangjie fix draft.

21. Export a Markdown acceptance report:

```powershell
target\manual\main.exe export-report acceptance_report
```

Expected result: `docs/acceptance_report.md` is created with project identity, knowledge statistics, capabilities, and limits.

22. Add a personal syntax note:

```powershell
target\manual\main.exe add-note my_note Cangjie-my-note
```

Multi-word note content is supported:

```powershell
target\manual\main.exe add-note my_note Cangjie personal syntax note
```

23. Search the added note:

```powershell
target\manual\main.exe ask Cangjie-my-note
```

24. Add a course-summary knowledge item:

```powershell
target\manual\main.exe add-official course_if_note Cangjie-if-expression-note
```

25. Show knowledge categories:

```powershell
target\manual\main.exe categories
```
