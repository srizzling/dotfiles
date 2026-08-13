## Highlights

**Release notes you can actually read.** Releases now open with a written summary of what changed and why it matters to you, rather than only a list of commit subjects. The grouped commit changelog still follows underneath, so nothing is lost — it just stops being the only thing there.

**Setup links that work.** Every link in the release template and the README still pointed at `srizzling/.dotfiles.fish`, which stopped resolving when this repo was renamed to `srizzling/dotfiles`. That included the `git clone` line in the README's Quick Start, so bootstrapping a fresh machine from the published instructions failed at the first step. All of them now point at the real repo.

**One place for setup instructions.** The bootstrap walkthrough has moved out of the release template and into the README, where it sits next to the daily commands and can be kept current without editing the release config.
