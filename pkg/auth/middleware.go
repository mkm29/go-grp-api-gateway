package auth

import (
	"context"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/mkm29/go-grp-api-gateway/gen/proto/go/pkg/auth/pb"
)

type AuthMiddlewareConfig struct {
	svc *ServiceClient
}

func InitAuthMiddleware(svc *ServiceClient) AuthMiddlewareConfig {
	return AuthMiddlewareConfig{
		svc: svc,
	}
}

func (c *AuthMiddlewareConfig) AuthRequired(ctx *gin.Context) {
	authorication := ctx.Request.Header.Get("authorization")
	if authorication == "" {
		ctx.AbortWithStatus(http.StatusUnauthorized)
		return
	}
	token := strings.Split(authorication, "Bearer ")
	if len(token) < 2 {
		ctx.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	res, err := c.svc.Client.Validate(context.Background(), &pb.ValidateRequest{
		Token: token[1],
	})

	if err != nil {
		ctx.AbortWithError(http.StatusUnauthorized, err)
		return
	}

	ctx.Set("userId", res.UserId)

	ctx.Next()
}
