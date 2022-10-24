# Microservices in Go using gRPC

This repository contains a set of examples of microservices written in Go using gRPC to communicate between them. Here we deploy the services using a simple `docker-compose` setup, with each service running in its own container. Here are the individual services:

- https://github.com/mkm29/go-grpc-product-svc - Product SVC (gRPC)
- https://github.com/mkm29/go-grpc-order-svc - Order SVC (gRPC)
- https://github.com/mkm29/go-grpc-auth-svc - Authentication SVC (gRPC)
- https://github.com/mkm29/go-grpc-api-gateway - API Gateway (HTTP)

## Authentication

Since most endpoints are protected, we need to authenticate the user before allowing them to access the endpoints. We use a simple JWT-based authentication mechanism. The authentication service is responsible for registering users (just using `bcrypt` to hash passwords for now), logging is users (generating a JWT token), as well as validating the token.

### Register

```bash
curl -X POST \
  http://localhost:3000/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "mitch@murphy.com",
  "password": "password"
}'
```

### Login

```bash
RES=`curl -X POST \
  http://localhost:3000/auth/login \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "mitch@murphy.com",
  "password": "password"
}'`
```

Get and save the token: 

```bash
TOKEN=`echo $RES | jq -r .token`
```

## Product Service

### Create a product

```bash
curl --request POST \
  --url http://localhost:3000/product/ \
  --header "Authorization: Bearer $TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
 "name": "Product A",
 "stock": 5,
 "price": 15
}'
```

### Get a product

```bash
curl --request GET \
  --url http://localhost:3000/product/1 \
  --header "Authorization: Bearer $TOKEN"
```

## Order Service

### Create an Order

```bash
curl --request POST \
  --url http://localhost:3000/order \
  --header "Authorization: Bearer $TOKEN" \
  --header 'Content-Type: application/json' \
  --data '{
 "productId": 1,
 "quantity": 1
}'
```