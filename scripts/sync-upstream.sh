#!/usr/bin/env sh

set -eu

UPSTREAM_REMOTE="${UPSTREAM_REMOTE:-upstream}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-main}"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Please switch to main before syncing upstream."
  echo "Current branch: $CURRENT_BRANCH"
  exit 1
fi

if ! git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
  echo "Missing remote '$UPSTREAM_REMOTE'."
  echo "Run: git remote add $UPSTREAM_REMOTE https://github.com/openai/plugins.git"
  exit 1
fi

echo "Fetching $UPSTREAM_REMOTE/$UPSTREAM_BRANCH..."
git fetch "$UPSTREAM_REMOTE" "$UPSTREAM_BRANCH"

echo "Merging $UPSTREAM_REMOTE/$UPSTREAM_BRANCH into main..."
git merge --ff-only "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH"

echo
echo "Sync complete."
echo "If you want to publish the synced main to your fork, run:"
echo "git push origin main"
