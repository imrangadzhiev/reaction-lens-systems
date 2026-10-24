<div align="center">

# Reaction Lens Systems

**Verifiable full-catalog retrieval from scientific text**

![Python](https://img.shields.io/badge/Python-3.11%E2%80%933.12-blue)
![Code license](https://img.shields.io/badge/code-MIT-green)
[Protocol](PROTOCOL.md) · [Numerical evidence](NUMBERS.csv) · [Model bundle](https://huggingface.co/imrangadzhiev/reaction-lens-systems)

</div>

Reaction Lens retrieves Reactome reactions from English scientific titles and
abstracts using a description-conditioned global/local scorer. The release
provides full-catalog inference, integrity-checked model artifacts and executable
verification of candidate-independent scores. Recorded results separate encoding
cost from exact scoring and bind each observation to a fixed model and source
identity. Ranked reactions and selected sets support expert literature review.

## Verify the recorded results

From the repository root, with Python 3.11 or 3.12:

```sh
make verify
```

No model download, account or third-party Python package is required.
Validation also rejects missing/duplicate probes, incomplete catalog predictions,
changed artifact identities and relaxed acceptance tolerances. This checks
recorded observations, summary statistics, generated outputs and the hashes of
the measured implementation. Run `make all` to regenerate the numerical tables
from the committed observations. These commands do not rerun inference.

## Install and run

Install [uv](https://docs.astral.sh/uv/), then:

```sh
make setup
make serve
```

Open **http://127.0.0.1:8767/**. Try:
`STAT1 induces SMAD7 expression and inhibits TGF-beta signaling.`
The interface shows ranked reactions and their scores. API documentation is at
http://127.0.0.1:8767/docs. Stop with Ctrl+C; use `PORT=8768 make serve` for another
port. Subsequent runs reuse verified local model files.

The first run downloads the inference bundle and pinned upstream encoder files.
The [public model bundle](https://huggingface.co/imrangadzhiev/reaction-lens-systems)
and the pinned upstream encoder files can be downloaded without an HF account.
Anonymous downloads from an empty cache have been verified against their hashes.

The model repository, immutable revision and nine required file hashes are in
[artifact-manifest.json](artifact-manifest.json). Downloads select only those
files; unrelated model-repository contents are not needed. The bundle manifest
pins the upstream encoder revisions and hashes. Downloaded models are stored in
`.local/artifacts/`; local models and environments are excluded from version control.

## Reproduce inference and measurements

After `make setup`:

```sh
make test
make check-model
make benchmark
```

`make check-model` recomputes scores for all 2,377 development publications against
15,692 reactions using the released cached features and compares MAP, Hit@1 and
Recall@100 with recorded values. It does not retrain the model or reconstruct the
full feature cache from publication text.

`make benchmark` reruns candidate-transformation checks, scoring timings,
separate-process memory probes and complete-text local predictions. New results
are written to `.local/runs/system-benchmark.json`, preserving published
observations. Timing varies with hardware and load. The recorded experiment uses
CPU FP32 and two PyTorch threads; see [PROTOCOL.md](PROTOCOL.md) for sampling,
warmups and measurement boundaries. The local artifact files occupy about
583 MB; allow additional space for dependencies and download caches.

## Evidence map

| Recorded result | Committed evidence | Regeneration |
|---|---|---|
| Blocking latency and memory | [Scoring table](results/table1_scoring.csv) | `make table1` |
| Candidate-independence checks | [All contract probes](results/table3_contracts.csv) | `make contracts` |
| Complete predictions | [Component timings](results/table2_end_to_end.csv) | `make timings` |
| Cached-feature ranking | [Fresh evaluation](results/fresh-evaluation.json) | `make check-model` |

The CSV regeneration targets share one deterministic renderer. Raw benchmark
observations are in [system-benchmark.json](results/system-benchmark.json).
[NUMBERS.csv](NUMBERS.csv) maps displayed values to source fields and
transformations; [measured-source-hashes.json](measured-source-hashes.json)
identifies the measured scorer, encoder, pipeline and benchmark script.

The protocol specifies the fixed checkpoint, CPU FP32 environment, sampled inputs
and workload boundaries. Candidate invariants apply to pair scores and
fixed-threshold selection; ranking positions depend on the candidate set.

## Research materials and licenses

Source code is licensed under [MIT](LICENSE), manuscript text under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Model and data terms are documented separately in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
