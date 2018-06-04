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
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) -p3000:3000 $(IMAGE_NAME) bash -c 'bin/rails server -P /tmp/rails-pid'

.PHONY: test
test: docker-build
test:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'bin/rails test test/unit && rubocop app test'

.PHONY: unit-test
unit-test: docker-build
unit-test:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'bin/rails test test/unit'

.PHONY: docker-build
docker-build: clean
docker-build:
	docker build -t $(IMAGE_NAME) .

.PHONY: build
build: docker-build
build:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'bundle install --system && gem list'

.PHONY: checkstyle
checkstyle: docker-build
checkstyle:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'rubocop app test'

.PHONY: fix-checkstyle
fix-checkstyle: docker-build
fix-checkstyle:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'rubocop -a app test'
