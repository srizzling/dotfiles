## Highlights

A small maintenance release on the Mac side. Discord is no longer installed by nix. Its updater refuses to launch the app until it can write the latest release over the bundle, which it can never do against the read-only nix store, and the workarounds were becoming their own maintenance burden — so the package is dropped and Discord is installed by hand instead. The aerospace and Hyprland window rules stay, and apply just as well to a manually installed copy.

The nixpkgs pin moves forward from 2026-08-11 to 2026-08-29, which carries devenv from 2.2.1 to 2.2.2 and puts an end to its out-of-date warning on every shell activation.

The development environment guidance written into `~/CLAUDE.md` now distinguishes repositories you control from upstream clones. Projects you own under `personal/` and `work/` still must use devenv, but clones of projects you merely contribute to live under `~/development/opensource/` and keep whatever tooling their maintainers ship — scaffolding devenv files into someone else's repository is now explicitly called out as the wrong move, and `devinit` refusing to run there is documented as intentional.
