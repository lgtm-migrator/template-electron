include make/general/Makefile

SUPPORTED_COMMANDS := linter
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  COMMANDS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(COMMANDS_ARGS):;@:)
endif

apps/node_modules:
	cd apps && npm install

install: apps/node_modules node_modules ## Installation application

linter: node_modules ### Scripts Linter
ifeq ($(COMMANDS_ARGS),all)
	@make linter readme -i
else ifeq ($(COMMANDS_ARGS),readme)
	@npm run linter-markdown README.md
else
	@printf "${MISSING_ARGUMENTS}" "linter"
	$(call array_arguments, \
		["all"]="Launch all linter" \
		["readme"]="linter README.md" \
	)
endif