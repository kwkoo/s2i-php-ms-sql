PHONY: all build push

all: build push

build:
	docker build -t ghcr.io/kwkoo/s2i-php-ms-sql:7.3 .

push:
	docker push ghcr.io/kwkoo/s2i-php-ms-sql:7.3