# Acceptance Log

## 1. Project Skeleton

Status: initialized and runnable.

Checks:

- `Agents.md` exists locally.
- `.gitignore` excludes `Agents.md`.
- Initial repository files do not include local-only project notes.
- `cjpm run` starts the Cangjie executable.

## 2. Knowledge Base Layout

Status: initialized.

Checks:

- Official documents have a local directory.
- User notes have a local directory.
- The first version limits knowledge files to `.md` and `.txt`.

## 3. Knowledge Base CLI Entry

Status: initialized.

Checks:

- The Cangjie executable prints the local official document path.
- The Cangjie executable prints the local user notes path.

## 4. Knowledge File Counter

Status: initialized.

Checks:

- The Cangjie CLI recursively scans `knowledge_base/official`.
- The Cangjie CLI recursively scans `knowledge_base/user_notes`.
- The Cangjie CLI counts only `.md` and `.txt` files.

Note: after importing `std.fs`, `cjpm run` can fail in this workspace path with `Invalid utf8 byte sequence`; direct `cjc` compilation succeeds and is used for verification.

## 5. Source File Listing

Status: initialized.

Checks:

- The Cangjie CLI lists `.md` and `.txt` files from official documents.
- The Cangjie CLI lists `.md` and `.txt` files from user notes.
- Each listed source includes its knowledge area label.

## 6. Knowledge File Reading

Status: initialized.

Checks:

- The Cangjie CLI reads local `.md` and `.txt` files as UTF-8 text.
- The Cangjie CLI reports total text characters for official documents.
- The Cangjie CLI reports total text characters for user notes.

## 7. Keyword Search

Status: initialized.

Checks:

- The Cangjie CLI accepts one keyword argument.
- The Cangjie CLI searches local `.md` and `.txt` knowledge files.
- The Cangjie CLI prints matched source paths and total match count.

## 8. Source-Backed Answer Skeleton

Status: initialized.

Checks:

- The Cangjie CLI prints an answer section for a keyword query.
- The answer section depends on whether local sources matched.
- The matched sources remain visible before the answer section.

## 9. Add User Note

Status: initialized.

Checks:

- The Cangjie CLI supports `add-note <name> <content>`.
- The note is saved under `knowledge_base/user_notes`.
- The saved note can be discovered by the existing keyword search.

## 10. Personalized Knowledge Categories

Status: initialized.

Checks:

- User syntax notes are saved under `knowledge_base/user_notes/syntax_notes`.
- User examples are saved under `knowledge_base/user_notes/examples`.
- User error notes are saved under `knowledge_base/user_notes/errors`.
- The existing recursive search discovers files in all user note subdirectories.

## 11. Ask Syntax Question

Status: initialized.

Checks:

- The Cangjie CLI supports `ask <question>`.
- The command searches local knowledge files for related sources.
- The command prints an answer section with matched sources visible.

## 12. Focused Answer Sources

Status: initialized.

Checks:

- Query commands show matched sources instead of listing every source first.
- The default no-query command still lists all local sources for inspection.

## 13. Learning Suggestion

Status: initialized.

Checks:

- `ask <question>` prints a learning suggestion when sources match.
- `ask <question>` prints a different learning suggestion when no source matches.

## 14. Course Slide Reference Policy

Status: initialized.

Checks:

- Local teacher slide PDFs are documented as reference-only material.
- The slide PDF folder is ignored by Git.
- Searchable course knowledge remains `.md` or `.txt` under `knowledge_base/official`.

## 15. Course-Aligned Knowledge Index

Status: initialized.

Checks:

- The official knowledge base contains a searchable HCCDA beginner course index.
- The index covers all six teacher slide topics.
- The existing keyword search can match course topics from the index.

## 16. Knowledge Module Split

Status: initialized.

Checks:

- Knowledge base logic lives outside `main.cj`.
- `main.cj` keeps the command-line flow.
- Existing `ask` behavior remains unchanged after the split.

## 17. Agent Answer Module

Status: initialized.

Checks:

- Agent answer text lives outside `main.cj`.
- `main.cj` delegates answer printing to the agent module.
- Existing `ask` output remains unchanged.

## 18. CLI Help

Status: initialized.

Checks:

- The Cangjie CLI supports `help`.
- The help output lists query and knowledge-add commands.
- The default no-query output points users to `help`.

## 19. Practice Task Command

Status: initialized.

Checks:

- The Cangjie CLI supports `practice <topic>`.
- The command searches local knowledge files for matched sources.
- The command prints a practice task and checklist based on match status.

## 20. Knowledge Stats Command

Status: initialized.

Checks:

- The Cangjie CLI supports `stats`.
- The command prints official and user note file counts.
- The command prints official and user note character counts.

## 21. Source Listing Command

Status: initialized.

Checks:

- The Cangjie CLI supports `sources <keyword>`.
- The command lists matched source files only.
- The command prints total match count without generating an answer.

## 22. Error Review Command

Status: initialized.

Checks:

- The Cangjie CLI supports `review-error <keyword>`.
- The command searches local compiler error notes.
- The command prints a debugging checklist based on match status.

## 23. Classroom Demo Command

Status: initialized.

Checks:

- The Cangjie CLI supports `demo`.
- The command prints a recommended classroom demonstration flow.
- The flow covers stats, sources, ask, practice, error review, and adding a note.

## 24. Classroom Demo Script

Status: initialized.

Checks:

- The repository contains a classroom demo script.
- The script covers build, help, stats, sources, ask, practice, error review, add-note, and follow-up search.
- The CLI `demo` command and the document use the same demonstration flow.

## 25. LLM Configuration Status

Status: initialized.

Checks:

- The Cangjie CLI supports `llm-status`.
- LLM endpoint, model, and API key are read from environment variables.
- The command reports only whether the API key is configured and never prints the key value.

## 26. Primary Source In Answers

Status: initialized.

Checks:

- `ask <question>` prints a primary source when local sources match.
- `practice <topic>` prints a primary source when local sources match.
- `review-error <keyword>` prints a primary source when local error notes match.

## 27. Knowledge Management Commands

Status: initialized.

Checks:

- The Cangjie CLI supports `add-official <name> <content>`.
- The Cangjie CLI supports `categories`.
- Official/course-summary knowledge can be added, searched, and reported in statistics.

## 28. Command Usage Validation

Status: initialized.

Checks:

- Commands with missing required arguments print a usage error.
- Invalid command usage returns a non-zero exit code.
- Valid command behavior remains unchanged.

## 29. Project Delivery Documentation

Status: initialized.

Checks:

- README describes project goal, implemented features, run commands, demo flow, course alignment, and current limits.
- Project status document separates completed and incomplete items.
- Documentation does not claim real LLM API calls or GUI are complete.

## 30. Source-backed LLM Prompt Preview

Status: initialized.

Checks:

- The Cangjie CLI supports `prompt <question>`.
- The command searches local knowledge files before building the prompt preview.
- The prompt preview includes match count, primary source, and answer rules for future LLM API integration.

## 31. Multi-word CLI Input

Status: initialized.

Checks:

- Question commands join all words after the command into one query.
- Knowledge-add commands join all words after the name into one content string.
- Existing single-word command behavior remains valid.

## 32. Multi-word Retrieval Fallback

Status: initialized.

Checks:

- Search first keeps the full multi-word query visible to the user.
- If a full query is not contained in a file, each query word can still match local knowledge.
- `ask`, `prompt`, `practice`, `sources`, and `review-error` share the fallback retrieval behavior.

## 33. Source Content Inspection

Status: initialized.

Checks:

- The Cangjie CLI supports `show-source <keyword>`.
- The command finds the first local source using the same retrieval fallback as question commands.
- The command prints the primary source path and source text for inspection.

## 34. Safe Knowledge Name Validation

Status: initialized.

Checks:

- Knowledge-add commands reject names containing `/`, `\`, or `..`.
- Invalid knowledge names return a non-zero exit code.
- Valid knowledge names still save content under the intended knowledge base category.

## 35. Primary Source Context In Agent Output

Status: initialized.

Checks:

- `ask <question>` prints the primary source text when local sources match.
- `prompt <question>` prints local source context when a primary source is available.
- Commands without local matches still clearly report missing source context.
