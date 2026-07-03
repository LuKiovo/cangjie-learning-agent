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

13. Build a source-backed LLM request draft:

```powershell
target\manual\main.exe llm-request match
```

Expected result: request draft with configuration names, prompt payload, local match count, primary source, and future HTTP mapping notes.

14. Export a Markdown LLM request draft:

```powershell
target\manual\main.exe export-llm-request match_llm_request match
```

Expected result: `docs/match_llm_request.md` is created without storing any API key.

15. Import a local LLM response artifact:

```powershell
target\manual\main.exe import-llm-response sample_response docs\match_answer.md
```

Expected result: `llm_responses/sample_response.md` is created from an existing `.md` or `.txt` file.

16. Show a saved LLM response artifact:

```powershell
target\manual\main.exe show-llm-response sample_response
```

Expected result: the saved response path and content are printed.

17. Generate a source-backed beginner study plan:

```powershell
target\manual\main.exe study-plan ArrayList
```

Expected result: matched sources, primary source context, and ordered beginner learning steps.

18. Generate a source-backed study card:

```powershell
target\manual\main.exe card ArrayList
```

Expected result: matched sources, primary source, source context, memory points, and practice guidance.

19. Export a source-backed Markdown study card:

```powershell
target\manual\main.exe export-card arraylist_card ArrayList
```

Expected result: `docs/arraylist_card.md` is created with source-backed context and beginner review tasks.

20. Export a source-backed answer report:

```powershell
target\manual\main.exe export-answer match_answer match
```

Expected result: `docs/match_answer.md` is created with question, match count, primary source, answer draft, and source context.

21. Export a source-backed learning session:

```powershell
target\manual\main.exe export-session arraylist_session ArrayList
```

Expected result: `docs/arraylist_session.md` is created with source, session flow, mini task, review question, and source context.

22. Show local knowledge source distribution:

```powershell
target\manual\main.exe source-map
```

Expected result: source categories are shown with file counts and character counts.

23. Export a Markdown source map:

```powershell
target\manual\main.exe export-source-map source_map
```

Expected result: `docs/source_map.md` is created with category distribution and source lists.

24. Show dashboard-ready project data:

```powershell
target\manual\main.exe dashboard
```

Expected result: dashboard-ready statistics and static web artifact notes are printed.

25. Export a static HTML dashboard:

```powershell
target\manual\main.exe export-dashboard dashboard
```

Expected result: `docs/dashboard.html` is created by Cangjie and can be opened in a browser.

26. Run final acceptance readiness check:

```powershell
target\manual\main.exe final-check
```

Expected result: implemented acceptance coverage and remaining manual items are shown.

27. Export final readiness report:

```powershell
target\manual\main.exe export-final-check final_check
```

Expected result: `docs/final_check.md` is created with scope, acceptance coverage, knowledge stats, and remaining manual items.

28. Show the source-backed operation trace:

```powershell
target\manual\main.exe trace match
```

Expected result: retrieval steps, scores, primary source, source context, and engineering notes are printed.

29. Export the operation trace:

```powershell
target\manual\main.exe export-trace match_trace match
```

Expected result: `docs/match_trace.md` is created with retrieval, scoring, source selection, and output preparation details.

30. Show the remaining engineering roadmap:

```powershell
target\manual\main.exe roadmap
```

Expected result: completed core items, remaining work, and recommended demo order are printed.

31. Export the roadmap:

```powershell
target\manual\main.exe export-roadmap roadmap
```

Expected result: `docs/roadmap.md` is created with completed core items, remaining work, and recommended demo order.

32. Generate a source-backed Cangjie example draft:

```powershell
target\manual\main.exe example ArrayList
```

Expected result: matched sources, `Primary source`, source context, and a Cangjie code draft.

33. Generate a source-backed practice task:

```powershell
target\manual\main.exe practice ArrayList
```

Expected result: matched sources, `Primary source`, and a checklist.

34. Generate a source-backed mini quiz:

```powershell
target\manual\main.exe quiz ArrayList
```

Expected result: matched sources, primary source context, quiz questions, and suggested answers.

35. Review a compiler error note:

```powershell
target\manual\main.exe review-error Cangjie-error-note
```

Expected result: matched error sources, `Primary source`, and a debugging checklist.

36. Generate a source-backed error fix suggestion:

```powershell
target\manual\main.exe fix-error Cangjie-error-note
```

Expected result: matched error sources, primary source context, fix steps, and a Cangjie fix draft.

37. Export a Markdown acceptance report:

```powershell
target\manual\main.exe export-report acceptance_report
```

Expected result: `docs/acceptance_report.md` is created with project identity, knowledge statistics, capabilities, and limits.

38. Add a personal syntax note:

```powershell
target\manual\main.exe add-note my_note Cangjie-my-note
```

Multi-word note content is supported:

```powershell
target\manual\main.exe add-note my_note Cangjie personal syntax note
```

39. Search the added note:

```powershell
target\manual\main.exe ask Cangjie-my-note
```

40. Add a course-summary knowledge item:

```powershell
target\manual\main.exe add-official course_if_note Cangjie-if-expression-note
```

41. Show knowledge categories:

```powershell
target\manual\main.exe categories
```
