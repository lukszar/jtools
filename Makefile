SCRIPTS_FILE := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/scripts
TARGET := $(HOME)/.jtools
ZPROFILE := $(HOME)/.zprofile
SOURCE_LINE := source ~/.jtools

.PHONY: install uninstall

install:
	@if ! command -v jira >/dev/null 2>&1; then \
		echo "Error: 'jira' CLI not found. Install it from https://github.com/ankitpokhrel/jira-cli"; \
		exit 1; \
	fi
	@echo "==> Installing jtools..."
	@if [ -f "$(TARGET)" ]; then \
		cp "$(SCRIPTS_FILE)" "$(TARGET)"; \
		echo "    [updated] ~/.jtools (replaced existing file)"; \
	else \
		cp "$(SCRIPTS_FILE)" "$(TARGET)"; \
		echo "    [installed] ~/.jtools (new file created)"; \
	fi
	@if grep -qF '$(SOURCE_LINE)' "$(ZPROFILE)" 2>/dev/null; then \
		echo "    [skipped] ~/.zprofile already contains '$(SOURCE_LINE)'"; \
	else \
		echo '' >> "$(ZPROFILE)"; \
		echo '$(SOURCE_LINE)' >> "$(ZPROFILE)"; \
		echo "    [added] '$(SOURCE_LINE)' to ~/.zprofile"; \
	fi
	@echo ""
	@echo ""
	@echo "==> Installation complete!"
	@echo ""
	@echo "📝 To use jtools in your current terminal, run:"
	@echo "   source ~/.zprofile"
	@echo ""
	@echo "   Or open a new terminal window."
	@echo "✅ Done!"

uninstall:
	@echo "==> Uninstalling jtools..."
	@rm -f "$(TARGET)" && echo "    [removed] ~/.jtools" || echo "    [skipped] ~/.jtools not found"
	@if grep -qF '$(SOURCE_LINE)' "$(ZPROFILE)" 2>/dev/null; then \
		grep -vF '$(SOURCE_LINE)' "$(ZPROFILE)" > "$(ZPROFILE).tmp" && mv "$(ZPROFILE).tmp" "$(ZPROFILE)"; \
		echo "    [removed] '$(SOURCE_LINE)' from ~/.zprofile"; \
	else \
		echo "    [skipped] ~/.zprofile entry not found"; \
	fi
	@echo ""
	@echo "==> Uninstall complete. Restart your terminal."
