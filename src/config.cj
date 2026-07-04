package cangjie_learning_agent

import std.env.*

func envOrDefault(name: String, defaultValue: String): String {
    return getVariable(name) ?? defaultValue
}

func isConfigured(value: String): Bool {
    return !value.isEmpty()
}

func printLlmStatus(): Unit {
    let endpoint = envOrDefault("CANGJIE_AGENT_LLM_ENDPOINT", defaultLlmEndpoint())
    let model = envOrDefault("CANGJIE_AGENT_LLM_MODEL", "")
    let apiKey = envOrDefault("CANGJIE_AGENT_API_KEY", "")

    println("LLM configuration:")
    println("- endpoint: ${endpoint}")
    println("- model configured: ${isConfigured(model)}")
    println("- api key configured: ${isConfigured(apiKey)}")
    println("Security: API keys are read from environment variables and are not printed.")
}
