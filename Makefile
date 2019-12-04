default: help

help: ## Print help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build-all: ## Build all containers
	@make build-dnsmasq build-dnsclient

build-dnsmasq: ## Build dnsmasq container
	docker build --rm -f Dockerfile -t kunst1080/dnsmasq .

build-dnsclient: ## Build dnsclient container
	docker build --rm -f Dockerfile.dnsclient -t dnsclient .

up: ## Run services for test
	docker-compose up -d

down: ## Delete services for test
	docker-compose down

test: ## Run test
	rm -f test.actual
	docker-compose exec dnsclient dig +short aaa.localnet | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short test.localnet | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short extra.host | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short cname.test | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short hogehoge.test | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short other-container | tr -d '\r' | tee -a test.actual
	docker-compose exec dnsclient dig +short aaa.other-container.test | tr -d '\r' | tee -a test.actual
	diff test.actual test.expected && rm -f test.actual

clean: ## Clean image
	docker rmi -f dnsmasq dnsclient

