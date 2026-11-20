# GENIE spline production with Snakemake

This repository contains a Snakemake workflow for producing GENIE spline files for configured tunes, probe leptons, target nuclei, and event-generator lists.

## Workflow overview

For each configured tune, lepton, and event-generator list (EGL), the workflow produces target-specific spline XML files. The target XML files are then merged into a tune-level XML file and converted to ROOT format.

Free-nucleon cross sections are generated separately for protons and neutrons and combined into a free-nucleon spline file. For EGLs listed in `free_nucleon_event_generator_lists`, that file is supplied as the input cross section to the target-level `gmkspl` invocation. Other EGLs are processed directly, without a free-nucleon input file.


The `free_nucleon` branch is conditional: it is required only for EGLs configured in `free_nucleon_event_generator_lists`. For other EGLs, `cross_section` runs without `--input-cross-sections`.

A rendered rule graph is provided in [`rulegraph.svg`](rulegraph.svg).

## Configuration

The workflow is configured through `config.yml`. The main settings are:

| Setting | Purpose |
|---|---|
| `tune` | GENIE tune used for spline production |
| `leptons` | Probe-lepton PDG codes |
| `targets` | Target names mapped to nuclear PDG codes |
| `event-generator-lists` | EGLs for which target splines are produced |
| `energy_range` | Maximum energy passed to `gmkspl` |
| `n` | Number of spline points passed to `gmkspl` |
| `free_nucleon_event_generator_lists` | EGLs for which free-proton and free-neutron splines are generated and used as input cross sections |

Only include an EGL in `free_nucleon_event_generator_lists` if the workflow should generate and use free-nucleon cross sections for it. The current configuration is intended to restrict this branch to DIS and RES processes. QE is not included at present; its treatment should be reconsidered once the appropriate nuclear/spectral-function assumptions are settled.

## Running the workflow

Run Snakemake from the repository's workflow directory, where `config.yml` is available:

```bash
snakemake --cores $(nproc)
```


## Output structure

The intermediate files are organized by tune, target, lepton, and EGL. In particular, target-level XML files follow this pattern:

```text
<tune>/targets/<target>/<lepton>/<egl>/splines.xml
```

The free-nucleon intermediate files follow this pattern:

```text
<tune>/free_nucleons/<lepton>/<egl>/splines_free_nucleon.xml
```

The merged tune-level XML and ROOT outputs are:

```text
<tune>.xml
<tune>.root
```

## Profiles

**At the moment, I do not recommend using Snakemake profiles with this workflow as there are several only seconds long jobs.** 
