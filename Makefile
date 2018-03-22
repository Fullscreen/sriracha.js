##
# Binaries
##

BROWSERIFY = node_modules/.bin/browserify
ESLINT = node_modules/.bin/eslint
UGLIFYJS = node_modules/.bin/uglifyjs

##
# Files
##

SRC = $(wildcard lib/*.js)

##
# Tasks
##

# Install node modules.
node_modules: package.json $(wildcard node_modules/*/package.json)
	@npm install
	@touch node_modules

# Install dependencies.
install: node_modules

# Remove temporary files and build artifacts.
clean:
	rm -rf *.log sriracha.js sriracha.min.js
.PHONY: clean

# Remove temporary files, build artifacts, and vendor dependencies.
distclean: clean
	rm -rf node_modules
.PHONY: distclean

# Build sriracha.js.
sriracha.js: install $(SRC) package.json
	@$(BROWSERIFY) lib/index.js --standalone sriracha > sriracha.js

# Build minified sriracha.js.
sriracha.min.js: sriracha.js
	@$(UGLIFYJS) $< --output $@

# Build shortcut.
build: sriracha.min.js
.PHONY: build

# Lint JavaScript source files.
lint: node_modules
	@$(ESLINT) $(SRC)
.PHONY: lint

# Run browser unit tests in a browser.
test-browser: install
.PHONY: test-browser

# Default test target.
test: lint test-browser
.PHONY: test
.DEFAULT_GOAL = test

test-sauce: test
.PHONY: test-sauce
