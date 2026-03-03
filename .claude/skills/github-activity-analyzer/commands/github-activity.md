---
name: github-activity
description: Analyze GitHub contributions with detailed technical insights. Supports arbitrary time periods, full years, and specific date ranges.
---

# GitHub Activity Analyzer

Analyze my GitHub activity and provide a comprehensive summary with technical details.

**Time Period**: The user may specify time in various formats:
- **Relative**: "last week", "last 2 weeks", "last 30 days", "last year", "past 6 months"
- **Full year**: "2025", "year 2024", "all of 2023"
- **Specific date range**: "2024-10-01 to 2024-12-31", "from October 1st to December 31st 2024"
- **From date to today**: "since 2024-10-01", "from October 2024"

If not specified, default to **14 days (2 weeks)**.

## Task

1. **Determine the time period and format**:

   Parse user input and determine which format to use:

   **A. Relative time (days back from today):**
   - "last week", "7 days" → 7 days
   - "2 weeks", "14 days" → 14 days (default)
   - "last month", "30 days" → 30 days
   - "last 3 months", "90 days" → 90 days
   - "last 6 months" → 180 days
   - "last year", "365 days" → 365 days
   - Custom number (e.g., "45 days") → use that number

   **B. Full year:**
   - "2025", "year 2025", "all of 2024" → Set range as YYYY-01-01 to YYYY-12-31

   **C. Specific date range:**
   - "2024-10-01 to 2024-12-31" → Use exact dates
   - "from October 1st to December 31st 2024" → Parse and convert to YYYY-MM-DD format
   - "Q4 2024" → 2024-10-01 to 2024-12-31
   - "October 2024" → 2024-10-01 to 2024-10-31

   **D. From date to today:**
   - "since 2024-10-01" → From that date to today
   - "from October 2024" → From 2024-10-01 to today

   If no time period specified, use 14 days (2 weeks) as default

2. **Get my GitHub username** using `gh api user --jq '.login'`

3. **Fetch all my events** for the specified time period:
   - Use `gh api users/{username}/events --paginate`
   - **For relative time (days)**: Calculate date N days ago from today:
     - macOS: `date -u -v-{N}d +"%Y-%m-%d"`
     - Linux: `date -u -d '{N} days ago' +"%Y-%m-%d"`
   - **For date ranges**: Use the parsed start and end dates directly
   - Filter events for the date range: `created_at >= START_DATE AND created_at <= END_DATE`
   - Save to a temporary file for analysis

   **Note**: GitHub API events are limited to the last 90 days via the events endpoint. For older data:
   - Use `gh api` with search queries: `gh api search/issues`
   - Or fetch specific repo commits: `gh api repos/{owner}/{repo}/commits`
   - Aggregate data from multiple sources as needed

4. **Analyze activity by type**:
   - Count PushEvents (commits)
   - Count PullRequestEvents (opened/closed/merged)
   - Count PullRequestReviewEvents (reviews)
   - Count IssueCommentEvents and PullRequestReviewCommentEvents
   - Count ReleaseEvents
   - Identify unique repositories I contributed to

5. **Get detailed content**:
   - For recent PRs I opened (last 10-15), fetch PR details including:
     - Title and description
     - State (open/merged)
     - Number of commits
   - For top 3-5 most active repositories, get commit messages
   - Sample code review comments to understand review nature

6. **Synthesize insights** organized by:
   - **Key Highlights**: Top 3-5 most important contributions
   - **Major Themes**: Group work by technical domain (e.g., "Price Optimization", "Performance Optimization", "AI/LLM Infrastructure")
   - **Technical Patterns**: What engineering practices/expertise were demonstrated
   - **Code Review Leadership**: Summary of review activity and style
   - **Impact Summary**: What was most impactful

7. **Format the output** as:
   - Executive summary (2-3 sentences)
   - Detailed breakdown by theme with specific PR/commit references
   - Stats table (repos, PRs, reviews, releases)
   - Technical highlights with code/formula examples where relevant

## Notes

- Always calculate dates dynamically from today's date based on the requested period
- Default to 14 days (2 weeks) if no time period is specified
- Be flexible with time period parsing: "last week", "7 days", "1w" should all work
- Support full years: "2025" → analyze Jan 1 to Dec 31, 2025
- Support specific ranges: "2024-10-01 to 2024-12-31" → exact date range
- Use parallel gh API calls where possible for performance
- Include ticket numbers (e.g., RMC-123, YIELD-456) when present in commits/PRs
- Show both breadth (number of repos) and depth (commits/changes per repo)
- Be specific with technical details - include formulas, benchmarks, metrics, not just "made improvements"
- Preserve technical context like performance gains, schema changes, integration details
- For longer periods (>90 days or full years), focus on:
  - Major themes and highlights
  - Most impactful contributions
  - Monthly or quarterly trends
  - Key statistics rather than exhaustive details
- **GitHub API Limitation**: Events endpoint only returns last 90 days. For older data, use alternative approaches:
  - Search API for issues/PRs
  - Direct repo commit queries
  - Aggregation from multiple endpoints

## Example Invocations

**Default (2 weeks):**
```
/github-activity
```

**Relative time:**
```
/github-activity last week
/github-activity 30 days
/github-activity last year
```

**Full year:**
```
/github-activity 2025
/github-activity year 2024
```

**Specific date range:**
```
/github-activity 2024-10-01 to 2024-12-31
/github-activity from October 1st to December 31st 2024
/github-activity Q4 2024
```

**From date to today:**
```
/github-activity since 2024-10-01
/github-activity from October 2024
```

Expected behavior: Comprehensive analysis for the specified time period, automated and reusable.
