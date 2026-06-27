include .env
export 

export PROJECT_ROOT=${CURDIR}

env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose up todoapp-postgres

env-cleanup:
	@docker run --rm -it -v $(CURDIR):/app -v /var/run/docker.sock:/var/run/docker.sock docker sh /app/cleanup.sh

env-port-forward:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder

migrate-create:
ifndef seq
	$(error Required parameter is missing 'seq'. Example: make migrate-create seq=init)
endif
	@docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

migrate-up:
	make migrate-action action=up

migrate-down:
	make migrate-action action=down

migrate-action:
ifndef action
	$(error Required parameter is missing 'action'. Example: make migrate-action action=up)
endif
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		"$(action)"
