.DEFAULT_GOAL := help

help: ## Show this help
	@echo -e '\n Usage:'
	@echo 'make <target>'
	@echo
	@echo ' Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

all: home-automation media-server system-monitor system-utils applications ## Create all containers

down: ## Stop and remove all containers
	@echo -e '\n==> Stopping all containers\n'
	@docker compose -p home-automation -f stacks/home-automation.yml down
	@docker compose -p media-server -f stacks/media-server.yml down
	@docker compose -p system-monitor -f stacks/system-monitor.yml down
	@docker compose -p system-utils -f stacks/system-utils.yml down
	@docker compose -p applications -f stacks/applications.yml down

uap: update all prune ## Update, recreate and prune all containers

home-automation: ## Create home automation containers
	@echo -e '\n==> Creating Home Automation containers\n'
	@docker compose -p home-automation -f stacks/home-automation.yml up -d --remove-orphans --force-recreate

media-server: ## Create media server containers
	@echo -e '\n==> Creating Media Server containers\n'
	@docker compose -p media-server -f stacks/media-server.yml up -d --remove-orphans --force-recreate

system-monitor: ## Create system monitor containers
	@echo -e '\n==> Creating System Monitor containers\n'
	@docker compose -p system-monitor -f stacks/system-monitor.yml up -d --remove-orphans --force-recreate

system-utils: ## Create system utils containers
	@echo -e '\n==> Creating System Utils containers\n'
	@docker compose -p system-utils -f stacks/system-utils.yml up -d --remove-orphans --force-recreate

applications: ## Create applications containers
	@echo -e '\n==> Creating Applications containers\n'
	@docker compose -p applications -f stacks/applications.yml up -d --remove-orphans --force-recreate

create-retention: ## Create retention policy for telegraf influx database
	@echo -e '\n==> Adding retention policy for telegraf db\n'
	@curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE RETENTION POLICY "one_week_only" ON "telegraf" DURATION $(DUR) REPLICATION 1 DEFAULT"

update: ## Update images
	@echo -e '\n==> Updating images'
	@docker compose -p home-automation -f stacks/home-automation.yml pull
	@docker compose -p media-server -f stacks/media-server.yml pull
	@docker compose -p system-monitor -f stacks/system-monitor.yml pull
	@docker compose -p system-utils -f stacks/system-utils.yml pull
	@docker compose -p applications -f stacks/applications.yml pull

prune: ## Prune dangling images
	@echo -e '\n==> Pruning images\n'
	@docker image prune -f
