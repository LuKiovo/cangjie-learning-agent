# Cangjie Learning Agent

面向仓颉初学者的本地知识库学习助手 Agent，使用仓颉语言实现。

## 项目目标

本项目基于本地仓颉官方/课程资料与用户自建 `.md/.txt` 知识库，回答仓颉语法问题，并辅助生成练习、整理示例、记录常见报错。回答会显示匹配来源和主来源，突出本地知识库检索与仓颉工程实现。

## 已实现功能

- 本地知识库目录：官方/课程资料、语法笔记、示例代码、常见报错。
- 知识库统计：查看官方资料和用户笔记的文件数量、文本字符数。
- 关键词检索：按关键词列出匹配来源，并用匹配分数选择主来源。
- 语法问答：`ask <question>` 检索本地资料并输出带来源和主来源上下文的回答。
- 练习生成：`practice <topic>` 基于来源生成练习任务。
- 小测生成：`quiz <topic>` 基于来源生成课堂小测。
- 示例生成：`example <topic>` 基于来源生成仓颉示例草稿。
- 报错复盘：`review-error <keyword>` 检索常见报错笔记并给出排错建议。
- 报错修复：`fix-error <keyword>` 基于本地报错笔记生成修复建议和代码草稿。
- 个性化新增：支持新增语法笔记、示例代码、报错说明和课程整理内容。
- 知识导入：支持把已有 `.md/.txt` 文件导入语法笔记、示例、报错或官方/课程资料。
- 分类统计：`category-stats` 分别统计官方资料、语法笔记、示例、报错文件数。
- 来源解释：`why-source <keyword>` 展示主来源选择分数和原因。
- LLM 配置检查：读取环境变量状态，不在代码中保存或打印 API Key。
- LLM Prompt 预览：`prompt <question>` 基于本地来源和主来源上下文生成未来 API 调用前的约束提示词。
- 项目摘要：`summary` 汇总已实现能力、知识库统计和当前限制。
- 工程标识：`version` 展示版本、仓库名、实现语言和知识库格式。
- 自检命令：`self-check` 输出本地验收检查结果。
- 报告导出：`export-report <name>` 在 `docs/` 下生成 Markdown 验收报告。

## 知识库结构

- `knowledge_base/official/`
- `knowledge_base/user_notes/syntax_notes/`
- `knowledge_base/user_notes/examples/`
- `knowledge_base/user_notes/errors/`

第一版只处理 `.md` 和 `.txt` 文件。老师课件可放在本地 `HCCDA-Cangjie 仓颉编程语言入门级开发者认证-授课-PDF/`，该目录被 Git 忽略；需要检索的课件内容应整理成 `.md` 或 `.txt` 放入知识库。

仓库内置 `knowledge_base/official/hccda_beginner_index.md`，作为与 HCCDA 仓颉入门课件对齐的可检索课程索引。
同时内置变量/表达式、Collection、match/控制流三个课程整理条目，便于演示更具体的语法检索和来源上下文。

## 构建运行

```powershell
New-Item -ItemType Directory -Force target\manual
cjc -p src --output-dir target\manual
target\manual\main.exe
```

## 常用命令

查看帮助：

```powershell
target\manual\main.exe help
```

查看课堂演示流程：

```powershell
target\manual\main.exe demo
```

查看项目摘要：

```powershell
target\manual\main.exe summary
```

查看工程版本：

```powershell
target\manual\main.exe version
```

运行本地自检：

```powershell
target\manual\main.exe self-check
```

导出验收报告：

```powershell
target\manual\main.exe export-report acceptance_report
```

查看知识库统计：

```powershell
target\manual\main.exe stats
```

查看分类统计：

```powershell
target\manual\main.exe category-stats
```

列出匹配来源：

```powershell
target\manual\main.exe sources ArrayList
```

解释主来源选择：

```powershell
target\manual\main.exe why-source ArrayList
```

查看第一条匹配来源内容：

```powershell
target\manual\main.exe show-source ArrayList
```

询问仓颉语法问题：

```powershell
target\manual\main.exe ask Cangjie
```

也可以直接输入多词问题：

```powershell
target\manual\main.exe ask ArrayList match expression
```

生成练习任务：

```powershell
target\manual\main.exe practice ArrayList
```

生成课堂小测：

```powershell
target\manual\main.exe quiz ArrayList
```

生成示例代码草稿：

```powershell
target\manual\main.exe example ArrayList
```

复盘常见报错：

```powershell
target\manual\main.exe review-error Cangjie-error-note
```

生成报错修复建议：

```powershell
target\manual\main.exe fix-error Cangjie-error-note
```

新增个人语法笔记：

```powershell
target\manual\main.exe add-note syntax_note Cangjie-syntax-note
```

新增内容支持多词文本：

```powershell
target\manual\main.exe add-note syntax_note Cangjie syntax note content
```

知识名称必须是简单文件名，不能包含路径分隔符或 `..`。

新增示例代码笔记：

```powershell
target\manual\main.exe add-example hello_example Cangjie-hello-example
```

新增常见报错说明：

```powershell
target\manual\main.exe add-error semicolon_error Cangjie-error-note
```

导入已有 `.md/.txt` 文件：

```powershell
target\manual\main.exe import-note imported_note docs\knowledge_base.md
target\manual\main.exe import-official imported_course docs\knowledge_base.md
```

新增官方/课程整理内容：

```powershell
target\manual\main.exe add-official course_if_note Cangjie-if-expression-note
```

查看 LLM 配置状态：

```powershell
target\manual\main.exe llm-status
```

预览带来源约束的 LLM Prompt：

```powershell
target\manual\main.exe prompt match
```

## 课堂演示

完整演示脚本见 [docs/demo.md](docs/demo.md)。推荐顺序为：

- `help`
- `summary`
- `stats`
- `sources ArrayList`
- `show-source ArrayList`
- `ask match`
- `prompt match`
- `example ArrayList`
- `practice ArrayList`
- `quiz ArrayList`
- `review-error Cangjie-error-note`
- `fix-error Cangjie-error-note`
- `add-note my_note Cangjie-my-note`
- `ask Cangjie-my-note`

## 课程资料对齐

项目参考 HCCDA 仓颉入门课件主题：

- 标识符、基础数据类型、控制台输入输出
- 变量、基础表达式运算
- 条件和循环表达式
- Collection 类型
- 函数与面向对象基础
- 综合案例的分层结构思想

同时参考 [aylqs2025/CangStream](https://github.com/aylqs2025/CangStream) 的纯仓颉 Agent 基础设施思路，尤其是后续 LLM API、JSON、HTTP、持久化方向。

## 当前限制

- 目前是 CLI 原型，还没有桌面 GUI 或网页界面。
- 目前已实现 LLM 配置检查和 Prompt 预览，但尚未真实调用大模型 API。
- 当前检索是简单关键词检索：优先匹配完整输入，多词问题会回退到单词匹配，并按匹配分数选择主来源；尚未实现向量检索。
- PDF 课件不直接作为检索输入，需要先整理为 `.md` 或 `.txt`。

## IDE

This project can be opened in CodeArts IDE for Cangjie from the repository root.

## 更多文档

- [docs/demo.md](docs/demo.md)
- [docs/knowledge_base.md](docs/knowledge_base.md)
- [docs/llm.md](docs/llm.md)
- [docs/acceptance.md](docs/acceptance.md)
- [docs/status.md](docs/status.md)
