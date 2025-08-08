#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Configuration
###############################################################################
TARGET_REPO="rusty-todo-md"
PYPI_URL="https://pypi.org/pypi/${TARGET_REPO}/json"

FILES_TO_UPDATE=(pyproject.toml README.md)

###############################################################################
# Helpers
###############################################################################

# Fail fast if jq is missing.
command -v jq >/dev/null ||
  {
    echo "❌  jq is required but not found in \$PATH" >&2
    exit 1
  }

# Return **all** upstream versions in ascending semver order (one per line).
get_all_pypi_versions() {
  curl -sSL "${PYPI_URL}" |
    jq -r '.releases | keys[]' |
    sort -V
}

# Return the most recent upstream version.
get_latest_pypi_version() {
  get_all_pypi_versions | tail -n1
}

# Return the newest local Git tag (stripped of its leading “v”).
get_latest_git_tag() {
  git tag --list 'v*' --sort=v:refname | tail -n1 | sed 's/^v//'
}

# Replace the version string inside each file that needs it.
update_files() {
  local version="$1"

  # pyproject.toml - match until the next double-quote
  sed -i -E "s#(\"${TARGET_REPO}==)[^\"]+\"#\1${version}\"#" pyproject.toml
  # README.md       – match until next space OR end-of-line
  sed -i -E "s#(rev: v)[^[:space:]]+#\1${version}#" README.md
}


# Stage modified files, commit, and tag the commit.
commit_and_tag() {
  local version="$1"
  git add "${FILES_TO_UPDATE[@]}"
  git commit -m "Mirror: ${version}"
  git tag "v${version}"
}

###############################################################################
# Main
###############################################################################
main() {
  local latest_local latest_upstream

  latest_local="$(get_latest_git_tag || echo '0.0.0')"

  # Prefer explicit input (PAYLOAD_VERSION) if provided; else PyPI latest
  if [[ -n "${PAYLOAD_VERSION:-}" ]]; then
    # Optional: verify version exists on PyPI
    if ! curl -sSL "${PYPI_URL}" | jq -e --arg v "$PAYLOAD_VERSION" '.releases[$v] | length > 0' >/dev/null; then
      echo "❌ Version '$PAYLOAD_VERSION' not found on PyPI. Aborting."
      exit 1
    fi
    latest_upstream="$PAYLOAD_VERSION"
  else
    latest_upstream="$(get_latest_pypi_version)"
  fi

  # If upstream is newer than local, mirror the latest upstream version
  if [[ "$(printf '%s\n%s\n' "$latest_local" "$latest_upstream" | sort -V | tail -n1)" == "$latest_upstream" && "$latest_upstream" != "$latest_local" ]]; then
    echo "➡️  Mirroring ${latest_upstream}"
    update_files "${latest_upstream}"
    if [[ -n "$(git status --porcelain)" ]]; then
      commit_and_tag "${latest_upstream}"
    else
      echo "ℹ️  No changes needed for ${latest_upstream}"
    fi
  else
    echo "ℹ️  Already up to date (local: ${latest_local}, upstream: ${latest_upstream})"
  fi
}

main "$@"
