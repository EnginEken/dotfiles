local url
url=$(git remote get-url origin)
url="${url/git@/}"
url="${url/://}"
url="${url%.git}"

local branch
branch=$(git symbolic-ref -q --short HEAD)
if [[ -z "$branch" ]]; then
    echo "Error: Cannot determine the current branch."
    return 1
fi

# Check if the branch was derived from 'dev' or 'development'
local base_branch=""
if git merge-base --is-ancestor dev "$branch" 2>/dev/null; then
    base_branch="dev"
elif git merge-base --is-ancestor development "$branch" 2>/dev/null; then
    base_branch="development"
elif git merge-base --is-ancestor main "$branch" 2>/dev/null; then
    base_branch="main"
else
    base_branch="master"  # Default to master if no dev or development base branch
fi

local assignee_id="150" # ID for user eeken
local mr_url="https://${url}/-/merge_requests/new?merge_request[source_branch]=${branch}&merge_request[target_branch]=${base_branch}&merge_request[assignee_ids][]=${GITLAB_USER_ID}&merge_request[force_remove_source_branch]=1&merge_request[squash]=0"

case "$OSTYPE" in
    darwin*)
    open -a arc "$mr_url"
    ;;
    linux*)
    /usr/bin/google-chrome "$mr_url"
    ;;
    *)
    echo "Unsupported operating system: $OSTYPE"
    return 1
    ;;
esac
