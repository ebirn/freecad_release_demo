# freecad_release_demo

This repository shows how to connect a FreeCAD project to reusable GitHub
Actions workflows provided by `ebirn/freecad_tools` with minimal wrapper YAML.

## What this demo does

- Uses reusable CI/release automation from `ebirn/freecad_tools`
- Runs validation on every commit (no artifact publishing)
- Publishes a tagged release artifact bundle
- Publishes a rolling nightly artifact bundle

## Integration with `freecad_tools`

This demo references reusable workflows directly from the tools project and
only sets consumer parameters:

- `.github/workflows/demo-ci.yml` calls:
  - `ebirn/freecad_tools/.github/workflows/build-3mf-artifacts.yml@main`
- `.github/workflows/demo-release.yml` calls:
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
- `.github/workflows/demo-release.yml`: tag-triggered release publishing
- `.github/workflows/demo-nightly-release.yml`: scheduled rolling nightly release

## How to run this demo

1. Push a branch and confirm the `Demo CI` workflow passes.
2. Push a tag like `v0.0.1-demo` and confirm `Demo Tagged Release` passes.
3. Open Releases and verify asset `demo-artifacts-v0.0.1-demo.tar.gz` is attached.
4. Download and inspect bundle contents, including generated outputs:
   - `prints/demo_export.3mf`
   - `docs/demo_export.pdf`
   - `docs/bom.csv`
   - `docs/images/*.png`
5. Run `Demo Nightly Release` manually once and verify asset
   `demo-artifacts-nightly.tar.gz` is attached to release tag `nightly`.

## How to reuse in your project

### 1. Prepare your FreeCAD project

Make sure your project has:
- A `.FCStd` file with your design
- An `export_config.yml` that points to it (see the one in this repo as a starting point)

### 2. Add the workflows

Copy the workflow files from `.github/workflows/` into your own repo:

| File | What it does |
|------|-------------|
| `demo-ci.yml` | Runs on every push/PR — validates your export works (no publishing) |
| `demo-release.yml` | Runs when you push a tag like `v1.0.0` — builds and publishes a release |
| `demo-nightly-release.yml` | Runs on a schedule — builds a rolling nightly artifact |

Rename them if you like, or keep the names. The only thing that matters is the `uses:` line inside each one.

### 3. Adjust the config

Open each workflow file and update the `with:` block to match your project:

- `config_path`: path to your `export_config.yml` (default: `export_config.yml`)
- `project_root`: root of your FreeCAD project (default: `.`)
- `freecad_gui_binary`: path to FreeCAD on the runner (the demo uses `/opt/freecad/usr/bin/freecad`)
- `bundle_name`: name for the release artifact (e.g. `my-project-artifacts`)
- `bundle_paths`: files to include in the release bundle (e.g. `README.md export_config.yml my_design.FCStd`)
- `generated_paths`: directories created by the export (e.g. `docs prints`)

### 4. Pin to a stable version

The demo uses `@main` for simplicity. For your own project, pin to a specific release tag or commit SHA:

```yaml
uses: ebirn/freecad_tools/.github/workflows/build-3mf-artifacts.yml@v0.3.0
```

### 5. Push and verify

1. Push a branch — `Demo CI` should run and pass
2. Push a tag like `v0.1.0` — `Tagged Release` should publish artifacts to the release
3. (Optional) Run `Demo Nightly Release` manually to test scheduled builds

## Notes

- Commit-triggered CI validates only and does not upload artifacts.
- Tag and nightly workflows run non-dry export and publish release assets.
