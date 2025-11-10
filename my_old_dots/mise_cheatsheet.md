# Mise Cheatsheet - Red Hood Config

This cheatsheet provides a quick reference for using `mise` with your custom configuration (`~/dotfiles/config/mise/config.toml`).

## 1. Core Mise Commands

*   **Install all defined tools:**
    ```bash
    mise install
    ```
    This command will install all tool versions specified in your `config.toml` or `.tool-versions` files.

*   **Install a specific tool version:**
    ```bash
    mise install node@lts
    mise install python@latest
    ```

*   **Use a specific tool version (local to directory):**
    ```bash
    mise use --local node@20
    mise use --local python@3.11
    ```
    This creates a `.tool-versions` file in your current directory.

*   **Run a command with mise's environment:**
    ```bash
    mise exec -- node -v
    mise exec -- python --version
    ```

*   **List installed tool versions:**
    ```bash
    mise ls
    ```

*   **Show currently active tool versions:**
    ```bash
    mise current
    ```

## 2. Red Hood Shell Shortcuts

Inside your Zsh environment all high‑frequency tasks are wrapped in helpers:

| Purpose | Command | Equivalent |
|---------|---------|------------|
| Create (or recreate) `.venv` | `pyvenv` | `mise run python:venv` |
| Sync dependencies | `pysetup` | `mise run py:install` |
| Install dev deps | `pydev` | `mise run py:dev-install` |
| Run tests | `pytestall` | `mise run py:test` |
| Coverage report | `pycov` | `mise run py:coverage` |
| Format / lint | `pyfmt`, `pycheck` | `mise run py:fmt`, `mise run py:lint` |
| Java session tmux | `javadev` | `mise run session:java` |
| Node helpers | `nodeinstall`, `nodebuild`, `nodedev`, `nodetest` | respective `mise run node:*` |
| Go helpers | `gofmtproj`, `gotest` | respective `mise run go:*` |

➡️ View this cheatsheet quickly with `mcheat`. To pick a task interactively run `misetask` (fzf prompt over `mise tasks`).

## 3. Custom Tasks (mise run)

Your `config.toml` defines several custom tasks that automate common development workflows. You can run them using `mise run <task_name>`.

### Node.js Tasks
*   **Install Node.js dependencies (using pnpm):**
    ```bash
    mise run node:install
    ```
*   **Build Node.js project:**
    ```bash
    mise run node:build
    ```
*   **Start Node.js dev server:**
    ```bash
    mise run node:dev
    ```
*   **Run Node.js tests:**
    ```bash
    mise run node:test
    ```
*   **Lint Node.js code:**
    ```bash
    mise run node:lint
    ```

### Python Tasks
*   **Create or refresh virtualenv:**
    ```bash
    mise run python:venv
    ```
*   **Install Python dependencies (uv or pip):**
    ```bash
    mise run py:install
    ```
*   **Install Python dev dependencies:**
    ```bash
    mise run py:dev-install
    ```
*   **Run Python tests (pytest):**
    ```bash
    mise run py:test
    ```
*   **Run tests with coverage:**
    ```bash
    mise run py:coverage
    ```
*   **Format Python code (black, ruff):**
    ```bash
    mise run py:fmt
    ```
*   **Lint Python code (ruff, mypy):**
    ```bash
    mise run py:lint
    ```

### Go Tasks
*   **Tidy Go modules:**
    ```bash
    mise run go:tidy
    ```
*   **Download Go dependencies:**
    ```bash
    mise run go:download
    ```
*   **Build Go project:**
    ```bash
    mise run go:build
    ```
*   **Run Go tests:**
    ```bash
    mise run go:test
    ```
*   **Format Go code:**
    ```bash
    mise run go:fmt
    ```
*   **Vet Go code:**
    ```bash
    mise run go:vet
    ```

### Java (Maven) Tasks
*   **Clean Maven project:**
    ```bash
    mise run java:maven:clean
    ```
*   **Compile Maven project:**
    ```bash
    mise run java:maven:compile
    ```
*   **Run Maven tests:**
    ```bash
    mise run java:maven:test
    ```
*   **Package Maven project:**
    ```bash
    mise run java:maven:package
    ```
*   **Install Maven project:**
    ```bash
    mise run java:maven:install
    ```

### Java (Gradle) Tasks
*   **Clean Gradle project:**
    ```bash
    mise run java:gradle:clean
    ```
*   **Compile Gradle project:**
    ```bash
    mise run java:gradle:compile
    ```
*   **Run Gradle tests:**
    ```bash
    mise run java:gradle:test
    ```
*   **Build Gradle project:**
    ```bash
    mise run java:gradle:build
    ```

### Rust Tasks
*   **Build Rust project:**
    ```bash
    mise run rust:build
    ```
*   **Build Rust project (release):**
    ```bash
    mise run rust:build-release
    ```
*   **Run Rust tests:**
    ```bash
    mise run rust:test
    ```
*   **Format Rust code:**
    ```bash
    mise run rust:fmt
    ```
*   **Lint Rust code:**
    ```bash
    mise run rust:clippy
    ```

### Docker Tasks
*   **Build Docker image:**
    ```bash
    mise run docker:build
    ```
*   **Start Docker Compose services:**
    ```bash
    mise run docker:up
    ```
*   **Stop Docker Compose services:**
    ```bash
    mise run docker:down
    ```
*   **Show Docker Compose logs:**
    ```bash
    mise run docker:logs
    ```

### Project Creation Tasks
These tasks will prompt you for a project name and other details.
*   **Create new Node.js project:**
    ```bash
    mise run new:node
    ```
*   **Create new Python project:**
    ```bash
    mise run new:python
    ```
*   **Create new Go project:**
    ```bash
    mise run new:go
    ```
*   **Create new Spring Boot project (Maven):**
    ```bash
    mise run new:spring
    ```
*   **Create new Spring Boot project (Gradle):**
    ```bash
    mise run new:spring-gradle
    ```
*   **Create new Rust project:**
    ```bash
    mise run new:rust
    ```

### Composite Tasks (Orchestration)
*   **Install all dependencies for all configured languages:**
    ```bash
    mise run install
    ```
*   **Build all projects:**
    ```bash
    mise run build
    ```
*   **Run all tests:**
    ```bash
    mise run test
    ```
*   **Format all code:**
    ```bash
    mise run fmt
    ```
*   **Lint all code:**
    ```bash
    mise run lint
    ```
*   **Clean all build artifacts:**
    ```bash
    mise run clean
    ```

## 4. Global Tool Availability & Testing `http-server`

`mise` ensures that the tools you define in your `config.toml` (like `node`, `python`, `go`, etc.) are available in your shell environment.

To test `node` and `npm` (or `pnpm` as configured):

1.  **Ensure `node` and `pnpm` are installed via `mise`:**
    ```bash
    mise install
    ```
    (This will install `node@lts` and `pnpm@latest` as per your `config.toml`)

2.  **Verify `node` and `pnpm` are available:**
    ```bash
    node -v
    pnpm -v
    ```

3.  **Install `http-server` globally using `pnpm`:**
    ```bash
    pnpm add -g http-server
    ```

4.  **Create a simple `index.html` file for testing:**
    ```bash
    echo "<h1>Hello from http-server!</h1>" > index.html
    ```

5.  **Run `http-server`:**
    ```bash
    http-server
    ```
    You should see output indicating the server is running, typically on `http://localhost:8080`. Open this URL in your browser to verify.

6.  **Stop `http-server`:** Press `Ctrl+C` in the terminal where `http-server` is running.

This confirms that `node`, `pnpm`, and globally installed packages are working correctly through `mise`.
