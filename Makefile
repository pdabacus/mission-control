#
# @file Makefile
# @author Pavan Dayal
#

# subprojects
STAND_EMU               := stand_emulator
STAND_EMU_MAKE          := $(STAND_EMU)/stand_emu.mk

# project settings
DOCKER                  := docker
DOCKER_REPO             := docker.io/library
REPO                    := localhost:5000
MAKEFILES               := $(STAND_EMU_MAKE)

# stages
.PHONY: all
.PHONY: build build-$(STAND_EMU)
.PHONY: vars vars-$(STAND_EMU)

# default target
all: build push

# include subproject targets
include $(MAKEFILES)

# build
build: build-$(STAND_EMU)

# push
push: push-$(STAND_EMU)

# clean
clean: | clean-$(STAND_EMU) clean-basic

clean-basic:

# vars
vars: | vars-basic vars-$(STAND_EMU)

vars-basic:
	@echo "DOCKER                   $(DOCKER)"
	@echo "DOCKER_REPO              $(DOCKER_REPO)"
	@echo "REPO                     $(REPO)"
	@echo "MAKEFILES                $(MAKEFILES)"
	@echo
