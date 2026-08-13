## Highlights

This machine's user is now a trusted Nix user, which unblocks devenv for projects that declare their own flake inputs. Until now, a project whose `devenv.yaml` named an input such as agenix-shell would fail before it started, with the daemon refusing the request: "ignoring the client-specified setting 'system', because it is a restricted setting and you are not a trusted user". That is what stopped ptrckr migrating off its flake, since its two encrypted API keys are decrypted through agenix-shell on shell entry.

Getting the setting to stick took a detour worth recording. Because `nix.enable` is false here — Determinate Nix owns the daemon — nix-darwin's `nix.settings` does nothing at all and `/etc/nix/nix.conf` is never written by this configuration. Determinate rewrites that file at will and says so in its header, but it does include a `nix.custom.conf` alongside it and reserves that for user configuration. That file is now managed declaratively through `environment.etc`, so the setting survives a Determinate upgrade replacing the original and does not sit as an undocumented hand-edit on one machine.

Worth being clear about what this grants: a trusted user can pass restricted settings to the daemon and direct it to build and substitute arbitrary store paths, which is effectively root-equivalent. It takes effect only once the daemon restarts.
