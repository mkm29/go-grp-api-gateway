package product

import (
	"fmt"

	"github.com/mkm29/go-grp-api-gateway/gen/proto/go/pkg/product/pb"
	"github.com/mkm29/go-grp-api-gateway/pkg/config"

	"google.golang.org/grpc"
)

type ServiceClient struct {
	Client pb.ProductServiceClient
}

func InitServiceClient(c *config.Config) pb.ProductServiceClient {
	cc, err := grpc.Dial(c.ProductSvcUrl, grpc.WithInsecure())
	if err != nil {
		fmt.Printf("did not connect: %v", err)
	}
	return pb.NewProductServiceClient(cc)
}
