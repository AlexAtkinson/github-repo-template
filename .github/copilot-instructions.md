# Repository Instructions for Copilot

## Template Initialization

INIT_TEMPLATE=true

When `INIT_TEMPLATE` is `true`, this repository is being initialized from a reusable GitHub repository template. First implement the new repository's stated purpose: replace template placeholders and example content with project-specific descriptions, metadata, architecture, build/test commands, security details, and release behavior. Do not leave example claims or sample maintainer information presented as facts.

Preserve the reusable tooling inherited from the template and adapt it to the new project rather than removing it just to complete initialization. This includes repository-managed hooks and Gitleaks configuration under `.githooks/`, pull-request and security automation under `.github/`, and the build-and-release workflow's SBOM, attribution, provenance, attestation, and Sigstore Cosign controls. Keep tools that do not apply only after confirming they are genuinely irrelevant and documenting an intentional replacement where needed.

After the first initialization effort has implemented the repository's purpose and reviewed the inherited tooling, change `INIT_TEMPLATE=true` to `INIT_TEMPLATE=false`. Remove the one-time instructions that identify the repository as newly spawned from this template, but retain the false state flag and all ongoing tooling-maintenance instructions below. Do not repeat the initialization process when the flag is `false`.

## Build and Release Workflow

Treat `.github/workflows/build-and-release.yml` as critical release-security infrastructure. Changes to it can affect every published release; preserve its security controls and carefully review changes to permissions, build inputs, generated assets, attestations, signing, or release contents.

Every published artifact must have a current, accurate SBOM that corresponds to the artifact being released. Maintain the SBOM generation inputs whenever build outputs or dependencies change, and ensure the SBOM captures direct and transitive components with their versions, licenses, copyrights, and required attribution notices. Do not invent license or attribution data; resolve missing or ambiguous metadata from authoritative sources and include applicable third-party notices with the release.

For each release, attest the artifact's build provenance and bind its SBOM to that artifact using GitHub artifact attestations. Sign every published artifact and its SBOM with Sigstore Cosign, and publish the signatures and certificates or bundles needed for independent verification. Do not remove, bypass, or silently weaken these controls. Keep verification instructions and release contents in sync with the workflow.

When changing the workflow, verify that the SBOM is generated after the release inputs are available, attestation subjects identify the actual published artifacts, signatures cover the final bytes, and all expected assets and verification materials are attached to the release. Use the least permissions needed by the attestation and release steps.
