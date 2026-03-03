---
name: github-activity-analyzer
description: Comprehensive GitHub contribution analysis for any time period. Use when user asks about recent work, wants to review their contributions, needs a status update, or requests activity summary. Supports flexible formats: relative time (days/weeks/months/years), full years (2025), specific date ranges (2024-10-01 to 2024-12-31), and from-date-to-today. Provides detailed insights into PRs, commits, code reviews, and technical themes.
---

# GitHub Activity Analyzer Skill

Analyzes comprehensive GitHub activity for any specified time period with deep technical insights. Supports arbitrary time frames from days to full years.

## When to Use This Skill

Use this skill when the user:
- Asks "what have I been working on?"
- Requests a summary of recent contributions (any time period)
- Wants to review their GitHub activity
- Needs to prepare a status update or report
- Says "show me my recent work" or "what did I do last week/month/year"
- Asks about contribution statistics for a specific period
- Wants insights into their coding patterns over time
- Requests activity analysis with various time formats:
  - Relative: "last 7 days", "past month", "last year"
  - Full years: "2025", "year 2024", "all of 2023"
  - Date ranges: "2024-10-01 to 2024-12-31", "Q4 2024", "October 2024"
  - From date: "since 2024-10-01", "from October"

## Capabilities

1. **Event Analysis**: Fetches and categorizes all GitHub events (pushes, PRs, reviews, comments, releases)
2. **Content Deep Dive**: Extracts PR titles, descriptions, commit messages, and review comments
3. **Theme Identification**: Groups contributions by technical domain (e.g., performance, infrastructure, features)
4. **Impact Assessment**: Highlights most significant contributions and their business value
5. **Statistics**: Provides counts and trends across repositories

## How It Works

### Time Period Parsing
Extract and parse time period from user's request in multiple formats:

**A. Relative time (days back from today):**
- "last week", "7 days", "1w" → 7 days
- "last 2 weeks", "14 days", "2w" → 14 days (default if not specified)
- "last month", "30 days", "1m" → 30 days
- "last 6 months" → 180 days
- "last year", "365 days", "1y" → 365 days
- Custom: "45 days" → 45 days

**B. Full year:**
- "2025", "year 2025", "all of 2024" → Date range: YYYY-01-01 to YYYY-12-31
- Parse the year and set as full calendar year

**C. Specific date range:**
- "2024-10-01 to 2024-12-31" → Exact date range
- "from October 1st to December 31st 2024" → Parse natural language to YYYY-MM-DD
- "Q4 2024" → 2024-10-01 to 2024-12-31
- "October 2024" → 2024-10-01 to 2024-10-31
- "Q1 2025" → 2025-01-01 to 2025-03-31

**D. From date to today:**
- "since 2024-10-01" → From that date to today
- "from October 2024" → From 2024-10-01 to today

Default to 14 days (2 weeks) if no time period mentioned

### Data Collection
- Uses `gh api users/{username}/events` to fetch activity
- For relative time: Dynamically calculates date N days ago from today
- For date ranges: Uses the parsed start and end dates directly
- Filters events within the date range (inclusive)
- Fetches detailed PR information for opened/merged PRs
- Retrieves commit messages from most active repositories
- Samples code review comments to understand review style

**Important Note**: GitHub's events API only returns the last 90 days of events. For time periods beyond 90 days:
- Use GitHub Search API for issues and PRs: `gh api search/issues`
- Query specific repository commits: `gh api repos/{owner}/{repo}/commits`
- Fetch data from multiple endpoints and aggregate
- Focus on major contributions and highlights for longer periods

### Analysis
- Groups work by repository and technical theme
- Identifies patterns (e.g., VAT integration, performance optimization)
- Extracts technical details (formulas, benchmarks, metrics)
- Summarizes code review leadership

### Output Format
- Executive summary
- Activity breakdown by theme
- Technical highlights with specifics
- Statistics table
- Impact assessment

## Technical Requirements

- GitHub CLI (`gh`) must be installed and authenticated
- Access to user's GitHub events via API
- Ability to fetch PR and commit details from repositories

## Implementation Guidelines

- **Time Period Handling**:
  - Always parse the user's requested time period from natural language
  - Support all formats: relative days, full years, specific ranges, from-date-to-today
  - Default to 14 days (2 weeks) if no period specified
  - Calculate dates dynamically from today's date for relative periods
  - Be flexible: "last week", "7 days", "1w" should all work the same
  - Convert natural language dates: "October 2024" → "2024-10-01 to 2024-10-31"
  - Handle quarters: "Q1 2025" → "2025-01-01 to 2025-03-31"
  - For periods >90 days, acknowledge API limitations and use alternative approaches

- **API Strategy for Different Time Periods**:
  - **0-90 days**: Use events API directly (`gh api users/{username}/events`)
  - **>90 days or specific old dates**: Combine multiple approaches:
    - Search API: `gh api search/issues?q=author:{username}+created:>=YYYY-MM-DD`
    - Search API for PRs: `gh api search/issues?q=is:pr+author:{username}+created:>=YYYY-MM-DD`
    - Repo commits: Identify active repos and query commits
    - Focus on major milestones and highlights

- **Content Adaptation by Period Length**:
  - **<30 days**: Full detailed analysis with all PRs, commits, reviews
  - **30-90 days**: Detailed with slight summarization of minor items
  - **3-6 months**: Focus on major contributions, monthly themes
  - **Full year**: Quarterly breakdown, key highlights, statistics, major impact

- **Technical Details**:
  - Include ticket numbers (e.g., RMC-XXX, YIELD-XXXX) when present in commits/PRs
  - Provide specific technical details with formulas, benchmarks, and metrics - not generic summaries
  - Balance breadth (number of repos) with depth (technical implementation details)
  - Preserve context like performance gains, schema changes, integration specifics

- **Performance**:
  - Use parallel API calls where possible for better performance
  - For very long periods, paginate and aggregate strategically
  - Cache intermediate results if processing multiple endpoints
