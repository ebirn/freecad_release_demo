# freecad_release_demo

This repository shows how to connect a FreeCAD project to reusable GitHub
Actions workflows provided by `ebirn/freecad_tools` with minimal wrapper YAML.

## What this demo does

- Uses reusable CI/release automation from `ebirn/freecad_tools`
- Runs export validation in dry-run mode
- Publishes a tagged release artifact bundle
- Publishes a rolling nightly artifact bundle

## Integration with `freecad_tools`

This demo references reusable workflows directly from the tools project and
only sets consumer parameters:

- `.github/workflows/demo-ci.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/build-3mf-artifacts.yml@main`
- `.github/workflows/demo-release-dry-run.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/publish-tagged-release.yml@main`
- `.github/workflows/demo-nightly-release.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/publish-nightly-release.yml@main`

You can use the same pattern in your own FreeCAD repository by adding a job
with `uses:` that points to a reusable workflow in `ebirn/freecad_tools`, then
setting only the input values for your repo paths and naming.

For production usage, pin to a release tag or commit SHA instead of `@main`.

## Files you need in your project

- `export_config.yml`: defines export items and source document path
- `example.FCStd`: your FreeCAD source file (kept in repo root in this demo)
- `.github/workflows/demo-ci.yml`: branch/PR validation
- `.github/workflows/demo-release-dry-run.yml`: tag-triggered release publishing
- `.github/workflows/demo-nightly-release.yml`: scheduled rolling nightly release

## How to run this demo

1. Push a branch and confirm the `Demo CI` workflow passes.
2. Push a tag like `v0.0.1-demo` and confirm `Demo Tagged Release` passes.
3. Open Releases and verify asset `demo-artifacts-v0.0.1-demo.tar.gz` is attached.
4. Run `Demo Nightly Release` manually once and verify asset
   `demo-artifacts-nightly.tar.gz` is attached to release tag `nightly`.

## How to reuse in your project

1. Copy `export_config.yml` and point `source` to your `.FCStd` file.
2. Copy `.github/workflows/demo-ci.yml` and adapt names/inputs as needed.
3. Copy `.github/workflows/demo-release-dry-run.yml` for tag-based releases.
4. Copy `.github/workflows/demo-nightly-release.yml` for rolling nightly updates.
5. Commit and push, then validate branch/tag/nightly runs in Actions.

## Notes

- Commit-triggered CI validates only and does not upload artifacts.
- Release artifacts are created only by tag and nightly workflows.
