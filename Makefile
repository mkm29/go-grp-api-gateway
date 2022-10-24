PROJECT=go-grp-api-gateway
GH_USER=mkm29

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

init: ## Initialize the project
	@echo "Initializing the project"
	@go mod init $(GH_USER)/$(PROJECT)

bootstrap: ## Setup project
	go get google.golang.org/protobuf
	go get github.com/gin-gonic/gin
	go get github.com/spf13/viper
	go get google.golang.org/grpc
	mkdir -p cmd pkg/config/envs pkg/auth/pb pkg/auth/routes pkg/order/pb pkg/order/routes pkg/product/pb pkg/product/routes
	touch cmd/main.go pkg/config/envs/dev.env pkg/config/config.go
	touch pkg/auth/pb/auth.proto pkg/auth/routes/login.go pkg/auth/routes/register.go pkg/auth/client.go pkg/auth/middleware.go pkg/auth/routes.go
	touch pkg/product/pb/product.proto pkg/product/routes/create_product.go pkg/product/routes/find_one.go pkg/product/client.go pkg/product/routes.go
	touch pkg/order/pb/order.proto pkg/order/routes/create_order.go pkg/order/client.go pkg/product/routes.go

start_database: ## Start the database
	docker run -p 15432:5432 -e POSTGRES_PASSWORD=password -d --name postgres postgres

stop_database: ## Stop the database
	docker stop postgres

remove_database: ## Remove the database
	docker rm postgres

create_database: ## Create the database
	docker exec -it postgres psql -U postgres -c "CREATE DATABASE auth_svc; CREATE DATABASE product_svc; CREATE DATABASE order_svc;"

build: ## Build the project
	@echo "Building the project"
	@CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app ./cmd/main.go

proto: ## Generate proto files
  buf generate
	# protoc pkg/**/pb/*.proto --go_out=:. --go-grpc_out=:. 

server: ## Run server
	go run cmd/main.go


# https://stackoverflow.com/questions/71777702/service-compiling-successfully-but-message-structs-not-generating-grpc-go