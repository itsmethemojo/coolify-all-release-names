CONTAINER_NAME=release-namer
IMAGE_NAME=release-namer

.PHONY: help
all:
	echo "\n\navailable targets:\n"; \
	echo $$(cat $$(pwd)/Makefile | grep '.PHONY: ' | grep -v '(' | awk '{print $$2}') | tr " " "\n"

.PHONY: clean
clean:
	docker stop $(CONTAINER_NAME) || true; \
	docker rm $(CONTAINER_NAME) || true

.PHONY: start-local-redis
start-local-redis:
	@if [ "$$(docker ps | grep local-redis-$(CONTAINER_NAME) | wc -l)" = "0" ]; then\
		docker run --name local-redis-$(CONTAINER_NAME) -d redis;\
	fi

.PHONY: stop-local-redis
stop-local-redis:
	docker stop local-redis-$(CONTAINER_NAME) || true; \
	docker rm local-redis-$(CONTAINER_NAME) || true

.PHONY: run
run: start-local-redis docker-build
run:
	docker run -d -v$$(pwd):/app --name $(CONTAINER_NAME) -p3000:3000 --link local-redis-$(CONTAINER_NAME):redis -e REDIS_URL='redis://redis:6379' $(IMAGE_NAME) bash -c 'ruby app/server.rb -p 3000 -o 0.0.0.0 -e development'

.PHONY: logs
logs:
	docker logs -f $(CONTAINER_NAME)

.PHONY: test
test: docker-build
test:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'tests/runner.sh tests/unit && rubocop src test app/server.rb'

.PHONY: unit-test
unit-test: docker-build
unit-test:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'tests/runner.sh tests/unit'

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
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'rubocop src tests app'

.PHONY: fix-checkstyle
fix-checkstyle: docker-build
fix-checkstyle:
	docker run -it -v$$(pwd):/app --name $(CONTAINER_NAME) $(IMAGE_NAME) bash -c 'rubocop -a src tests app'
