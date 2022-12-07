PROJECT_ROOT=$(shell realpath .)

OUT_DIR = build-cache
GEN_DIRS += $(OUT_DIR)

PTXPROJ = ptxproj
PTXPROJ_PATH=$(PROJECT_ROOT)/$(PTXPROJ)
GEN_DIRS += $(PTXPROJ)

USERID ?= $(shell id -u)
USERID := $(USERID)
DOCKER_BUILDFLAGS += --build-arg 'USERID=$(USERID)'

.PHONY: all
all: project

$(GEN_DIRS):
	mkdir -p $@

.PHONY: builder
builder: $(OUT_DIR)/pfc-project-builder

$(OUT_DIR)/pfc-project-builder: Dockerfile Makefile | $(OUT_DIR)
	docker buildx build $(DOCKER_BUILDFLAGS) --iidfile $@ --file $< --tag pfc-project-builder docker

.PHONY: run
run: builder | $(PTXPROJ)
	docker run --rm -it --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder bash

.PHONY: init
init: builder | $(PTXPROJ)
	docker run --rm -i --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder ./init.sh

.PHONY: get
get: init | $(PTXPROJ)
	docker run --rm -it --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder build get

.PHONY: offline-get
offline-get: init | $(PTXPROJ)
	docker run --rm -i --network none --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder build get

.PHONY: project
project: init | $(PTXPROJ)
	docker run --rm -it --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder  ptxdist targetinstall wda-frontend-example -q

.PHONY: build
build: init | $(PTXPROJ)
	docker run --rm -it --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder build

.PHONY: offline-build
offline-build: init | $(PTXPROJ)
	docker run --rm -it --network none --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder build

.PHONY: images
images: init | $(PTXPROJ)
	docker run --rm -it --network none --user "$(USERID)" -v "$(PTXPROJ_PATH):/home/user/ptxproj" pfc-project-builder build images
