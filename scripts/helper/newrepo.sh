#!/bin/bash

################################################################################
# newrepo - Advanced Polyglot Repository Creator
# 
# Automated scaffolding for C, C++, Python, TypeScript, JavaScript, Rust, Go, Java
# with language-specific build recipes and minimal base structures
#
# Usage: ./newrepo [project_name]
################################################################################

set -e

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS & TUI
# ═══════════════════════════════════════════════════════════════════════════════

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

DEFAULT_REPO_NAME="nameless"
GIT_FOLDER="$HOME/git"

# ═══════════════════════════════════════════════════════════════════════════════
# UNIVERSAL GITIGNORE
# ═══════════════════════════════════════════════════════════════════════════════

create_universal_gitignore() {
    cat > .gitignore << 'EOF'
# ═══════════════════════════════════════════════════════════════════════════════
# UNIVERSAL (All projects)
# ═══════════════════════════════════════════════════════════════════════════════
.DS_Store
.AppleDouble
.LSOverride
*.log
*.swp
*.swo
*~
.env
.env.local

# ═══════════════════════════════════════════════════════════════════════════════
# EDITOR / IDE
# ═══════════════════════════════════════════════════════════════════════════════
.vscode/
.idea/
*.iml
*.swp
*.swo
.history/
.sublime-workspace
.sublime-project

# ═══════════════════════════════════════════════════════════════════════════════
# PYTHON
# ═══════════════════════════════════════════════════════════════════════════════
__pycache__/
*.py[cod]
*$py.class
*.egg-info/
dist/
build/
.venv/
venv/
.pytest_cache/
*.egg

# ═══════════════════════════════════════════════════════════════════════════════
# NODE.JS / JAVASCRIPT / TYPESCRIPT
# ═══════════════════════════════════════════════════════════════════════════════
node_modules/
npm-debug.log
yarn-error.log
dist/
build/
*.tsbuildinfo
.next/

# ═══════════════════════════════════════════════════════════════════════════════
# C / C++
# ═══════════════════════════════════════════════════════════════════════════════
*.o
*.out
*.a
*.so
*.dll
*.dylib
*.exe
build/
cmake-build-debug/
cmake-build-release/
CMakeCache.txt
CMakeFiles/
Makefile

# ═══════════════════════════════════════════════════════════════════════════════
# RUST
# ═══════════════════════════════════════════════════════════════════════════════
/target/
**/*.rs.bk
Cargo.lock

# ═══════════════════════════════════════════════════════════════════════════════
# GO
# ═══════════════════════════════════════════════════════════════════════════════
/bin/
/dist/
*.exe
*.exe~
go.sum

# ═══════════════════════════════════════════════════════════════════════════════
# JAVA / KOTLIN
# ═══════════════════════════════════════════════════════════════════════════════
target/
*.class
*.jar
*.war
*.ear
.gradle/
build/
*.iml
.kotlin/

# ═══════════════════════════════════════════════════════════════════════════════
# OTHER
# ═══════════════════════════════════════════════════════════════════════════════
*.tmp
*.bak
.tmp/
EOF

    echo -e "${GREEN}✓ Universal .gitignore erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# PYTHON
# ═══════════════════════════════════════════════════════════════════════════════

create_python_structure() {
    local project_name="$1"
    
    mkdir -p src tests
    
    # src/__init__.py
    touch src/__init__.py
    
    # src/main.py
    cat > src/main.py << 'EOF'
#!/usr/bin/env python3
"""Main entry point for the application."""

import sys


def main():
    """Main function."""
    print(f"Hello from Python! Running on {sys.version}")


if __name__ == "__main__":
    main()
EOF
    
    # tests/__init__.py
    touch tests/__init__.py
    
    # tests/test_main.py
    cat > tests/test_main.py << 'EOF'
"""Tests for main module."""

import sys
import os

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))


def test_placeholder():
    """Placeholder test."""
    assert True
EOF
    
    # pyproject.toml
    cat > pyproject.toml << EOF
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$project_name"
version = "0.1.0"
description = "A minimal Python project"
readme = "README.md"
requires-python = ">=3.9"
dependencies = []

[project.scripts]
$project_name = "$project_name.main:main"
EOF
    
    # requirements.txt
    cat > requirements.txt << 'EOF'
# Add your dependencies here
# Example: requests==2.31.0
EOF
    
    echo -e "${GREEN}✓ Python 3.9+ (Modern pyproject.toml) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# TYPESCRIPT
# ═══════════════════════════════════════════════════════════════════════════════

create_typescript_structure() {
    local project_name="$1"
    
    mkdir -p src dist
    
    # package.json
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "A TypeScript project",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "test": "jest"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "typescript": "^5.3.0",
    "ts-node": "^10.9.0",
    "@types/node": "^20.10.0"
  }
}
EOF
    
    # tsconfig.json
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
    
    # src/index.ts
    cat > src/index.ts << 'EOF'
/**
 * Main entry point for the application.
 */

function main(): void {
    console.log('Hello from TypeScript!');
}

main();
EOF
    
    # src/types.ts
    cat > src/types.ts << 'EOF'
/**
 * Type definitions for the application.
 */

export interface Config {
    debug: boolean;
    version: string;
}
EOF
    
    echo -e "${GREEN}✓ TypeScript 5.3 (Strict mode) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# JAVASCRIPT
# ═══════════════════════════════════════════════════════════════════════════════

create_javascript_structure() {
    local project_name="$1"
    
    mkdir -p src
    
    # package.json
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "A JavaScript project",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "node --watch src/index.js",
    "test": "jest"
  },
  "keywords": [],
  "author": "",
  "license": "MIT"
}
EOF
    
    # src/index.js
    cat > src/index.js << 'EOF'
/**
 * Main entry point for the application.
 */

function main() {
    console.log('Hello from JavaScript!');
}

main();
EOF
    
    # src/utils.js
    cat > src/utils.js << 'EOF'
/**
 * Utility functions.
 */

module.exports = {
    // Add your utility functions here
};
EOF
    
    echo -e "${GREEN}✓ JavaScript (Node.js) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# C++
# ═══════════════════════════════════════════════════════════════════════════════

create_cpp_structure() {
    local project_name="$1"
    
    mkdir -p src include build
    
    # include/app.hpp
    cat > include/app.hpp << 'EOF'
#ifndef APP_HPP
#define APP_HPP

#include <iostream>
#include <string>

class App {
public:
    static void printMessage(const std::string& msg);
};

#endif // APP_HPP
EOF
    
    # src/main.cpp
    cat > src/main.cpp << 'EOF'
#include "app.hpp"

int main(int argc, char* argv[]) {
    App::printMessage("Hello from C++!");
    return 0;
}
EOF
    
    # src/app.cpp
    cat > src/app.cpp << 'EOF'
#include "app.hpp"

void App::printMessage(const std::string& msg) {
    std::cout << msg << std::endl;
}
EOF
    
    # CMakeLists.txt
    cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.15)

project(AppName VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include directory
include_directories(include)

# Create executable
add_executable(app 
    src/main.cpp
    src/app.cpp
)
EOF
    
    echo -e "${GREEN}✓ C++ 17 (CMake) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# C
# ═══════════════════════════════════════════════════════════════════════════════

create_c_structure() {
    local project_name="$1"
    
    mkdir -p src include build
    
    # include/app.h
    cat > include/app.h << 'EOF'
#ifndef APP_H
#define APP_H

void print_message(const char *msg);

#endif // APP_H
EOF
    
    # src/main.c
    cat > src/main.c << 'EOF'
#include <stdio.h>
#include "app.h"

int main(void) {
    print_message("Hello from C!");
    return 0;
}
EOF
    
    # src/app.c
    cat > src/app.c << 'EOF'
#include <stdio.h>
#include "app.h"

void print_message(const char *msg) {
    printf("%s\n", msg);
}
EOF
    
    # Makefile
    cat > Makefile << 'EOF'
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Iinclude
TARGET = build/app
SOURCES = $(wildcard src/*.c)
OBJECTS = $(patsubst src/%.c,build/%.o,$(SOURCES))

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p build
	$(CC) $(CFLAGS) -o $@ $^

build/%.o: src/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build/

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
EOF
    
    echo -e "${GREEN}✓ C 11 (Makefile) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# RUST
# ═══════════════════════════════════════════════════════════════════════════════

create_rust_structure() {
    local project_name="$1"
    
    mkdir -p src tests
    
    # Cargo.toml
    cat > Cargo.toml << EOF
[package]
name = "$project_name"
version = "0.1.0"
edition = "2021"

[dependencies]

[dev-dependencies]
EOF
    
    # src/main.rs
    cat > src/main.rs << 'EOF'
fn main() {
    println!("Hello from Rust!");
}
EOF
    
    # src/lib.rs
    cat > src/lib.rs << 'EOF'
/// Library code goes here
pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 2), 4);
    }
}
EOF
    
    # tests/integration_test.rs
    cat > tests/integration_test.rs << 'EOF'
#[test]
fn integration_test() {
    assert_eq!(true, true);
}
EOF
    
    echo -e "${GREEN}✓ Rust 2021 Edition struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# GO
# ═══════════════════════════════════════════════════════════════════════════════

create_go_structure() {
    local project_name="$1"
    
    mkdir -p cmd/main pkg/utils
    
    # go.mod
    cat > go.mod << EOF
module github.com/username/$project_name

go 1.21
EOF
    
    # cmd/main/main.go
    cat > cmd/main/main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello from Go!")
}
EOF
    
    # pkg/utils/utils.go
    cat > pkg/utils/utils.go << 'EOF'
package utils

// Add your utility functions here
EOF
    
    echo -e "${GREEN}✓ Go 1.21 (Module system) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# JAVA (Maven)
# ═══════════════════════════════════════════════════════════════════════════════

create_java_structure() {
    local project_name="$1"
    
    mkdir -p src/main/java/com/example src/test/java/com/example
    
    # pom.xml
    cat > pom.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>$project_name</artifactId>
    <version>1.0.0</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF
    
    # src/main/java/com/example/App.java
    cat > src/main/java/com/example/App.java << 'EOF'
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
    }
}
EOF
    
    # src/test/java/com/example/AppTest.java
    cat > src/test/java/com/example/AppTest.java << 'EOF'
package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

public class AppTest {
    @Test
    public void testPlaceholder() {
        assertTrue(true);
    }
}
EOF
    
    echo -e "${GREEN}✓ Java 17 (Maven) struktur erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# DYNAMIC README GENERATOR
# ═══════════════════════════════════════════════════════════════════════════════

create_readme_python() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- Python 3.9+
- pip (Python Package Manager)

### Installation

1. **Virtual Environment erstellen**:

```bash
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows
```

2. **Abhängigkeiten installieren**:

```bash
pip install -r requirements.txt
```

### Ausführung

```bash
python src/main.py
```

### Testing

```bash
pytest tests/
```

### Build & Distribution

```bash
pip install build
python -m build
```
EOF
}

create_readme_typescript() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- Node.js 18+ LTS
- npm (Node Package Manager)

### Installation

```bash
npm install
```

### Kompilierung

```bash
npm run build
```

### Ausführung

```bash
npm start
```

### Development Mode (mit TypeScript Überwachung)

```bash
npm run dev
```

### Testing

```bash
npm test
```
EOF
}

create_readme_javascript() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- Node.js 18+ LTS
- npm (Node Package Manager)

### Installation

```bash
npm install
```

### Ausführung

```bash
npm start
```

### Development Mode (Watch-Mode)

```bash
npm run dev
```

### Testing

```bash
npm test
```
EOF
}

create_readme_cpp() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- CMake 3.15+
- C++ Compiler (GCC, Clang, or MSVC)
- Make oder Ninja (Build-Tool)

#### macOS
```bash
xcode-select --install
brew install cmake
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install build-essential cmake
```

#### Windows
- Visual Studio Community oder MinGW installieren
- CMake von cmake.org herunterladen

### Kompilierung

```bash
mkdir -p build
cd build
cmake ..
cmake --build .
```

### Ausführung

```bash
./app              # macOS/Linux
build\Debug\app    # Windows
```

### Clean Build

```bash
rm -rf build/
```
EOF
}

create_readme_c() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- GCC oder Clang
- Make

#### macOS
```bash
xcode-select --install
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install build-essential
```

#### Windows
MinGW oder Clang installieren

### Kompilierung

```bash
make
```

### Ausführung

```bash
./build/app
```

### Clean

```bash
make clean
```
EOF
}

create_readme_rust() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- Rust Toolchain (rustc, cargo)

### Installation

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Ausführung (Debug)

```bash
cargo run
```

### Kompilierung (Release/Optimiert)

```bash
cargo build --release
```

Binary-Pfad: `target/release/<project_name>`

### Testing

```bash
cargo test
```

### Dokumentation generieren

```bash
cargo doc --open
```
EOF
}

create_readme_go() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- Go 1.21+

### Installation

https://golang.org/doc/install

### Ausführung

```bash
go run ./cmd/main
```

### Kompilierung

```bash
go build -o bin/app ./cmd/main
./bin/app
```

### Testing

```bash
go test ./...
```

### Code Formatting & Linting

```bash
go fmt ./...
go vet ./...
```
EOF
}

create_readme_java() {
    cat >> README.md << 'EOF'

## Installation & Setup

### Voraussetzungen

- JDK 17+
- Maven 3.8+

### macOS
```bash
brew install openjdk@17 maven
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install openjdk-17-jdk maven
```

### Windows
- JDK von oracle.com oder adoptopenjdk.net
- Maven von maven.apache.org

### Kompilierung & Packaging

```bash
mvn clean package
```

### Ausführung

```bash
java -cp target/classes com.example.App
```

### Testing

```bash
mvn test
```

### Clean

```bash
mvn clean
```
EOF
}

create_universal_readme() {
    local project_name="$1"
    local language="$2"
    
    cat > README.md << EOF
# $project_name

A $language project generated by [newrepo](https://github.com/username/newrepo).

## Description

Add a meaningful description of your project here.

## Quick Start

### Prerequisites

See the language-specific setup section below.

## Project Structure

\`\`\`
$project_name/
├── README.md
├── .gitignore
└── [language-specific files]
\`\`\`
EOF

    case "$language" in
        "Python")          create_readme_python ;;
        "TypeScript")      create_readme_typescript ;;
        "JavaScript")      create_readme_javascript ;;
        "C++")             create_readme_cpp ;;
        "C")               create_readme_c ;;
        "Rust")            create_readme_rust ;;
        "Go")              create_readme_go ;;
        "Java")            create_readme_java ;;
    esac
    
    echo -e "${GREEN}✓ Dynamisches README.md mit Kompilierungsanleitung erstellt${NC}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# TUI MENUS
# ═══════════════════════════════════════════════════════════════════════════════

show_welcome() {
    clear
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║${NC}                                                          ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}║${NC}  ${MAGENTA}✨ Advanced Polyglot Repository Creator ✨${CYAN}        ║${NC}"
    echo -e "${BOLD}${CYAN}║${NC}                                                          ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_language_menu() {
    clear
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN} Select Programming Language${NC}"
    echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e " ${GREEN}1${NC} - ${BOLD}Python${NC} (3.9+, pyproject.toml)"
    echo -e " ${GREEN}2${NC} - ${BOLD}TypeScript${NC} (5.3+, Strict mode)"
    echo -e " ${GREEN}3${NC} - ${BOLD}JavaScript${NC} (Node.js)"
    echo -e " ${GREEN}4${NC} - ${BOLD}C${NC} (C11, Makefile)"
    echo -e " ${GREEN}5${NC} - ${BOLD}C++${NC} (C++17, CMake)"
    echo -e " ${GREEN}6${NC} - ${BOLD}Rust${NC} (2021 Edition)"
    echo -e " ${GREEN}7${NC} - ${BOLD}Go${NC} (1.21+)"
    echo -e " ${GREEN}8${NC} - ${BOLD}Java${NC} (17, Maven)"
    echo -e " ${GREEN}0${NC} - ${BOLD}Minimal${NC} (no language)"
    echo ""
    echo -n -e "${YELLOW}Select option (0-8):${NC} "
}

show_summary() {
    local repo_name="$1"
    local repo_path="$2"
    local language="$3"
    
    clear
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║${NC}                                                          ${BOLD}${GREEN}║${NC}"
    echo -e "${BOLD}${GREEN}║${NC}        ${GREEN}✓ Repository successfully created!${CYAN}       ║${NC}"
    echo -e "${BOLD}${GREEN}║${NC}                                                          ${BOLD}${GREEN}║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}Repository Details:${NC}"
    echo -e " ${CYAN}Name:${NC}     $repo_name"
    echo -e " ${CYAN}Path:${NC}     $repo_path"
    echo -e " ${CYAN}Language:${NC} $language"
    echo -e " ${CYAN}Branch:${NC}   main"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo -e " ${GREEN}cd${NC} \"$repo_path\""
    echo -e " ${GREEN}git${NC} status"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN SCRIPT
# ═══════════════════════════════════════════════════════════════════════════════

main() {
    show_welcome
    
    # Get repository name
    local repo_name="${1:-$DEFAULT_REPO_NAME}"
    echo -n -e "${BOLD}Repository name${NC} (default: $DEFAULT_REPO_NAME): "
    read user_input
    [ -n "$user_input" ] && repo_name="$user_input"
    
    # Generate timestamp and path
    local timestamp=$(date +"%Y%m%d-%H%M%S")
    local repo_dir="$GIT_FOLDER/Repo${timestamp}-${repo_name}"
    
    # Create directory and cd
    if ! mkdir -p "$repo_dir"; then
        echo -e "${RED}✗ Error creating directory${NC}"
        exit 1
    fi
    
    cd "$repo_dir" || exit 1
    
    # Initialize git
    if ! git init > /dev/null 2>&1; then
        echo -e "${RED}✗ Error initializing git${NC}"
        exit 1
    fi
    
    git config user.name "$(git config --global user.name)" 2>/dev/null || git config user.name "Developer"
    git config user.email "$(git config --global user.email)" 2>/dev/null || git config user.email "dev@example.com"
    git symbolic-ref HEAD refs/heads/main 2>/dev/null || true
    
    echo -e "${GREEN}✓ Git repository initialized (branch: main)${NC}"
    
    # Language selection
    show_language_menu
    read language_choice
    
    local language_name="Minimal"
    
    case $language_choice in
        1) language_name="Python"; create_python_structure "$repo_name" ;;
        2) language_name="TypeScript"; create_typescript_structure "$repo_name" ;;
        3) language_name="JavaScript"; create_javascript_structure "$repo_name" ;;
        4) language_name="C"; create_c_structure "$repo_name" ;;
        5) language_name="C++"; create_cpp_structure "$repo_name" ;;
        6) language_name="Rust"; create_rust_structure "$repo_name" ;;
        7) language_name="Go"; create_go_structure "$repo_name" ;;
        8) language_name="Java"; create_java_structure "$repo_name" ;;
        0) language_name="Minimal" ;;
        *) echo -e "${RED}✗ Invalid option${NC}"; exit 1 ;;
    esac
    
    # Create gitignore
    create_universal_gitignore
    
    # Create README
    create_universal_readme "$repo_name" "$language_name"
    
    # Initial commit
    git add . 2>/dev/null
    git commit -m "Initial commit: $language_name project scaffold" > /dev/null 2>&1
    echo -e "${GREEN}✓ Initial commit created${NC}"
    
    # Show summary
    show_summary "$repo_name" "$repo_dir" "$language_name"
}

# ═══════════════════════════════════════════════════════════════════════════════
# RUN MAIN
# ═══════════════════════════════════════════════════════════════════════════════

main "$@"
