IMAGE_NAME = dnsmasq

default: help

help: ## Print help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build container
	docker build --rm -t $(IMAGE_NAME) .

run: ## Run service for test
	docker run --rm -d --cap-add=NET_ADMIN --add-host=my.internal:192.168.65.2 -p 53:53/tcp -p 53:53/udp $(IMAGE_NAME)

clean: ## Clean image
	docker rmi $(IMAGE_NAME)
