# Cangjie Learning Agent Rubric

## Scoring Dimensions

| Dimension | Evidence | Status |
| --- | --- | --- |
| Cangjie implementation | All feature code is under `src/*.cj` | Ready |
| Local knowledge base | `knowledge_base/official` and `knowledge_base/user_notes` | Ready |
| Add/import knowledge | `add-*` and `import-*` commands | Ready |
| Retrieval and sources | `sources`, `show-source`, `why-source`, `trace` | Ready |
| Syntax answering | `ask`, `session`, `study-plan`, `card` | Ready |
| Practice support | `example`, `practice`, `quiz`, `fix-error` | Ready |
| LLM API preparation | `prompt`, `llm-request`, `export-llm-request` | Prepared |
| Interface artifact | `export-dashboard dashboard` | Static web ready |
| Final delivery | `final-check`, `delivery-index`, `command-sheet` | Ready |

## Notes

- Direct HTTP transport is intentionally marked as remaining work until the available Cangjie HTTP package is confirmed.
- The current implementation still demonstrates the agent engineering path: retrieval, prompt construction, source trace, output export, and response archive.
