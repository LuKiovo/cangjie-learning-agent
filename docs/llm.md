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
