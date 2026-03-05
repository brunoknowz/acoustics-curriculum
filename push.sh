#!/bin/bash
# ─────────────────────────────────────────────
# Acoustics Curriculum — GitHub Push Script
# Run this from Terminal: bash push.sh
# ─────────────────────────────────────────────

REPO="brunoknowz/acoustics-curriculum"
FOLDER="$(cd "$(dirname "$0")" && pwd)"
TOKEN_FILE="$FOLDER/.github_token"

# Read token
if [ ! -f "$TOKEN_FILE" ]; then
  echo "❌ Token file not found at $TOKEN_FILE"
  exit 1
fi
TOKEN=$(cat "$TOKEN_FILE" | tr -d '[:space:]')

echo "📁 Working in: $FOLDER"
echo "🔗 Repo: $REPO"

# Init git if needed
cd "$FOLDER"
if [ ! -d ".git" ]; then
  echo "🔧 Initialising git repo..."
  git init
  git remote add origin "https://x-access-token:${TOKEN}@github.com/${REPO}.git"
else
  # Make sure remote uses current token
  git remote set-url origin "https://x-access-token:${TOKEN}@github.com/${REPO}.git"
fi

# Configure git identity (required for commits)
git config user.email "bruno@brunovincent.co.uk"
git config user.name "Bruno Vincent"

# Add only the curriculum files (not the token!)
git add index.html
git add -f push.sh 2>/dev/null

# Commit
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
git commit -m "Curriculum update: $TIMESTAMP" 2>/dev/null || echo "ℹ️  Nothing new to commit"

# Push
echo "🚀 Pushing to GitHub..."
git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null || {
  # First push — set up branch
  git checkout -b main 2>/dev/null
  git push -u origin main
}

echo ""
echo "✅ Done! Your curriculum is live at:"
echo "   https://brunoknowz.github.io/acoustics-curriculum"
