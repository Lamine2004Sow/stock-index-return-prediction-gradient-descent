# Virtual environment directory name
VENV = .venv

# Detect operating system and configure paths / commands accordingly
ifeq ($(OS),Windows_NT)
    PYTHON = python
    VENV_BIN = $(VENV)/Scripts
    RM = rmdir /s /q
else
    PYTHON = python3
    VENV_BIN = $(VENV)/bin
    RM = rm -rf
endif

.PHONY: all venv install clean

# Default target runs install
all: install

# Rule to create the virtual environment if the binary directory doesn't exist
$(VENV_BIN)/pip:
	$(PYTHON) -m venv $(VENV)

# Helper target to initialize virtual environment
venv: $(VENV_BIN)/pip

# Rule to install requirements into the virtual environment
install: $(VENV_BIN)/pip requirements.txt
	$(VENV_BIN)/pip install --upgrade pip
	$(VENV_BIN)/pip install -r requirements.txt

# Rule to clean up the virtual environment and generated artifacts
clean:
	-$(RM) $(VENV)
	-$(RM) __pycache__
	-$(RM) .pytest_cache
	-$(RM) .mypy_cache
	-$(RM) .ipynb_checkpoints
	-find . -type d -name "__pycache__" -prune -exec rm -rf {} +
	-find . -type d -name ".ipynb_checkpoints" -prune -exec rm -rf {} +
	-find . -type f -name "*.pyc" -delete
	-find . -type f -name ".DS_Store" -delete
