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


proto: ## Generate proto files
	protoc pkg/**/pb/*.proto --go_out=:. --go-grpc_out=:. 
	# --go_out=./client --go-grpc_out=./client

server: ## Run server
	go run cmd/main.go


# https://stackoverflow.com/questions/71777702/service-compiling-successfully-but-message-structs-not-generating-grpc-go