# LLM API Configuration

The project does not store API keys in source files.

Set these environment variables before enabling real LLM calls:

- `CANGJIE_AGENT_LLM_ENDPOINT`
- `CANGJIE_AGENT_LLM_MODEL`
- `CANGJIE_AGENT_API_KEY`

Check configuration status:

```powershell
target\manual\main.exe llm-status
```

The command only prints whether each value is configured. It never prints the API key.

## Source-backed prompt preview

Before real HTTP calls are enabled, the CLI can build the prompt that would be sent to an LLM:

```powershell
target\manual\main.exe prompt match
```

The preview includes:

- beginner-oriented system instruction
- user question
- local match count
- primary local source path when available
- primary local source text when available
- answer rules that require source marking and clear assumptions

This keeps the future API integration tied to the local knowledge base instead of sending an unconstrained question.

## LLM request draft

The CLI can also build a source-backed request draft that is ready to connect to a future Cangjie HTTP client:

```powershell
target\manual\main.exe llm-request match
target\manual\main.exe export-llm-request match_llm_request match
```

The draft includes:

- environment variable names for endpoint, model, and API key
- the source-backed prompt payload
- local match count and primary source
- a note explaining how the payload maps to a future HTTP request

## Local LLM response archive

When a response is obtained externally or after a future HTTP client is connected, save it locally:

```powershell
target\manual\main.exe import-llm-response sample_response docs\match_answer.md
target\manual\main.exe show-llm-response sample_response
```

Only `.md` and `.txt` response files are accepted. This keeps response artifacts inspectable and aligned with the local knowledge-base workflow.
