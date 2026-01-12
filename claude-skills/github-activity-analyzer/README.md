# GitHub Activity Analyzer - Claude Code Skill

A comprehensive Claude Code skill that analyzes your GitHub contributions for any arbitrary time period with detailed technical insights. Supports relative time (days/weeks/months), full years (2025), specific date ranges (Oct-Dec 2024), and custom periods. Perfect for status updates, performance reviews, or understanding your coding patterns across any timeframe.

## 🌟 Features

- **Arbitrary Time Periods**: Analyze any timeframe you want:
  - Relative: "last week", "30 days", "6 months", "last year"
  - Full years: "2025", "year 2024"
  - Specific ranges: "2024-10-01 to 2024-12-31", "Q4 2024"
  - From date: "since 2024-10-01", "from October"
- **Smart Analysis**: Fetches all GitHub events (commits, PRs, code reviews, releases)
- **API-Aware**: Automatically handles GitHub API limitations for periods >90 days
- **Theme Grouping**: Automatically categorizes work by technical domain
- **Deep Insights**: Extracts PR descriptions, commit messages, and review comments
- **Impact Assessment**: Highlights most significant contributions
- **Statistics**: Provides detailed metrics across repositories
- **Multiple Access Methods**: Use via slash command, natural language, or standalone script

## 📦 Installation

### Option 1: Install into your project (Recommended)

```bash
cd /path/to/your/project
mkdir -p .claude/skills
cd .claude/skills
git clone <this-repo-url> github-activity-analyzer
```

### Option 2: Install globally for all projects

```bash
mkdir -p ~/.config/claude-code/skills
cd ~/.config/claude-code/skills
git clone <this-repo-url> github-activity-analyzer
```

### Option 3: Manual installation

1. Create the skills directory:
   ```bash
   mkdir -p .claude/skills/github-activity-analyzer
   ```

2. Copy all files from this repository into the directory

3. Verify the structure:
   ```
   .claude/skills/github-activity-analyzer/
   ├── README.md
   ├── SKILL.md
   ├── commands/
   │   └── github-activity.md
   └── scripts/
       └── fetch-github-activity.sh
   ```

## 🔧 Requirements

- **GitHub CLI** (`gh`) - [Install from github.com/cli/cli](https://github.com/cli/cli)
- GitHub authentication: `gh auth login`
- Bash shell (for scripts)

## 🚀 Usage

### Method 1: Slash Command

Run the command explicitly with flexible time specifications:

```bash
# Default (last 2 weeks)
/github-activity

# Relative time
/github-activity last week
/github-activity 30 days
/github-activity last 6 months
/github-activity last year

# Full year
/github-activity 2025
/github-activity year 2024

# Specific date range
/github-activity 2024-10-01 to 2024-12-31
/github-activity from October 1st to December 31st 2024
/github-activity Q4 2024
/github-activity October 2024

# From date to today
/github-activity since 2024-10-01
/github-activity from October 2024
```

### Method 2: Natural Language (Skill Auto-activation)

Just ask Claude naturally with any time specification:

**Relative time:**
- "What have I been working on?"
- "Show me my GitHub activity from the last week"
- "Summarize my contributions in the past month"
- "What did I do in the last year?"

**Full years:**
- "What did I work on in 2024?"
- "Analyze my 2025 contributions"
- "Show me all of 2023"

**Specific ranges:**
- "Review my work from October to December 2024"
- "What did I do in Q4 2024?"
- "Analyze my contributions from 2024-10-01 to 2024-12-31"

**From date to today:**
- "Show me everything since October 2024"
- "What have I done since 2024-10-01?"

The skill will automatically activate, parse the time period, and provide a comprehensive analysis.

### Method 3: Standalone Script

Run the helper script directly with flexible parameters:

```bash
SCRIPT=".claude/skills/github-activity-analyzer/scripts/fetch-github-activity.sh"

# Default (14 days)
$SCRIPT

# Days back
$SCRIPT 7        # Last week
$SCRIPT 30       # Last month
$SCRIPT 365      # Last year

# Full year
$SCRIPT 2025     # All of 2025
$SCRIPT 2024     # All of 2024

# Specific date range
$SCRIPT 2024-10-01 2024-12-31    # Oct-Dec 2024

# From date to today
$SCRIPT 2024-10-01               # From Oct 1 to today
```

## 📊 Output Example

The analysis includes:

- **Executive Summary**: 2-3 sentence overview
- **Activity by Theme**: Grouped contributions (e.g., "Performance Optimization", "Infrastructure")
- **Technical Highlights**: Specific details with formulas, benchmarks, ticket numbers
- **Code Review Summary**: Review activity and leadership
- **Statistics Table**: Repos, PRs, commits, reviews, releases
- **Impact Assessment**: Most significant contributions

## 🎯 What It Analyzes

- **Commits**: All pushes across repositories
- **Pull Requests**: Opened, merged, and closed PRs with descriptions
- **Code Reviews**: Approved/commented reviews with sample feedback
- **Issues**: Comments and discussions
- **Releases**: Published releases with version tags
- **Repositories**: All repos you've contributed to

## 💡 Use Cases

- **Weekly standups**: Analyze last 7 days for quick updates
- **Bi-weekly sprints**: Review 14 days of contributions
- **Monthly reports**: Comprehensive 30-day analysis
- **Quarterly reviews**: "Q4 2024" for performance reviews
- **Annual reviews**: Full year analysis with "2024" or "year 2024"
- **Project retrospectives**: Specific date ranges for project duration
- **Date-based analysis**: "October 2024" or "since 2024-10-01"
- **Custom periods**: Any arbitrary timeframe (45 days, 6 months, etc.)
- Understanding technical focus areas over any period
- Tracking cross-repository contributions
- Identifying productivity patterns and trends
- Year-over-year comparisons

## ⚙️ Time Period Support

The skill supports extremely flexible time specifications:

### Relative Time (from today)
- **Natural language**: "last week", "past month", "3 months ago", "last year"
- **Explicit days**: "7 days", "30 days", "180 days", "365 days"
- **Short forms**: "1w", "2w", "1m", "6m", "1y"
- **Default**: 14 days (2 weeks) when not specified

### Full Years
- **Year number**: "2025", "2024", "2023"
- **Explicit**: "year 2024", "all of 2025"
- Automatically converts to Jan 1 - Dec 31 of that year

### Specific Date Ranges
- **Exact dates**: "2024-10-01 to 2024-12-31"
- **Natural language**: "from October 1st to December 31st 2024"
- **Quarters**: "Q1 2025" (Jan-Mar), "Q4 2024" (Oct-Dec)
- **Months**: "October 2024" → Oct 1-31, 2024

### From Date to Today
- **Explicit date**: "since 2024-10-01"
- **Month**: "from October 2024"
- Analyzes from that date through today

All time periods are automatically parsed and calculated dynamically.

### Add Custom Analysis

Extend the skill by modifying `SKILL.md` to include:
- Additional event types
- Custom grouping logic
- Specific repository filters
- Team-specific metrics

## 📁 Structure

```
github-activity-analyzer/
├── README.md                     # This file
├── SKILL.md                      # Skill definition (auto-triggers)
├── commands/
│   └── github-activity.md     # Slash command definition
└── scripts/
    └── fetch-github-activity.sh  # Standalone helper script
```

## ⚠️ GitHub API Limitations

**Events API**: GitHub's `/users/{username}/events` endpoint only returns events from the last **90 days**.

**How the skill handles this:**

- **0-90 days**: Uses events API directly for full, detailed data
- **>90 days or old date ranges**: Automatically switches to alternative approaches:
  - GitHub Search API for issues and PRs
  - Direct repository commit queries
  - Aggregated data from multiple endpoints
- **Full years and long periods**: Focuses on major highlights, key statistics, and thematic summaries

**What this means for you:**
- Recent activity (last 3 months): Full detail available
- Older periods (3-12 months): Major contributions and highlights
- Full year reviews: Quarterly themes, key milestones, statistics
- The skill adapts its strategy automatically based on your time period

## 🐛 Troubleshooting

### "gh: command not found"
Install GitHub CLI: `brew install gh` (macOS) or visit [cli.github.com](https://cli.github.com/)

### "unauthorized" errors
Run `gh auth login` to authenticate with GitHub

### No events returned
- Check your GitHub username: `gh api user --jq '.login'`
- Verify you have activity in the specified period
- Ensure your events are public or you're authenticated

### Limited results for periods >90 days
GitHub's events API only returns the last 90 days. For longer periods:
- The skill automatically uses alternative API endpoints (Search API, commits API)
- You may see a note about using aggregated data sources
- Focus shifts to major highlights and statistics for very long periods

### Script date parsing errors
- Ensure dates are in YYYY-MM-DD format
- Verify year values are between 1900-2100
- Check that start date is before end date

## 📝 Notes

- **Commands** are user-triggered (explicit `/command` invocation)
- **Skills** are Claude-triggered (automatic based on conversation context)
- **Scripts** are standalone (can run outside Claude Code)
- All three methods provide similar analysis with different invocation patterns

## 🤝 Contributing

To improve this skill:
1. Fork the repository
2. Make your changes
3. Test with Claude Code
4. Submit a pull request

## 📄 License

[Add your license here]

## 🔗 Links

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [GitHub CLI](https://cli.github.com/)
- [Creating Custom Skills Guide](https://docs.anthropic.com/claude-code/skills)
