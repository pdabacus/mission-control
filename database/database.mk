#
# @file database/database.mk
# @author Pavan Dayal
#

# database settings
DATABASE_DOCKER         := $(DATABASE)/Dockerfile
DATABASE_SETTINGS       := $(DATABASE)/settings.json
DATABASE_VERSION        := $(shell jq -r .version $(DATABASE_SETTINGS))
DATABASE_DEFAULT_PORT   := $(shell jq -r .port $(DATABASE_SETTINGS))
DATABASE_BASE_IMG       := $(DOCKER_REPO)/archlinux:latest
DATABASE_IMAGE          := $(REPO)/$(DATABASE):$(DATABASE_VERSION)
DATABASE_SRC            := $(shell find $(DATABASE)/src -type f)
DATABASE_TEST           := $(shell find $(DATABASE)/test -type f)
DATABASE_TEST_FN        := $(shell find $(DATABASE)/test_fn -type f)
DATABASE_DEPS           := $(DATABASE_DOCKER) $(DATABASE_SETTINGS) \
                        $(DATABASE_SRC) $(DATABASE_TEST) $(DATABASE_TEST_FN)

# build
build-$(DATABASE): $(DATABASE)/.build-$(DATABASE)
	@echo "built $(DATABASE_IMAGE)"

$(DATABASE)/.build-$(DATABASE): $(DATABASE_DEPS)
	@echo "building $(DATABASE) with $(DATABASE_DOCKER)"
	$(DOCKER) build --pull -t $(DATABASE_IMAGE) \
		-f	$(DATABASE_DOCKER)	\
		--build-arg DATABASE="${DATABASE}" \
		--build-arg VERSION="${DATABASE_VERSION}" \
		--build-arg BASE_IMG="${DATABASE_BASE_IMG}" \
		--build-arg DEFAULT_PORT="${DATABASE_DEFAULT_PORT}" .
	touch $(DATABASE)/.build-$(DATABASE)

# push
push-$(DATABASE): $(DATABASE)/.push-$(DATABASE)
	@echo "pushed $(DATABASE)"

$(DATABASE)/.push-$(DATABASE): $(DATABASE)/.build-$(DATABASE)
	@echo "pushing $(DATABASE) to $(DATABASE_IMAGE)"
	#$(DOCKER) push $(DATABASE_IMAGE)
	touch $(DATABASE)/.push-$(DATABASE)

# test
test-$(DATABASE): $(DATABASE)/.push-$(DATABASE)
	@echo "testing $(DATABASE) on $(DATABASE_IMAGE)"
	$(DOCKER) run -it $(DATABASE_IMAGE) make test FLAGS=" \
		-D VERSION=\\\"\$$\$$VERSION\\\" \
		-D DEFAULT_PORT=\$$\$$DEFAULT_PORT"

# coverage
cov-$(DATABASE): $(DATABASE)/.push-$(DATABASE)
	@echo "testing $(DATABASE) with coverage on $(DATABASE_IMAGE)"
	$(DOCKER) run -it $(DATABASE_IMAGE) make cov FLAGS=" \
		-D VERSION=\\\"\$$\$${VERSION}\\\" \
		-D DEFAULT_PORT=\$$\$${DEFAULT_PORT}"

# clean
clean-$(DATABASE):
	$(RM) $(DATABASE)/.build-$(DATABASE)
	$(RM) $(DATABASE)/.push-$(DATABASE)

# vars
vars-$(DATABASE):
	@echo "DATABASE                 $(DATABASE)"
	@echo "DATABASE_MAKE            $(DATABASE_MAKE)"
	@echo "DATABASE_DOCKER          $(DATABASE_DOCKER)"
	@echo "DATABASE_SETTINGS        $(DATABASE_SETTINGS)"
	@echo "DATABASE_VERSION         $(DATABASE_VERSION)"
	@echo "DATABASE_DEFAULT_PORT    $(DATABASE_DEFAULT_PORT)"
	@echo "DATABASE_BASE_IMG        $(DATABASE_BASE_IMG)"
	@echo "DATABASE_IMAGE           $(DATABASE_IMAGE)"
	@echo "DATABASE_SRC             $(DATABASE_SRC)"
	@echo "DATABASE_TEST            $(DATABASE_TEST)"
	@echo "DATABASE_TEST_FN         $(DATABASE_TEST_FN)"
	@echo "DATABASE_DEPS            $(DATABASE_DEPS)"
	@echo
