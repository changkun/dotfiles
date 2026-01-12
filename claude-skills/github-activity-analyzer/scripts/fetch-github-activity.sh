#!/bin/bash
# GitHub Activity Fetcher
# Fetches and analyzes GitHub activity for the authenticated user
#
# Usage:
#   fetch-github-activity.sh [DAYS]              # Last N days
#   fetch-github-activity.sh [YEAR]              # Full year (e.g., 2025)
#   fetch-github-activity.sh [START_DATE]        # From date to today
#   fetch-github-activity.sh [START_DATE] [END_DATE]  # Specific range
#
# Examples:
#   fetch-github-activity.sh                     # Last 14 days (default)
#   fetch-github-activity.sh 7                   # Last 7 days
#   fetch-github-activity.sh 365                 # Last year
#   fetch-github-activity.sh 2025                # Full year 2025
#   fetch-github-activity.sh 2024-10-01          # From Oct 1, 2024 to today
#   fetch-github-activity.sh 2024-10-01 2024-12-31  # Oct-Dec 2024

set -euo pipefail

# Function to validate date format (YYYY-MM-DD)
is_valid_date() {
    [[ "$1" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
}

# Function to check if argument is a 4-digit year
is_year() {
    [[ "$1" =~ ^[0-9]{4}$ ]] && [ "$1" -ge 1900 ] && [ "$1" -le 2100 ]
}

# Default values
SINCE_DATE=""
UNTIL_DATE=""
MODE=""

# Parse arguments
if [ $# -eq 0 ]; then
    # Default: last 14 days
    MODE="days"
    DAYS=14
elif [ $# -eq 1 ]; then
    if is_valid_date "$1"; then
        # Single date: from that date to today
        MODE="date_range"
        SINCE_DATE="$1"
        UNTIL_DATE=$(date -u +"%Y-%m-%d")
    elif is_year "$1"; then
        # Year: full year (Jan 1 to Dec 31)
        MODE="year"
        SINCE_DATE="${1}-01-01"
        UNTIL_DATE="${1}-12-31"
    elif [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -gt 0 ]; then
        # Number: N days ago
        MODE="days"
        DAYS="$1"
    else
        echo "Error: Invalid argument. Must be a positive number, year (YYYY), or date (YYYY-MM-DD)" >&2
        echo "Usage: $0 [DAYS|YEAR|START_DATE] [END_DATE]" >&2
        exit 1
    fi
elif [ $# -eq 2 ]; then
    # Two dates: specific range
    if is_valid_date "$1" && is_valid_date "$2"; then
        MODE="date_range"
        SINCE_DATE="$1"
        UNTIL_DATE="$2"
    else
        echo "Error: Both arguments must be valid dates (YYYY-MM-DD)" >&2
        exit 1
    fi
else
    echo "Error: Too many arguments" >&2
    echo "Usage: $0 [DAYS|YEAR|START_DATE] [END_DATE]" >&2
    exit 1
fi

# Calculate dates if in "days" mode
if [ "$MODE" = "days" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        SINCE_DATE=$(date -u -v-${DAYS}d +"%Y-%m-%d")
    else
        # Linux
        SINCE_DATE=$(date -u -d "${DAYS} days ago" +"%Y-%m-%d")
    fi
    UNTIL_DATE=$(date -u +"%Y-%m-%d")
fi

# Display what we're fetching
case "$MODE" in
    days)
        echo "Fetching GitHub activity: last $DAYS days ($SINCE_DATE to $UNTIL_DATE)"
        ;;
    year)
        echo "Fetching GitHub activity: full year $(echo $SINCE_DATE | cut -d- -f1)"
        ;;
    date_range)
        echo "Fetching GitHub activity: $SINCE_DATE to $UNTIL_DATE"
        ;;
esac

# Get username
USERNAME=$(gh api user --jq '.login')
echo "Analyzing activity for: $USERNAME"

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# Fetch all events
echo "Fetching events..."
gh api users/$USERNAME/events --paginate > "$TMPDIR/all_events.json"

# Filter events for the specified date range
echo "Filtering events from $SINCE_DATE to $UNTIL_DATE..."
jq "[.[] | select(.created_at >= \"${SINCE_DATE}T00:00:00Z\" and .created_at <= \"${UNTIL_DATE}T23:59:59Z\")]" "$TMPDIR/all_events.json" > "$TMPDIR/recent_events.json"

# Event type summary
echo ""
echo "=== Event Summary ==="
jq -r '.[] | .type' "$TMPDIR/recent_events.json" | sort | uniq -c | sort -rn

# Unique repositories
echo ""
echo "=== Repositories Contributed To ==="
jq -r '.[] | .repo.name' "$TMPDIR/recent_events.json" | sort -u | wc -l | xargs echo "Total repositories:"
jq -r '.[] | .repo.name' "$TMPDIR/recent_events.json" | sort -u

# Push events by repo
echo ""
echo "=== Commits by Repository ==="
jq -r 'select(.type == "PushEvent") | .repo.name' "$TMPDIR/recent_events.json" | sort | uniq -c | sort -rn | head -10

# PRs opened
echo ""
echo "=== PRs Opened ==="
jq -r 'select(.type == "PullRequestEvent") | select(.payload.action == "opened") | "\(.created_at)|\(.repo.name)|PR #\(.payload.pull_request.number)"' "$TMPDIR/recent_events.json" | head -15

# Code reviews
echo ""
echo "=== Code Reviews (Approved) ==="
jq -r 'select(.type == "PullRequestReviewEvent") | select(.payload.review.state == "approved") | .repo.name' "$TMPDIR/recent_events.json" | sort | uniq -c | sort -rn

# Releases
echo ""
echo "=== Releases Published ==="
jq -r 'select(.type == "ReleaseEvent") | "\(.created_at)|\(.repo.name)|\(.payload.release.tag_name)"' "$TMPDIR/recent_events.json"

echo ""
echo "Detailed events saved to: $TMPDIR/recent_events.json"
echo "To view: cat $TMPDIR/recent_events.json | jq ."
