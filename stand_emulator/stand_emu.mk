#
# @file stand_emulator/stand_emu.mk
# @author Pavan Dayal
#

# stand emulator settings
STAND_EMU_DOCKER        := $(STAND_EMU)/Dockerfile
STAND_EMU_VERSION       := 1.0.0
STAND_EMU_BASE_IMG      := $(DOCKER_REPO)/archlinux:latest
STAND_EMU_IMAGE         := $(REPO)/$(STAND_EMU):$(STAND_EMU_VERSION)

# build
build-$(STAND_EMU): $(STAND_EMU_DOCKER) $(STAND_EMU)/.build-$(STAND_EMU)
	@echo "built $(STAND_EMU_IMAGE)"

$(STAND_EMU)/.build-$(STAND_EMU):
	@echo "building $(STAND_EMU) with $(STAND_EMU_DOCKER)"
	$(DOCKER) build --pull -t $(STAND_EMU_IMAGE) \
		-f	$(STAND_EMU_DOCKER)	\
		--build-arg STAND_EMU="$(STAND_EMU)" \
		--build-arg VERSION="$(STAND_EMU_VERSION)" \
		--build-arg BASE_IMG="$(STAND_EMU_BASE_IMG)" .
	touch $(STAND_EMU)/.build-$(STAND_EMU)

# push
push-$(STAND_EMU): $(STAND_EMU)/.push-$(STAND_EMU)
	@echo "pushed $(STAND_EMU)"

$(STAND_EMU)/.push-$(STAND_EMU): $(STAND_EMU)/.build-$(STAND_EMU)
	@echo "pushing $(STAND_EMU) to $(STAND_EMU_IMAGE)"
	$(DOCKER) push $(STAND_EMU_IMAGE)
	touch $(STAND_EMU)/.push-$(STAND_EMU)

# clean
clean-$(STAND_EMU):
	$(RM) $(STAND_EMU)/.build-$(STAND_EMU)
	$(RM) $(STAND_EMU)/.push-$(STAND_EMU)

# vars
vars-$(STAND_EMU):
	@echo "STAND_EMU                $(STAND_EMU)"
	@echo "STAND_EMU_MAKE           $(STAND_EMU_MAKE)"
	@echo "STAND_EMU_DOCKER         $(STAND_EMU_DOCKER)"
	@echo "STAND_EMU_VERSION        $(STAND_EMU_VERSION)"
	@echo "STAND_EMU_BASE_IMG       $(STAND_EMU_BASE_IMG)"
	@echo "STAND_EMU_IMAGE          $(STAND_EMU_IMAGE)"
	@echo
