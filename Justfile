

set shell := ["bash", "-cu"]
freecad_tools_version := "v0.6.0"
config := ".freecad_tools/config.yml"

default:
    # list the available targets
    just --list

# setup the virtual environment and install dependencies
init:
    uv venv .venv --clear
    uv pip install "freecad-tools @ git+https://github.com/ebirn/freecad_tools@{{freecad_tools_version}}"

# export a named config entry
export name:
    source .venv/bin/activate && freecad-export --config {{config}} --name {{name}}

# export all items defined in the config
export-all:
    source .venv/bin/activate && freecad-export --config {{config}}

# list all available exports defined in the config
export-list:
    source .venv/bin/activate && freecad-export --config {{config}} --list-exports
