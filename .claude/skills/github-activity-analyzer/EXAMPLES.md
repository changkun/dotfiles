# GitHub Activity Analyzer - Usage Examples

## Command Line Script Examples

```bash
SCRIPT="./scripts/fetch-github-activity.sh"

# Relative time (days back from today)
$SCRIPT              # Last 14 days (default)
$SCRIPT 7            # Last week
$SCRIPT 30           # Last month
$SCRIPT 90           # Last 3 months
$SCRIPT 365          # Last year

# Full year analysis
$SCRIPT 2025         # All of 2025 (Jan 1 - Dec 31)
$SCRIPT 2024         # All of 2024
$SCRIPT 2023         # All of 2023

# Specific date ranges
$SCRIPT 2024-10-01 2024-12-31    # Oct-Dec 2024 (Q4)
$SCRIPT 2024-01-01 2024-03-31    # Jan-Mar 2024 (Q1)
$SCRIPT 2024-06-01 2024-08-31    # Jun-Aug 2024 (Summer)

# From specific date to today
$SCRIPT 2024-10-01   # Everything from Oct 1, 2024 to today
$SCRIPT 2024-01-01   # Everything from start of 2024 to today
```

## Slash Command Examples

```
# Default (2 weeks)
/github-activity

# Relative time
/github-activity last week
/github-activity 30 days
/github-activity last 6 months
/github-activity last year

# Full years
/github-activity 2025
/github-activity year 2024
/github-activity all of 2023

# Specific ranges
/github-activity 2024-10-01 to 2024-12-31
/github-activity October to December 2024
/github-activity Q4 2024
/github-activity Q1 2025

# Month-specific
/github-activity October 2024
/github-activity January 2025

# From date to today
/github-activity since 2024-10-01
/github-activity from October 2024
/github-activity since January 1st 2024
```

## Natural Language Examples

Ask Claude these questions naturally:

**Recent activity:**
- "What have I been working on?"
- "Show me my recent work"
- "What did I do this week?"
- "Review my contributions from the last 30 days"

**Full year analysis:**
- "What did I work on in 2024?"
- "Analyze my 2025 contributions"
- "Show me everything I did in 2023"
- "Give me a year-end review for 2024"

**Quarterly analysis:**
- "What did I do in Q4 2024?"
- "Review my Q1 2025 work"
- "Show me October through December 2024"

**Specific date ranges:**
- "Analyze my work from 2024-10-01 to 2024-12-31"
- "What did I contribute between October and December 2024?"
- "Review my activity from last summer"

**From date to today:**
- "What have I done since October 2024?"
- "Show me everything since 2024-10-01"
- "Analyze my work from the start of 2025"

**Long periods:**
- "What did I work on in the last year?"
- "Show me my contributions over the past 6 months"
- "Review everything from the last 180 days"

## Time Period Formats Supported

| Format | Example | Interpretation |
|--------|---------|----------------|
| Days | `30`, `90`, `365` | N days back from today |
| Year | `2025`, `2024` | Full calendar year (Jan 1 - Dec 31) |
| Date range | `2024-10-01 2024-12-31` | Specific start and end dates |
| Single date | `2024-10-01` | From that date to today |
| Natural language | "last week", "Q4 2024" | Parsed intelligently |

## API Behavior by Time Period

| Period | Data Source | Detail Level |
|--------|-------------|--------------|
| 0-90 days | Events API | Full detail (all PRs, commits, reviews) |
| 91-180 days | Search API + Events | Major contributions + highlights |
| 181-365 days | Search + Commits APIs | Key milestones + statistics |
| Full year | Multiple APIs | Quarterly themes + major impact |
| Multiple years | Aggregated data | Annual summaries + key metrics |

## Common Use Cases

### Weekly Standup
```bash
/github-activity last week
```

### Sprint Review (2 weeks)
```bash
/github-activity
```

### Monthly Report
```bash
/github-activity last month
```

### Quarterly Review
```bash
/github-activity Q4 2024
```

### Annual Performance Review
```bash
/github-activity 2024
```

### Project Retrospective (specific dates)
```bash
/github-activity 2024-08-01 to 2024-11-30
```

### Year-to-Date Analysis
```bash
/github-activity since 2025-01-01
```
