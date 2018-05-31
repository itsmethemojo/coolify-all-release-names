CONTAINER_NAME=release-namer
IMAGE_NAME=release-namer

.PHONY: all
all: run

.PHONY: clean
clean:
	docker stop $(CONTAINER_NAME) || true; \
	docker rm $(CONTAINER_NAME) || true

.PHONY: run
run: docker-build
run:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) -p3000:3000 $(IMAGE_NAME) bash -c 'cd /app; bundle install --path vendor/cache; bin/rails server -P /tmp/rails-pid'

.PHONY: build
build: docker-build
build:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) -p3000:3000 $(IMAGE_NAME) bash -c 'cd /app; bundle install --path vendor/cache'

.PHONY: docker-build
docker-build: clean
docker-build:
	docker build -t $(IMAGE_NAME) .
