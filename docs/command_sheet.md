# Cangjie Learning Agent Command Sheet

## Build

```powershell
cjc -p src --output-dir target\manual
```

## Core Demo

```powershell
target\manual\main.exe help
target\manual\main.exe self-check
target\manual\main.exe source-map
target\manual\main.exe trace match
target\manual\main.exe ask match
target\manual\main.exe card ArrayList
target\manual\main.exe llm-request match
target\manual\main.exe dashboard
target\manual\main.exe final-check
```

## Export Demo

```powershell
target\manual\main.exe export-answer match_answer match
target\manual\main.exe export-session arraylist_session ArrayList
target\manual\main.exe export-card arraylist_card ArrayList
target\manual\main.exe export-llm-request match_llm_request match
target\manual\main.exe export-dashboard dashboard
target\manual\main.exe export-final-check final_check
target\manual\main.exe export-trace match_trace match
target\manual\main.exe export-roadmap roadmap
target\manual\main.exe export-delivery-index delivery_index
```

## Personal Knowledge

```powershell
target\manual\main.exe add-note my_note Cangjie personal syntax note
target\manual\main.exe import-note imported_note docs\knowledge_base.md
target\manual\main.exe sources ArrayList
target\manual\main.exe show-source ArrayList
```
