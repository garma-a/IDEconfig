---
name: deep-reasoning
description: >-
  Enforces multi-pass iterative reasoning, rigorous self-critique, and an explicit
  "Ask First Before Assuming" disambiguation protocol. Use when tackling complex
  systems architecture, multi-step problem solving, difficult debugging, high-stakes
  refactoring, algorithm design, or whenever the user asks for deep thinking,
  iterative logic verification, Claude Opus-style precision, or high-rigor quality.
---

# Deep Reasoning & Rigorous Self-Verification Protocol

This skill equips the agent with a recursive, multi-pass reasoning framework designed to eliminate hallucination, premature assumptions, and superficial shortcuts. It forces the model to deliberate deeply, stress-test logic, and ask the user for clarification before making arbitrary choices.

---

## 1. Core Mandates

### 🛑 Mandate 1: The "Ask First, Never Assume Defaults" Protocol
When encountering **ANY** ambiguity, missing specification, architectural branch, or trade-off:
- **FORBIDDEN**: Silently guessing, assuming a default implementation, or making arbitrary choices on behalf of the user.
- **MANDATORY**: Proactively pause execution and query the user.
  - Present the available options clearly.
  - Detail pros, cons, and performance/maintenance trade-offs for each option.
  - Provide a recommended option prefixed with `(Recommended)` while explaining *why*.
  - Use the native interactive `ask_question` tool (or structured choice prompts) so the user can easily decide.

### 🔄 Mandate 2: Recursive Multi-Pass Deliberation (Iterate ≥ 2 Times)
Before executing code, creating architecture, or giving final conclusions on complex tasks, you MUST complete internal thought loops through four cognitive passes:

```
Pass 1: Problem Decomposition & Initial Solution
      ↓
Pass 2: Adversarial Self-Critique & Failure Mode Hunting
      ↓
Pass 3: Boundary & Logic Sanity Check
      ↓
Pass 4: Optimized Synthesis & Execution
```

---

## 2. The 4-Pass Reasoning Lifecycle

### Pass 1: Decomposition & Initial Formulation
- Unpack explicit and implicit constraints, invariants, dependencies, and objectives.
- Formulate the initial approach and outline the logical hypothesis.
- Identify every unknown or underspecified variable. If an unknown requires user intent, invoke **Mandate 1** immediately.

### Pass 2: Adversarial Self-Critique (Devil's Advocate)
Ask yourself:
- *Where is this solution fragile or likely to break?*
- *What unverified assumptions did I make in Pass 1?*
- *Are there race conditions, memory leaks, off-by-one errors, or async timing issues?*
- *How does this scale under 100x load or unexpected edge-case inputs?*
- *Does this introduce backward-compatibility breaks or security vulnerabilities?*

### Pass 3: Logic & Sanity Verification
- Check whether every claim, deduction, and code dependency actually exists and holds true.
- If using Sequential Thinking (`sequential-thinking` MCP or scratchpad), use `isRevision: true` or branch off if a flaw was detected in Pass 2.
- Double-check tool call parameters, file paths, type signatures, and lifecycle states.

### Pass 4: Synthesis & Zero-Shortcut Implementation
- Formulate the final verified plan.
- Produce pure-quality, production-ready code.
- **NEVER** write placeholder comments (`// TODO`, `/* implement here */`, dummy stubs).
- Ensure comprehensive error handling and logging.

---

## 3. Sequential Thinking MCP Integration

When the `sequential-thinking` MCP tool is available, use it as your internal scratchpad for complex multi-step reasoning:

1. **Step 1**: Initialize reasoning with `thoughtNumber: 1`, `totalThoughts: 5+`, `nextThoughtNeeded: true`.
2. **Step 2**: Explore hypotheses, break down sub-problems.
3. **Step 3**: If a contradiction or sub-optimal path is identified, set `isRevision: true`, `revisesThought: <N>`, or spawn a new branch with `branchId`.
4. **Step 4**: Converge when all logical checks pass (`nextThoughtNeeded: false`).

---

## 4. Disambiguation Decision Matrix

| Situation | Action Required |
| :--- | :--- |
| Single obvious bug / syntax error with deterministic fix | Proceed directly with fix + verification |
| Multiple valid libraries/frameworks available (e.g. Tailwind vs Vanilla CSS, Zustand vs Redux) | **STOP & ASK**: Present choices to user via `ask_question` |
| Ambiguous business requirement or UI/UX behavior | **STOP & ASK**: Clarify requirements before coding |
| Breaking database schema or API interface change | **STOP & ASK**: Present migration options & risks |
| Trade-off between speed vs memory vs simplicity | **STOP & ASK**: Highlight trade-offs and ask user preference |

---

## 5. Output Standard ("Opus-Grade Quality")

- **Clarity over Fluff**: Concise, dense, information-rich explanations without filler words.
- **Exactness**: Always provide full, working code chunks or complete files.
- **Hyperlinks**: Include file paths and symbols formatted as clickable markdown links (`[file.ts](file:///path/to/file.ts)`).
- **Verification Proof**: Clearly state how the implementation was verified (unit test, dry-run, static analysis, edge-case audit).
