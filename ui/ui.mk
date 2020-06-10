#
# @file ui/ui.mk
# @author Pavan Dayal
#

# ui settings
UI_DOCKER               := $(UI)/Dockerfile
UI_SETTINGS             := $(UI)/settings.json
UI_VERSION              := $(shell jq -r .version $(UI_SETTINGS))
UI_DEFAULT_PORT         := $(shell jq -r .port $(UI_SETTINGS))
UI_BASE_IMG             := $(DOCKER_REPO)/archlinux:latest
UI_IMAGE                := $(REPO)/$(UI):$(UI_VERSION)
UI_SRC                  := $(shell find $(UI)/src -type f -maxdepth 1)
UI_TEST                 := $(shell find $(UI)/test -type f)
UI_TEST_FN              := $(shell find $(UI)/test_fn -type f)
UI_DEPS                 := $(UI_DOCKER) $(UI_SETTINGS) \
                              $(UI_SRC) $(UI_TEST) $(UI_TEST_FN)

# build
build-$(UI): $(UI)/.build-$(UI)
	@echo "built $(UI_IMAGE)"

$(UI)/.build-$(UI): $(UI_DEPS)
	@echo "building $(UI) with $(UI_DOCKER)"
	$(DOCKER) build --pull -t $(UI_IMAGE) \
		-f	$(UI_DOCKER)	\
		--build-arg UI="${UI}" \
		--build-arg VERSION="${UI_VERSION}" \
		--build-arg BASE_IMG="${UI_BASE_IMG}" \
		--build-arg DEFAULT_PORT="${UI_DEFAULT_PORT}" .
	touch $(UI)/.build-$(UI)

# push
push-$(UI): $(UI)/.push-$(UI)
	@echo "pushed $(UI)"

$(UI)/.push-$(UI): $(UI)/.build-$(UI)
	@echo "pushing $(UI) to $(UI_IMAGE)"
	#$(DOCKER) push $(UI_IMAGE)
	touch $(UI)/.push-$(UI)

# test
test-$(UI): $(UI)/.push-$(UI)
	@echo "testing $(UI) on $(UI_IMAGE)"
	$(DOCKER) run -it $(UI_IMAGE) make test FLAGS=" \
		-D VERSION=\\\"\$$\$$VERSION\\\" \
		-D DEFAULT_PORT=\$$\$$DEFAULT_PORT"

# coverage
cov-$(UI): $(UI)/.push-$(UI)
	@echo "testing $(UI) with coverage on $(UI_IMAGE)"
	$(DOCKER) run -it $(UI_IMAGE) make cov FLAGS=" \
		-D VERSION=\\\"\$$\$${VERSION}\\\" \
		-D DEFAULT_PORT=\$$\$${DEFAULT_PORT}"

# clean
clean-$(UI):
	$(RM) $(UI)/.build-$(UI)
	$(RM) $(UI)/.push-$(UI)

# vars
vars-$(UI):
	@echo "UI                       $(UI)"
	@echo "UI_MAKE                  $(UI_MAKE)"
	@echo "UI_DOCKER                $(UI_DOCKER)"
	@echo "UI_SETTINGS              $(UI_SETTINGS)"
	@echo "UI_VERSION               $(UI_VERSION)"
	@echo "UI_DEFAULT_PORT          $(UI_DEFAULT_PORT)"
	@echo "UI_BASE_IMG              $(UI_BASE_IMG)"
	@echo "UI_IMAGE                 $(UI_IMAGE)"
	@echo "UI_SRC                   $(UI_SRC)"
	@echo "UI_TEST                  $(UI_TEST)"
	@echo "UI_TEST_FN               $(UI_TEST_FN)"
	@echo "UI_DEPS                  $(UI_DEPS)"
	@echo
