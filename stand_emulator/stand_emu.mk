#
# @file stand_emulator/stand_emu.mk
# @author Pavan Dayal
#

# stand emulator settings
STAND_EMU_DOCKER        := $(STAND_EMU)/Dockerfile
STAND_EMU_SETTINGS      := $(STAND_EMU)/settings.json
STAND_EMU_VERSION       := $(shell jq -r .version $(STAND_EMU_SETTINGS))
STAND_EMU_DEFAULT_PORT  := $(shell jq -r .port $(STAND_EMU_SETTINGS))
STAND_EMU_BASE_IMG      := $(DOCKER_REPO)/archlinux:latest
STAND_EMU_IMAGE         := $(REPO)/$(STAND_EMU):$(STAND_EMU_VERSION)
STAND_EMU_SRC           := $(shell find $(STAND_EMU)/src -type f)
STAND_EMU_TEST          := $(shell find $(STAND_EMU)/test -type f)
STAND_EMU_TEST_FN       := $(shell find $(STAND_EMU)/test_fn -type f)
STAND_EMU_DEPS          := $(STAND_EMU_DOCKER) $(STAND_EMU_SETTINGS) \
                        $(STAND_EMU)/Makefile $(STAND_EMU_SRC) \
                        $(STAND_EMU_TEST) $(STAND_EMU_TEST_FN)

# build
build-$(STAND_EMU): $(STAND_EMU)/.build-$(STAND_EMU)
	@echo "built $(STAND_EMU_IMAGE)"

$(STAND_EMU)/.build-$(STAND_EMU): $(STAND_EMU_DEPS)
	@echo "building $(STAND_EMU) with $(STAND_EMU_DOCKER)"
	$(DOCKER) build --pull -t $(STAND_EMU_IMAGE) \
		-f	$(STAND_EMU_DOCKER)	\
		--build-arg VERSION="${STAND_EMU_VERSION}" \
		--build-arg BASE_IMG="${STAND_EMU_BASE_IMG}" \
		--build-arg DEFAULT_PORT="${STAND_EMU_DEFAULT_PORT}" $(STAND_EMU)
	touch $(STAND_EMU)/.build-$(STAND_EMU)

# push
push-$(STAND_EMU): $(STAND_EMU)/.push-$(STAND_EMU)
	@echo "pushed $(STAND_EMU)"

$(STAND_EMU)/.push-$(STAND_EMU): $(STAND_EMU)/.build-$(STAND_EMU)
	@echo "pushing $(STAND_EMU) to $(STAND_EMU_IMAGE)"
	#$(DOCKER) push $(STAND_EMU_IMAGE)
	touch $(STAND_EMU)/.push-$(STAND_EMU)

# test
run-$(STAND_EMU): $(STAND_EMU)/.push-$(STAND_EMU)
	@echo "running $(STAND_EMU) on $(STAND_EMU_IMAGE)"
	$(DOCKER) run --net=host -it $(STAND_EMU_IMAGE) make run

# test
test-$(STAND_EMU): $(STAND_EMU)/.push-$(STAND_EMU)
	@echo "testing $(STAND_EMU) on $(STAND_EMU_IMAGE)"
	$(DOCKER) run -it $(STAND_EMU_IMAGE) make test

# coverage
cov-$(STAND_EMU): $(STAND_EMU)/.push-$(STAND_EMU)
	@echo "testing $(STAND_EMU) with coverage on $(STAND_EMU_IMAGE)"
	$(DOCKER) run -it $(STAND_EMU_IMAGE) make cov

# clean
clean-$(STAND_EMU):
	$(RM) $(STAND_EMU)/.build-$(STAND_EMU)
	$(RM) $(STAND_EMU)/.push-$(STAND_EMU)

# vars
vars-$(STAND_EMU):
	@echo "STAND_EMU                $(STAND_EMU)"
	@echo "STAND_EMU_MAKE           $(STAND_EMU_MAKE)"
	@echo "STAND_EMU_DOCKER         $(STAND_EMU_DOCKER)"
	@echo "STAND_EMU_SETTINGS       $(STAND_EMU_SETTINGS)"
	@echo "STAND_EMU_VERSION        $(STAND_EMU_VERSION)"
	@echo "STAND_EMU_DEFAULT_PORT   $(STAND_EMU_DEFAULT_PORT)"
	@echo "STAND_EMU_BASE_IMG       $(STAND_EMU_BASE_IMG)"
	@echo "STAND_EMU_IMAGE          $(STAND_EMU_IMAGE)"
	@echo "STAND_EMU_SRC            $(STAND_EMU_SRC)"
	@echo "STAND_EMU_TEST           $(STAND_EMU_TEST)"
	@echo "STAND_EMU_TEST_FN        $(STAND_EMU_TEST_FN)"
	@echo "STAND_EMU_DEPS           $(STAND_EMU_DEPS)"
	@echo
