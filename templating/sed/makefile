ENV ?= dev
TEAM ?= teamname
.PHONY: all rbac

all:
	$(MAKE) rbac

rbac:
	cat rbac-dynamic.yaml | sed "s|%ENV%|$(ENV)|g" | sed "s|%TEAM%|$(TEAM)|g"
