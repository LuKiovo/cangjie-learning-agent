# Cangjie Learning Agent

面向仓颉初学者的本地知识库学习助手 Agent。

## Project Goal

本项目计划使用仓颉语言实现一个学习助手，基于本地仓颉官方文档和用户自建 `.md/.txt` 知识库回答语法问题，并在回答中标注资料来源。

## Knowledge Base

Local knowledge files are stored in:

- `knowledge_base/official/`
- `knowledge_base/user_notes/`

The first version only targets `.md` and `.txt` files.

Teacher slides can be kept locally in `HCCDA-Cangjie 仓颉编程语言入门级开发者认证-授课-PDF/`. The PDF folder is ignored by Git; searchable content should be converted or summarized into `.md` or `.txt`.

The repository includes `knowledge_base/official/hccda_beginner_index.md` as a searchable course-topic index aligned with the teacher slides.

## Run

```powershell
New-Item -ItemType Directory -Force target\manual
cjc -p src --output-dir target\manual
target\manual\main.exe
```

Search local knowledge files:

```powershell
target\manual\main.exe Cangjie
```

Ask a Cangjie syntax question:

```powershell
target\manual\main.exe ask Cangjie
```

Generate a practice task:

```powershell
target\manual\main.exe practice ArrayList
```

Show CLI help:

```powershell
target\manual\main.exe help
```

Add a user note:

```powershell
target\manual\main.exe add-note syntax_note Cangjie-syntax-note
```

Add categorized personal knowledge:

```powershell
target\manual\main.exe add-note var_note Cangjie-var-note
target\manual\main.exe add-example hello_example Cangjie-hello-example
target\manual\main.exe add-error semicolon_error Cangjie-error-note
```

## IDE

This project can be opened in CodeArts IDE for Cangjie from the repository root.

## Planned Acceptance Items

1. 项目骨架初始化
2. 本地知识库导入
3. 用户新增笔记、示例代码、常见报错说明
4. 知识库检索
5. 大模型 API 调用
6. 回答来源标注
7. 桌面 GUI 或网页界面
