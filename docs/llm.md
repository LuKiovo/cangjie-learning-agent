# LLM API Configuration

The project does not store API keys in source files.

Set these environment variables before running a live LLM call:

- `CANGJIE_AGENT_LLM_ENDPOINT` (optional, defaults to `https://api.deepseek.com/chat/completions`)
- `CANGJIE_AGENT_LLM_MODEL`
- `CANGJIE_AGENT_API_KEY`

Check configuration status:

```powershell
target\manual\main.exe llm-status
```

The command only prints whether each value is configured. It never prints the API key.

PowerShell example:

```powershell
$env:CANGJIE_AGENT_LLM_ENDPOINT = "https://api.deepseek.com/chat/completions"
$env:CANGJIE_AGENT_LLM_MODEL = "deepseek-chat"
$env:CANGJIE_AGENT_API_KEY = "your-api-key"
```

The project uses Cangjie code for the agent workflow and calls `curl` from `std.process` for the HTTPS transport, because this local Cangjie SDK exposes socket/process modules but no high-level HTTPS JSON client. If your key belongs to another domestic OpenAI-compatible provider, replace the endpoint and model with that provider's values.

## Real source-backed API call

After setting the environment variables, run:

```powershell
target\manual\main.exe llm-ask match
```

The command:

- searches local official/course files and user notes
- builds a source-backed prompt
- sends an OpenAI-compatible chat-completions request
- prints the model answer
- prints the local source path again after the answer

LLM response Markdown files under `llm_responses/` are ignored by Git so classroom tests do not upload private answer artifacts.

## Interactive Web UI

Start the Cangjie local Web server:

```powershell
target\manual\main.exe web 18080
```

Open:

```text
http://127.0.0.1:18080
```

The page supports local knowledge-base answers, real API answers, source display, and adding syntax notes.

## Source-backed prompt preview

The CLI can still build the prompt without calling the API:

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

The CLI can also build a source-backed request draft for review:

```powershell
target\manual\main.exe llm-request match
target\manual\main.exe export-llm-request match_llm_request match
```

The draft includes:

- environment variable names for endpoint, model, and API key
- the source-backed prompt payload
- local match count and primary source
- a note explaining how the payload maps to the HTTPS request

## Local LLM response archive

When a response is obtained externally or should be archived locally, save it:

```powershell
target\manual\main.exe import-llm-response sample_response docs\match_answer.md
target\manual\main.exe show-llm-response sample_response
```

Only `.md` and `.txt` response files are accepted. This keeps response artifacts inspectable and aligned with the local knowledge-base workflow.
