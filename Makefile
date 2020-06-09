#
# @file Makefile
# @author Pavan Dayal
#

# subprojects
STAND_EMU               := stand_emulator
STAND_EMU_MAKE          := $(STAND_EMU)/stand_emu.mk
DATABASE                := database
DATABASE_MAKE           := $(DATABASE)/database.mk
UI                      := ui
UI_MAKE                 := $(UI)/ui.mk

# project settings
DOCKER                  := docker
DOCKER_REPO             := docker.io/library
REPO                    := localhost:5000
MAKEFILES               := $(STAND_EMU_MAKE) $(DATABASE_MAKE) $(UI_MAKE)

# stages
.PHONY: all
.PHONY: build build-$(STAND_EMU) build-$(DATABASE) build-$(UI)
.PHONY: push push-$(STAND_EMU) push-$(DATABASE) push-$(UI)
.PHONY: test test-$(STAND_EMU) test-$(DATABASE) test-$(UI)
.PHONY: cov cov-$(STAND_EMU) cov-$(DATABASE) cov-$(UI)
.PHONY: vars vars-basic vars-$(STAND_EMU) vars-$(DATABASE) vars-$(UI)
.PHONY: clean clean-basic clean-$(STAND_EMU) clean-$(DATABASE) clean-$(UI)

# default target
all: build push test

# include subproject targets
include $(MAKEFILES)

# build
build: build-$(STAND_EMU) build-$(DATABASE) build-$(UI)

# push
push: push-$(STAND_EMU) push-$(DATABASE) push-$(UI)

# test
test: test-$(STAND_EMU) test-$(DATABASE) test-$(UI)

# coverage
cov: cov-$(STAND_EMU) cov-$(DATABASE) cov-$(UI)

# clean
clean: | clean-$(STAND_EMU) clean-$(DATABASE) clean-$(UI) clean-basic

clean-basic:

# vars
vars: | vars-basic vars-$(STAND_EMU) vars-$(DATABASE) vars-$(UI)

vars-basic:
	@echo "DOCKER                   $(DOCKER)"
	@echo "DOCKER_REPO              $(DOCKER_REPO)"
	@echo "REPO                     $(REPO)"
	@echo "MAKEFILES                $(MAKEFILES)"
	@echo
