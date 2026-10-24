PYTHON ?= python3
RUNTIME ?= .venv/bin/python

.PHONY: all table1 contracts timings verify setup test artifacts encoder check-model benchmark serve
all table1 contracts timings:
	$(PYTHON) scripts/render_results.py
verify:
	$(PYTHON) scripts/render_results.py --check
	$(PYTHON) scripts/verify_study.py
setup:
	uv sync --locked --extra encoder --extra serve --extra dev
test:
	PYTHONPATH=src $(RUNTIME) -m unittest discover -s tests -v
artifacts:
	$(RUNTIME) scripts/download_artifacts.py
encoder:
	$(RUNTIME) scripts/download_artifacts.py --encoder
check-model: artifacts
	$(RUNTIME) scripts/check_release.py --bundle .local/artifacts/structured-seed23
benchmark: encoder
	mkdir -p .local/runs
	$(RUNTIME) scripts/benchmark_system.py --bundle .local/artifacts/structured-seed23 --encoder .local/artifacts/encoder --examples examples/latency-examples.json --output .local/runs/system-benchmark.json
serve: encoder
	./start.sh
