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
