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
