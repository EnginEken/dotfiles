#!/bin/zsh

remote=$(git remote get-url origin 2>/dev/null) || {
  echo "Error: not a git repository or no 'origin' remote found."
  exit 1
}

case "$remote" in
  git@github.com:*)
    repo_path="${remote#git@github.com:}"
    ;;
  https://github.com/*)
    repo_path="${remote#https://github.com/}"
    ;;
  ssh://git@github.com/*)
    repo_path="${remote#ssh://git@github.com/}"
    ;;
  git://github.com/*)
    repo_path="${remote#git://github.com/}"
    ;;
  *)
    echo "Error: origin is not a GitHub remote: $remote"
    exit 1
    ;;
esac

repo_path="${repo_path%.git}"

branch=$(git symbolic-ref -q --short HEAD)
if [[ -z "$branch" ]]; then
  echo "Error: cannot determine the current branch."
  exit 1
fi

if [[ "$branch" == "main" ]]; then
  echo "Error: current branch is already 'main'."
  exit 1
fi

if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  echo "Warning: '$branch' is not on origin yet. Push first: git push -u origin $branch"
fi

pr_url="https://github.com/${repo_path}/compare/main...${branch}?expand=1"

case "$OSTYPE" in
  darwin*)
    open -a Arc "$pr_url" || open "$pr_url"
    ;;
  linux*)
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "$pr_url" >/dev/null 2>&1 &
    else
      /usr/bin/google-chrome "$pr_url"
    fi
    ;;
  *)
    echo "Unsupported operating system: $OSTYPE"
    exit 1
    ;;
esac
