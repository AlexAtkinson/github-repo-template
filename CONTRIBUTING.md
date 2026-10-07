# Contributing

Contributions are welcome. For substantial changes, open an issue or discussion first so the scope and approach can be agreed before implementation.

## Development Setup

* Install Git, Bash, Gitleaks, and ShellCheck.
* Install and update the repository-managed hooks with `bash .githooks/setup.sh`.
* Keep secrets and private data out of commits, fixtures, logs, and pull-request descriptions.

## Changes and Pull Requests

* Keep changes focused and include tests or verification appropriate to the change.
* Run the relevant project build and tests. For hook changes, run `shellcheck .githooks/hook-sync.sh .githooks/setup.sh .githooks/hooks/*` and verify staged changes with Gitleaks.
* Open a pull request and select exactly one change type in the initial template. Complete the routed template and every security-checklist item honestly.
* Explain the behavior change, verification performed, and any security, dependency, or release impact.
* Request review before merging. Do not merge while required checks are failing or conversations remain unresolved.

## Workflow and Release Changes

GitHub Actions references must use full commit SHAs with a comment identifying the reviewed upstream version. Review action source, permissions, and release impact when updating a pin.

Changes to `.github/workflows/build-and-release.yml` must preserve release provenance, SBOM generation and attestation, accurate licensing and attribution data, Cosign signatures, and the files and verification materials published with each release. See `.github/copilot-instructions.md` for the repository's release-security requirements.

## Licensing

By submitting a contribution, you agree that it is provided under the Apache License, Version 2.0, unless you and the maintainers have agreed otherwise in writing. Retain applicable copyright, license, and attribution notices.
