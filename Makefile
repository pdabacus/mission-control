#
# @file Makefile
# @author Pavan Dayal
#

# subprojects
STAND_EMU               := stand_emulator
STAND_EMU_MAKE          := $(STAND_EMU)/stand_emu.mk
DATABASE                := database
DATABASE_MAKE           := $(DATABASE)/database.mk

# project settings
DOCKER                  := docker
DOCKER_REPO             := docker.io/library
REPO                    := localhost:5000
MAKEFILES               := $(STAND_EMU_MAKE) $(DATABASE_MAKE)

# stages
.PHONY: all
.PHONY: build build-$(STAND_EMU) build-$(DATABASE)
.PHONY: push push-$(STAND_EMU) push-$(DATABASE)
.PHONY: test test-$(STAND_EMU) test-$(DATABASE)
.PHONY: cov cov-$(STAND_EMU) cov-$(DATABASE)
.PHONY: vars vars-basic vars-$(STAND_EMU) vars-$(DATABASE)
.PHONY: clean clean-basic clean-$(STAND_EMU) clean-$(DATABASE)

# default target
all: build push test

# include subproject targets
include $(MAKEFILES)

# build
build: build-$(STAND_EMU) build-$(DATABASE)

# push
push: push-$(STAND_EMU) push-$(DATABASE)

# test
test: test-$(STAND_EMU) test-$(DATABASE)

# coverage
cov: cov-$(STAND_EMU) cov-$(DATABASE)

# clean
clean: | clean-$(STAND_EMU) clean-$(DATABASE) clean-basic

clean-basic:

# vars
vars: | vars-basic vars-$(STAND_EMU) vars-$(DATABASE)

vars-basic:
	@echo "DOCKER                   $(DOCKER)"
	@echo "DOCKER_REPO              $(DOCKER_REPO)"
	@echo "REPO                     $(REPO)"
	@echo "MAKEFILES                $(MAKEFILES)"
	@echo
