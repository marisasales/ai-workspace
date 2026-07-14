---
name: project-architect
description: >-
  Enforce and scale project directory structures and file placements across
  Python, Java, Node.js, and Frontend ecosystems. ACTIVATE this skill
  whenever the user asks to create a new project, add a route/component/
  service, scaffold a project structure, restructure folders, or asks
  "where should I put this file?". Also trigger when the user mentions
  project structure, directory layout, folder organization, architecture
  blueprints, or "clean up" a project. This skill OUTPUTS ASCII tree
  snippets — it does NOT generate code implementation, write business
  logic, or review existing code.
license: MIT
---

# Project Architect Core Protocols

Focus strictly on file/folder locations and architectural constraints. Do not review code implementation.

---

## When to use this skill

Trigger **whenever** the user:

1. **Asks to create a new project:** "scaffold a project", "create a project structure", "set up a new app"
2. **Adds a new artifact:** "add a route for users", "create a new service", "make a component for X"
3. **Asks about placement:** "where should I put this?", "what folder does this go in?"
4. **Requests restructuring:** "restructure the project", "clean up folders", "reorganize the codebase"
5. **Mentions a stack:** "I'm using FastAPI", "it's a Spring Boot project", "building with Next.js"
6. **Asks for architecture advice:** "what's the right folder structure for X?", "how should I organize my project?"

---

## Activation & Decision Rules

* **No Context:** If the project stack (Python, Java, Node.js, Frontend) is omitted, demand clarification before generating paths.
* **Legacy Layouts:** Adhere to the existing workspace structure. Only enforce these blueprints upon explicit "restructure" or "clean up" requests.
* **Trigger:** For every new route, component, or service added, output a minimal ASCII tree snippet of the target location.

---

## Choosing the Right Architecture (Java)

When a user says they're using Spring Boot / Java, determine which blueprint fits best:

| Criteria              | Layered (small–medium)         | DDD (medium–large)                          |
| --------------------- | ------------------------------ | ------------------------------------------- |
| **Team size**         | 1–5 devs                       | 5+ devs                                     |
| **Bounded contexts**  | Single context                 | Multiple bounded contexts                   |
| **Domain complexity** | CRUD-heavy, simple rules       | Complex business rules, workflows, policies |
| **Evolution**         | Stable, few new features       | Rapidly evolving, frequent additions        |
| **Module coupling**   | Tight coupling OK              | Strict decoupling between domains           |
| **Project examples**  | APIs, dashboards, admin panels | Fintech, logistics, healthcare, e-commerce  |

**Default** to Layered unless the user explicitly mentions multiple domains, bounded contexts, or complex business rules — then suggest DDD.

---

## Architecture Blueprints

### 1. Python (Src-Layout)

```text
myproject/
├── .github/workflows/ci.yml       # CI/CD pipeline automation
├── .gitignore                     # Standard Python ignores (venv, __pycache__)
├── .env.example                   # Template for environment variables
├── README.md                      # Project documentation
├── pyproject.toml                 # Build system, dependencies, and tool configs
├── src/
│   └── mypackage/
│       ├── __init__.py            # Marks package and exposes version/explicit exports
│       ├── main.py                # Application entry point & CLI orchestrator
│       ├── config.py              # Settings management (Pydantic Settings / Decouple)
│       ├── dependencies.py        # Dependency injection (get_db, get_current_user)
│       ├── api/
│       │   ├── __init__.py
│       │   └── routes.py          # Routing layer (FastAPI/Flask). HTTP status codes only.
│       ├── models/
│       │   ├── __init__.py
│       │   └── user.py            # Data layer. ORM (SQLAlchemy/Tortoise) or ODM definitions
│       ├── schemas/
│       │   ├── __init__.py
│       │   └── user.py            # Data validation layer (Pydantic / Marshmallow)
│       └── services/
│           ├── __init__.py
│           └── user_service.py    # Core business logic layer. No HTTP/DB implementation
└── tests/
    ├── __init__.py
    ├── conftest.py                # Global Pytest fixtures (DB sessions, app clients)
    ├── test_api.py                # Integration tests for routes
    └── test_services.py           # Unit tests for business logic
```

### 2. Node.js / TypeScript (Express / Fastify)

```text
myproject/
├── .env.example                   # Template for environment variables
├── .gitignore
├── package.json                   # Dependencies and scripts
├── tsconfig.json                  # Strict TypeScript config with path aliases
├── README.md
├── src/
│   ├── index.ts                   # Entry point: server bootstrap, listen
│   ├── app.ts                     # Express/Fastify app factory, middleware registration
│   ├── config/
│   │   └── index.ts               # Environment-based config loader (dotenv, env-var)
│   ├── routes/
│   │   └── user.routes.ts         # Route definitions, delegate to controllers
│   ├── controllers/
│   │   └── user.controller.ts     # Request handlers: parse input, call service, send response
│   ├── services/
│   │   └── user.service.ts        # Business logic layer. No HTTP awareness.
│   ├── middleware/
│   │   ├── auth.ts                # Authentication / authorization middleware
│   │   └── error-handler.ts       # Global error handler
│   ├── models/
│   │   └── user.model.ts          # Database models (Prisma, Mongoose, TypeORM)
│   ├── validators/
│   │   └── user.validator.ts      # Request validation schemas (Zod / Joi)
│   ├── utils/
│   │   └── helpers.ts             # Pure utility functions
│   └── types/
│       └── index.ts               # Shared TypeScript types/interfaces
└── tests/
    ├── setup.ts                   # Test DB setup, global mocks
    ├── controllers/
    └── services/
```

### 3. Java / Kotlin (Spring Boot Layered) — small to medium projects

```text
myproject/
├── .gitignore
├── README.md
├── pom.xml or build.gradle(.kts)  # Dependency management and build configuration
├── src/
│   ├── main/
│   │   ├── java/com/company/project/
│   │   │   ├── ProjectApplication.java  # Spring Boot entry point
│   │   │   ├── config/                  # Security, Beans, Middleware configuration
│   │   │   ├── controller/              # REST Controllers. Endpoint mapping & validation trigger
│   │   │   ├── dto/                     # Request/Response Data Transfer Objects (Records)
│   │   │   ├── exception/               # Global Exception Handler (@ControllerAdvice)
│   │   │   ├── model/                   # JPA Entities / Database Mapping
│   │   │   ├── repository/              # Spring Data Repositories (JPA / Mongo Interfaces)
│   │   │   └── service/                 # @Transactional business logic
│   │   └── resources/
│   │       ├── application.yml          # Core Spring configuration
│   │       ├── application-dev.yml      # Development profile
│   │       └── db/migration/            # Flyway / Liquibase migrations
│   └── test/
│       └── java/com/company/project/    # Unit + Integration tests (MockMvc, @SpringBootTest)
```

### 3.5 Java / Kotlin (Spring Boot DDD) — medium to large projects

Use when the project has multiple bounded contexts with complex business rules. Each domain is a self-contained module with its own controller, application service, domain model, and infrastructure.

```text
myproject/
├── .gitignore
├── README.md
├── pom.xml or build.gradle(.kts)
├── docker-compose.yml             # Local infrastructure (DB, message broker)
└── src/
    ├── main/
    │   ├── java/com/company/project/
    │   │   ├── ProjectApplication.java
    │   │   ├── shared/                     # Cross-cutting, shared across domains
    │   │   │   ├── config/                 # Global config (security, serialization, CORS)
    │   │   │   ├── exception/              # Base exception hierarchy
    │   │   │   └── util/                   # Shared utilities (monetary, date, validation)
    │   │   │
    │   │   └── domain/                     # One sub-package per bounded context
    │   │       └── order/                  # Example: Order domain
    │   │           ├── controller/         # REST controller, thin — delegates to app service
    │   │           ├── dto/                # Request/Response DTOs specific to this domain
    │   │           ├── application/        # Application (use-case) layer
    │   │           │   ├── service/        # Use-case orchestrators (CreateOrderUseCase)
    │   │           │   └── port/           # Inbound/outbound port interfaces (repository ports)
    │   │           ├── domain/             # Domain layer — pure business logic, no frameworks
    │   │           │   ├── model/          # Aggregates, Entities, Value Objects
    │   │           │   │   ├── Order.java
    │   │           │   │   ├── OrderId.java       # Value Object
    │   │           │   │   ├── OrderItem.java
    │   │           │   │   └── OrderStatus.java   # Enum / Value Object
    │   │           │   ├── service/        # Domain services (complex cross-entity logic)
    │   │           │   ├── repository/     # Repository interfaces (ports)
    │   │           │   └── event/          # Domain events (OrderPlacedEvent)
    │   │           └── infrastructure/     # Adapters — framework implementations of ports
    │   │               ├── persistence/    # JPA implementations of repository interfaces
    │   │               ├── messaging/      # Event publishers (Kafka, RabbitMQ)
    │   │               └── client/         # External API clients
    │   │
    │   └── resources/
    │       ├── application.yml
    │       ├── application-dev.yml
    │       └── db/migration/
    │           ├── V1__create_order_table.sql
    │           └── V2__create_order_item_table.sql
    └── test/
        └── java/com/company/project/
            ├── domain/
            │   └── order/
            │       ├── domain/             # Unit tests — pure domain logic, no Spring
            │       └── application/        # Use-case integration tests
            └── shared/                     # Shared test config, fixtures
```

**Key DDD rules:**

- Domain layer has **zero framework dependencies** — no Spring annotations, no JPA. Pure Java/Kotlin.
- Infrastructure implements ports defined in the domain layer (hexagonal architecture inside each context).
- Application services are **use-case orchestrators** — one method = one use case. They coordinate domain objects and infrastructure but contain no business logic.
- Bounded contexts communicate via **domain events**, not direct service calls.
- Keep `shared/` minimal — shared kernel should be small and stable.

### 4. Frontend — Framework (Feature-Driven React / Next.js / Vue + Vite)

```text
myproject/
├── .env.example
├── package.json
├── tsconfig.json                  # Strict TypeScript with path aliases (@/*)
├── vite.config.ts                 # Vite config: aliases, proxy, build targets
└── src/
    ├── assets/                    # Static global assets (images, fonts)
    ├── components/
    │   ├── common/                # Atomic UI primitives (Button, Input, Modal)
    │   └── layout/                # Shell components (Navbar, Sidebar, Footer)
    ├── features/
    │   └── auth/                  # Domain-driven slice (self-contained)
    │       ├── components/        # Feature-specific components (LoginForm)
    │       ├── hooks/             # Feature-specific hooks (useAuth)
    │       ├── services/          # API client calls (authApi.ts)
    │       └── types/             # Domain-specific type definitions
    ├── hooks/                     # Shared global hooks (useTheme, useWindowSize)
    ├── store/ or context/         # Global state (Zustand / Redux / Context)
    ├── styles/                    # Global CSS, Tailwind directives
    ├── utils/                     # Pure utility functions (formatters, validators)
    └── app/ or pages/             # Routing views (Next.js App Router / React Router)
```

### 5. Frontend — Static (Vanilla HTML / CSS / JS + Vite)

```text
myproject/
├── node_modules/                  # Vite dev tooling
├── package.json                   # Build scripts
├── vite.config.js                 # Vite config (aliases, multi-page)
├── .gitignore
├── README.md
├── index.html                     # Entry point (<script type="module">)
└── src/
    ├── assets/                    # Images, icons, local media
    ├── css/
    │   ├── main.css               # Central stylesheet (aggregates imports)
    │   ├── base.css               # Reset, custom properties, typography
    │   └── components/            # Scoped styles (.card, .navbar)
    ├── js/
    │   ├── main.js                # Bootstrap, DOMContentLoaded init
    │   ├── components/            # UI logic (modal.js, dropdown.js)
    │   └── utils/                 # Helpers (api.js, formatters.js)
    └── pages/                     # Multi-page app views
        ├── about.html
        ├── contact.html
        └── dashboard.html
```

---

## Output Expectation

Every response must include three parts:

**Target:** What is being created (e.g., "creating a new UserService for the auth module").
**Tree:** ASCII snippet of the destination path in context:

```text
src/
└── features/
    └── auth/
        └── services/
            └── user.service.ts    # <-- new
```

**Rule:** Single-sentence architectural justification (e.g., "Services encapsulate business logic and are consumed by controllers, keeping the route layer thin.").

### Example — User adds a login route to an Express app:

> **Target:** Adding `POST /auth/login` route and controller.
> 
> **Tree:**
> 
> ```text
> src/
> ├── routes/
> │   └── auth.routes.ts           # <-- new
> └── controllers/
>     └── auth.controller.ts       # <-- new
> ```
> 
> **Rule:** Routes delegate to controllers which delegate to services — each layer has one responsibility and is testable in isolation.

---

## Constraints

- **Banned:** Generating code implementation, business logic, or file contents.
- **Banned:** Modifying existing project files or folder structures automatically.
- **Banned:** Reviewing code quality, style, or correctness.
- **Output only:** ASCII tree snippets and architectural justification — no scaffolding commands unless explicitly asked.
- **Stick to conventions:** If the project already has a structure (e.g., no `src/` folder), adapt to it instead of forcing a blueprint.

---

## Scripts

The `scripts/validate-structure` script checks whether a project follows one of the architecture blueprints. Run it from the project root:

```bash
<path-to-skill>/scripts/validate-structure <project-root> [blueprint-name]
```

Available blueprints: `python`, `node`, `java` (Layered), `java-ddd` (DDD), `frontend-framework`, `frontend-static`.
Omitting `blueprint-name` auto-detects the stack from `pyproject.toml`, `package.json`, `pom.xml`, etc.
DDD is detected automatically when `domain/*/domain/model` is found in the Java source tree.