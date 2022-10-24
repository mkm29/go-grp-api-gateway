package routes

import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/mkm29/go-grp-api-gateway/gen/proto/go/pkg/auth/pb"
)

type LoginRequestBody struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func Login(ctx *gin.Context, c pb.AuthServiceClient) {
	body := LoginRequestBody{}

	if err := ctx.BindJSON(&body); err != nil {
		ctx.AbortWithError(http.StatusBadRequest, err)
		return
	}

	res, err := c.Login(context.Background(), &pb.LoginRequest{
		Email:    body.Email,
		Password: body.Password,
	})

	if err != nil {
		ctx.AbortWithError(http.StatusBadGateway, err)
		return
	}
	// return response
	ctx.JSON(int(res.Status), &res)
}
