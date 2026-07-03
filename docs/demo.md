# Classroom Demo Script

This script demonstrates the current CLI learning assistant milestone.

## Build

```powershell
New-Item -ItemType Directory -Force target\manual
cjc -p src --output-dir target\manual
```

## Demo Flow

1. Show available commands:

```powershell
target\manual\main.exe help
```

2. Show knowledge base statistics:

```powershell
target\manual\main.exe stats
```

3. Show matched source files:

```powershell
target\manual\main.exe sources ArrayList
```

4. Ask a Cangjie syntax question:

```powershell
target\manual\main.exe ask match
```

5. Generate a source-backed practice task:

```powershell
target\manual\main.exe practice ArrayList
```

6. Review a compiler error note:

```powershell
target\manual\main.exe review-error Cangjie-error-note
```

7. Add a personal syntax note:

```powershell
target\manual\main.exe add-note my_note Cangjie-my-note
```

8. Search the added note:

```powershell
target\manual\main.exe ask Cangjie-my-note
```
