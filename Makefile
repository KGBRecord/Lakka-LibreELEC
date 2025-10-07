all: release

system:
	./scripts/image

release:
	./scripts/image release

image:
	./scripts/image mkimage

noobs:
	./scripts/image noobs

clean:
	./scripts/makefile_helper --clean

distclean:
	./scripts/makefile_helper --distclean

src-pkg:
	tar cvJf sources.tar.xz sources

# Docker targets
docker-build:
	docker-compose build lakka-builder

docker-shell:
	docker-compose run --rm lakka-builder /bin/bash

# Docker image build targets with parameters
docker-image:
	docker-compose run --rm lakka-builder /bin/bash -c "./scripts/image"

docker-image-release:
	docker-compose run --rm lakka-builder /bin/bash -c "./scripts/image release"

docker-image-mkimage:
	docker-compose run --rm lakka-builder /bin/bash -c "./scripts/image mkimage"

docker-image-noobs:
	docker-compose run --rm lakka-builder /bin/bash -c "./scripts/image noobs"

# Docker image build with custom project and architecture
docker-image-custom:
	@if [ -z "$(PROJECT)" ]; then echo "Usage: make docker-image-custom PROJECT=<project> [ARCH=<arch>] [DEVICE=<DEVICE>]"; exit 1; fi
	docker-compose run --rm \
		-e PROJECT=$(PROJECT) \
		$(if $(ARCH),-e ARCH=$(ARCH),) \
		$(if $(DEVICE),-e DEVICE=$(DEVICE),) \
		lakka-builder /bin/bash -c "./scripts/image"

docker-image-release-custom:
	@if [ -z "$(PROJECT)" ]; then echo "Usage: make docker-image-custom PROJECT=<project> [ARCH=<arch>] [DEVICE=<DEVICE>]"; exit 1; fi
	docker-compose run --rm \
		-e PROJECT=$(PROJECT) \
		$(if $(ARCH),-e ARCH=$(ARCH),) \
		$(if $(DEVICE),-e DEVICE=$(DEVICE),) \
		lakka-builder /bin/bash -c "./scripts/image release"

docker-image-mkimage-custom:
	@if [ -z "$(PROJECT)" ]; then echo "Usage: make docker-image-custom PROJECT=<project> [ARCH=<arch>] [DEVICE=<DEVICE>]"; exit 1; fi
	docker-compose run --rm \
		-e PROJECT=$(PROJECT) \
		$(if $(ARCH),-e ARCH=$(ARCH),) \
		$(if $(DEVICE),-e DEVICE=$(DEVICE),) \
		lakka-builder /bin/bash -c "./scripts/image mkimage"

# Docker build for Switch platform specifically  
docker-image-switch:
	docker-compose run --rm \
		-e PROJECT=L4T \
		-e ARCH=aarch64 \
		-e DEVICE=Switch \
		lakka-builder /bin/bash -c "./scripts/image"

docker-image-release-switch:
	docker-compose run --rm \
		-e PROJECT=L4T \
		-e ARCH=aarch64 \
		-e DEVICE=Switch \
		lakka-builder /bin/bash -c "./scripts/image release"

docker-image-mkimage-switch:
	docker-compose run --rm \
		-e PROJECT=L4T \
		-e ARCH=aarch64 \
		-e DEVICE=Switch \
		lakka-builder /bin/bash -c "./scripts/image mkimage"

# Docker build with clean
docker-image-clean:
	docker-compose run --rm lakka-builder /bin/bash -c "./scripts/clean && ./scripts/image"

# Rebuild Docker image (use when source code changes)
docker-rebuild:
	docker-compose build --no-cache lakka-builder
	