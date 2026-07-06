<!-- markdownlint-disable MD013 -->

# Mermaid Templates

Starter templates by diagram type. Copy one into the target document folder, rename it with a stable basename, replace labels with domain language, then render with `scripts/render.mjs`.

| Template | Use for |
| --- | --- |
| `architecture.mmd` | Layered service/system diagrams using portable flowcharts |
| `flowchart.mmd` | Processes, decision trees, workflows |
| `sequence.mmd` | API calls, auth flows, message passing |
| `er.mmd` | Database entities and relationships |
| `class.mmd` | Domain models and object relationships |
| `state.mmd` | Lifecycles and state machines |
| `gantt.mmd` | Roadmaps, delivery plans, schedules |
| `mindmap.mmd` | Concept maps, brainstorming, documentation outlines |
| `c4-context.mmd` | High-level system context diagrams |
| `journey.mmd` | User journeys and experience maps |

Prefer `flowchart` for architecture when portability matters. Use `C4Context` only when the active Mermaid backend supports it.
