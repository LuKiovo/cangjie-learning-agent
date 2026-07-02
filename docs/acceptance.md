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
