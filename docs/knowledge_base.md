# Local Knowledge Base

The project keeps local knowledge files under `knowledge_base/`.

- `knowledge_base/official/`: local copies of official Cangjie documents.
- `knowledge_base/user_notes/`: user-created notes, examples, and error explanations.
  - `syntax_notes/`: personal syntax notes.
  - `examples/`: personal example code notes.
  - `errors/`: personal compiler error notes.

Only `.md` and `.txt` files are in scope for the first version.

Knowledge names used by add commands must be simple file names. Names containing `/`, `\`, or `..` are rejected so user notes stay inside the local knowledge base directories.

Existing `.md` or `.txt` files can be imported with:

```powershell
target\manual\main.exe import-note imported_note docs\knowledge_base.md
target\manual\main.exe import-example imported_example docs\knowledge_base.md
target\manual\main.exe import-error imported_error docs\knowledge_base.md
target\manual\main.exe import-official imported_course docs\knowledge_base.md
```

Import commands copy the source text into the selected knowledge category. Other file types are rejected.

## Course Slides

The local course slide folder is ignored by Git:

- `HCCDA-Cangjie 仓颉编程语言入门级开发者认证-授课-PDF/`

Use the slides as reference material, but do not commit the PDF files. When a slide section should become searchable, summarize or export it into `.md` or `.txt` and place it under `knowledge_base/official/`.
