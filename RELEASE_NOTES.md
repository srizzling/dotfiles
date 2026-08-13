## Highlights

**Release notes you can actually read.** Releases now open with a written summary of what changed and why it matters — this section. The grouped commit changelog still follows underneath, so nothing is lost; it just stops being the only thing there. The summary lives in `RELEASE_NOTES.md` and is rewritten before each release, and `make release` refuses to run while it still describes the previous one.

**Setup links that work again.** Every link in the release template and the README still pointed at `srizzling/.dotfiles.fish`, which stopped resolving when this repo was renamed to `srizzling/dotfiles`. The `git clone` line in the README's Quick Start was one of them, so bootstrapping a fresh machine by following the published instructions failed at the very first step. All of them now point at the real repo.

**`make release` finishes the job.** It previously pushed the new tag but not the version commit that cog creates, leaving `chore(version)` unpushed on your machine after every release — easy to miss, and a source of drift when releasing from a second machine. It now pushes both.

**One place for setup instructions.** The bootstrap walkthrough moved out of the release template and into the README, alongside the daily commands and a new `Releasing` section, where it can be kept current without editing release config.

### Also in this release

- New `make release-notes` prints the commits since the last tag, as source material for writing the summary above.
- The `chore(version)` bump commit no longer appears in its own changelog.
- Replaced GoReleaser's deprecated `archives.format` key, which would have broken on a future version.
- Local GoReleaser dry-run output (`dist/`) is now git-ignored.
