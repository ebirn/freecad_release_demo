# freecad_release_demo

This repository shows how to connect a FreeCAD project to reusable GitHub
Actions workflows provided by `ebirn/freecad_tools`.

## What this demo does

- Uses reusable CI/release automation from `ebirn/freecad_tools`
- Runs export validation in dry-run mode (safe, non-public)
- Demonstrates tag-triggered release workflow wiring

## Integration with `freecad_tools`

This demo references reusable workflows directly from the tools project:

- `.github/workflows/demo-ci.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/build-3mf-artifacts.yml@main`
- `.github/workflows/demo-release-dry-run.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/build-3mf-artifacts.yml@main`

You can use the same pattern in your own FreeCAD repository by adding a job
with `uses:` that points to the reusable workflow in `ebirn/freecad_tools`.

For production usage, pin to a release tag or commit SHA instead of `@main`.

## Files you need in your project

- `export_config.yml`: defines export items and source document path
- `example.FCStd`: your FreeCAD source file (kept in repo root in this demo)
- `.github/workflows/demo-ci.yml`: branch/PR validation
- `.github/workflows/demo-release-dry-run.yml`: tag-triggered dry-run release

## How to run this demo

1. Push a branch and confirm the `Demo CI` workflow passes.
2. Push a tag like `v0.0.1-demo` and confirm `Demo Release Dry Run` passes.
3. Review the release preview notes in the `release-preview` job logs.

## How to reuse in your project

1. Copy `export_config.yml` and point `source` to your `.FCStd` file.
2. Copy `.github/workflows/demo-ci.yml` and adapt names/inputs as needed.
3. Copy `.github/workflows/demo-release-dry-run.yml` for tag-based releases.
4. Commit and push, then validate branch and tag runs in Actions.

## Notes

- This repo is intentionally configured for dry-run and non-public validation.
- Switch to non-dry-run and real release publishing only after naming and
  release policy are finalized.
