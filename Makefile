SCRIPTS_FILE := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/scripts
TARGET := $(HOME)/.jtools
ZPROFILE := $(HOME)/.zprofile
SOURCE_LINE := source ~/.jtools

.PHONY: install

install:
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
