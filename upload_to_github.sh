#!/usr/bin/env bash

cd "$HOME/Scripts" || exit 1
git add -A

if git diff --cached --quiet; then
	echo "No changes to commit."
	exit 0
fi

commit_msg="Update: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_msg"

git push origin main

echo " Changes pushed to GitHub at $commit_msg"
