# Dotfiles

My personal **macOS** and **Linux** (Ubuntu distribution) system dotfiles and settings.

_Use it at your own risk._

- [macOS](./devices/mac.md)
- [Linux Ubuntu](./devices/ubuntu.md)
- [iPadOS](./devices/ipad.md)
- [iOS](./devices/iphone.md)

## Folder Policy

All code projects are managed in `~/dev`, common folders:

```sh
~/dev/changkun.de
~/dev/golang.design
~/dev/godev # golang.org repositories
~/dev/wild  # code for temporary use
```

Managing multiple go versions:

```sh
~/goes/go       # just an alias to an inused go version
~/goes/go1.17.1 # a specific version
```

## Claude Code

The `claude` folder sets up Claude Code the same way on every machine. From a checkout of this repository, one command installs it:

```sh
sh claude/install.sh
```

On a new machine, the installer can also be piped from GitHub. It first clones this repository into `~/dev/changkun.de/dotfiles`, or into the folder that `DOTFILES` names, and then runs from that checkout:

```sh
curl -fsSL https://raw.githubusercontent.com/changkun/dotfiles/main/claude/install.sh | sh
```

The installer needs `python3`, and the status line also needs `node` 18 or newer. It does three things, and running it a second time changes nothing.

1. It links `claude/hooks/owner-words.py` into `~/.claude/hooks/`, so pulling this repository updates the hook in place. If a different file was already there, the installer keeps it as `owner-words.py.bak`.
2. It merges `claude/settings.json` into `~/.claude/settings.json`. The merge only adds the keys and entries the machine lacks, so a value already set on the machine wins over the one here, and every other setting stays as it was. Before its first change, the installer saves the original file as `settings.json.dotfiles-backup`. The merged settings register the hook, empty the commit and pull request attribution, suppress the session attribution, keep session transcripts for 99,999 days instead of the default 30, and enable my plugins together with the marketplaces they come from. Claude Code adds those marketplaces and downloads the plugins in the background after it starts. Permission rules and auto mode rules stay out of this repository, because they name paths and services on one machine.
3. It installs the [ccstatus](https://github.com/changkun/ccstatus) status line by running the installer from that repository, unless ccstatus is installed already. Running the ccstatus installer again updates it, and setting `CCSTATUS_SRC=~/dev/changkun.de/ccstatus` installs it from a local checkout instead of from GitHub.

Like Claude Code and ccstatus, the installer honours `CLAUDE_CONFIG_DIR` and `CCSTATUS_HOME` when they are set.

### The owner-words hook

Claude Code runs the hook before it writes or edits a file, briefs an agent, messages another agent, or runs a command that publishes text, such as `git commit`, `git tag`, `gh pr create` or `gh api`. The hook refuses the call in two cases. The first is when the outgoing text repeats a run of five or more words, in order, from a message I typed in the same project. The second is when the text adds a sentence that reports what I asked for or said instead of describing the change. The second check skips the memory folder, where such notes belong. Claude sees the phrases the hook refused and writes them again in its own words. Text that a file already contained before the edit always passes, so older documents can still be edited.

The hook reads my messages from the transcripts of the current project in `~/.claude/projects`, and it ignores pasted blocks, tool output, system text and the transcripts of subagents. It keeps the messages in `~/.claude/hooks/owner-words.cache.json`, which only my user can read, and on each call it reads just the part of a transcript that is new. That cache holds my own words, so `.gitignore` keeps it out of this repository.

To check files that already exist, `python3 ~/.claude/hooks/owner-words.py --scan FILE...` lists every repeated run they contain, using the messages of the project in the current directory.

The tests pipe synthetic hook input through the hook and rehearse the installer in a temporary home folder, so they never read real transcripts or change the real settings:

```sh
python3 claude/test/owner-words-test.py   # or pass ~/.claude/hooks/owner-words.py
sh claude/test/install-test.sh
```

### Removing it

`sh claude/uninstall.sh` removes the hook's entry from `~/.claude/settings.json`, its link in `~/.claude/hooks` and its cache. The other merged settings stay, because the uninstaller cannot tell whether the machine had them before the install; `settings.json.dotfiles-backup` shows how the file looked then. ccstatus removes itself with `~/.local/share/ccstatus/uninstall.sh`.


## License

MIT | Copyright &copy; 2016-2021 [Changkun Ou](https://changkun.de)
