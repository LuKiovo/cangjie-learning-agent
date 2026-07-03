# Local Knowledge Base

The project keeps local knowledge files under `knowledge_base/`.

- `knowledge_base/official/`: local copies of official Cangjie documents.
- `knowledge_base/user_notes/`: user-created notes, examples, and error explanations.
  - `syntax_notes/`: personal syntax notes.
  - `examples/`: personal example code notes.
  - `errors/`: personal compiler error notes.

Only `.md` and `.txt` files are in scope for the first version.

Knowledge names used by add commands must be simple file names. Names containing `/`, `\`, or `..` are rejected so user notes stay inside the local knowledge base directories.

## Course Slides

The local course slide folder is ignored by Git:

- `HCCDA-Cangjie 仓颉编程语言入门级开发者认证-授课-PDF/`

Use the slides as reference material, but do not commit the PDF files. When a slide section should become searchable, summarize or export it into `.md` or `.txt` and place it under `knowledge_base/official/`.
