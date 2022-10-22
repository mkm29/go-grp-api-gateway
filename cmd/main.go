package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/mkm29/go-grp-api-gateway/pkg/auth"
	"github.com/mkm29/go-grp-api-gateway/pkg/config"
	"github.com/mkm29/go-grp-api-gateway/pkg/order"
	"github.com/mkm29/go-grp-api-gateway/pkg/product"
)

func main() {
	// load config
	c, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("failed to load config: %v", err)
	}

	r := gin.Default()

	authSvc := *auth.RegisterRoutes(r, &c)
	product.RegisterRoutes(r, &c, &authSvc)
	order.RegisterRoutes(r, &c, &authSvc)

	r.Run(c.Port)
}
