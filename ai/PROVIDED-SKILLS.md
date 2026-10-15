# Skills supplied by Codex and connected plugins

The source environment also exposes the skills below. These are managed by Codex or its plugin provider, separately from the 38 portable custom bundles in [README.md](README.md). Availability depends on the client version, installed plugins and account connections.

| Skills seen on the source system | Source / restoration reference |
| --- | --- |
| imagegen, openai-docs | [Official OpenAI skill catalog](https://github.com/openai/skills), [current plugin catalog](https://github.com/openai/plugins) |
| skill-creator, skill-installer | [Codex system skills](https://github.com/openai/skills/tree/main/skills/.system); system skills are supplied automatically by Codex |
| plugin-management | [Official plugin catalog](https://github.com/openai/plugins); install/enable through the client's plugin interface |
| sites | [Official plugin catalog](https://github.com/openai/plugins); requires the Sites plugin and its tools |
| work-pets:create-pet, work-pets:pets, work-pets:update-pet | [Official plugin catalog](https://github.com/openai/plugins); requires the ChatGPT Work Pets plugin and its tools |

Copying connector-backed skill text into agy or OpenCode does not install the corresponding service, tools or account authorization. Use each client's supported plugin integration when available. Keep provider-managed files in their managed locations to receive updates and avoid duplicate skill names.

[Codex skill discovery and provider-managed system scope](https://learn.chatgpt.com/docs/build-skills).
