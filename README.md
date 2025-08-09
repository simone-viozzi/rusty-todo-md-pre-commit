# rusty-todo-md-pre-commit

[![Actions status](https://github.com/simone-viozzi/rusty-todo-md-pre-commit/actions/workflows/main.yaml/badge.svg)](https://github.com/simone-viozzi/rusty-todo-md-pre-commit/actions)
[![PyPI - Version](https://img.shields.io/pypi/v/rusty-todo-md.svg)](https://pypi.org/project/rusty-todo-md/)
[![PyPI - Python Version](https://img.shields.io/pypi/pyversions/rusty-todo-md.svg)](https://pypi.org/project/rusty-todo-md/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A [pre-commit](https://pre-commit.com/) hook shim for [Rusty TODO MD](https://github.com/simone-viozzi/rusty-todo-md),  
installing **prebuilt wheels from PyPI** so you can use it **without a Rust toolchain**.

---


## 🚀 Quick start

Add this to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/simone-viozzi/rusty-todo-md-pre-commit
    rev: v1.7.5 
    hooks:
      - id: rusty-todo-md
```

Then install the hook:

```sh
pre-commit install
```

Now `rusty-todo-md` will run on staged files at commit time.  
For CLI usage, configuration options, and advanced examples, see the **[main Rusty TODO MD repository](https://github.com/simone-viozzi/rusty-todo-md)**.

---

## 📦 Requirements

- **Python** ≥ 3.10
- **No Rust toolchain** required if a prebuilt wheel exists for your platform

---

## 🖥️ Supported platforms (prebuilt wheels)

Rusty TODO MD publishes wheels for:

| OS / libc             | Architectures                                  |
| --------------------- | ---------------------------------------------- |
| **Linux (manylinux)** | `x86_64`, `x86`, `aarch64`, `armv7`, `ppc64le` |
| **Linux (musllinux)** | `x86_64`, `x86`, `aarch64`, `armv7`            |
| **Windows**           | `x64`, `x86`                                   |
| **macOS**             | `x86_64` (macOS 13), `aarch64` (macOS 14)      |

> ✅ Platform coverage may evolve — check [upstream releases](https://github.com/simone-viozzi/rusty-todo-md/releases) for the latest wheel list.

---

## 📌 Why this repo exists

When `pre-commit` runs a hook from a Git repository, it **clones** the repo and runs:

```sh
pip install .
```

This triggers a **source install** of Rusty TODO MD, which would require a Rust toolchain to build from source.

This **shim repository** solves that:  
it lists `rusty-todo-md` as a PyPI dependency in its `pyproject.toml`, so `pre-commit` will fetch **prebuilt wheels** from PyPI for your platform — no compilation needed.

Tags in this repository **match upstream tags exactly** and are kept in sync via CI.

---

## 📚 More info

- **Main project** (features, CLI docs, configuration): [github.com/simone-viozzi/rusty-todo-md](https://github.com/simone-viozzi/rusty-todo-md)
- **PyPI package**: [pypi.org/project/rusty-todo-md](https://pypi.org/project/rusty-todo-md)

---

## ⚖️ License

This project is licensed under the [MIT License](LICENSE).

