FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Download the time freeze agent
ADD https://keploy-enterprise.s3.us-west-2.amazonaws.com/releases/latest/assets/go_freeze_time_amd64 /lib/keploy/go_freeze_time_amd64

# Set permissions
RUN chmod +x /lib/keploy/go_freeze_time_amd64

# Run the binary
RUN /lib/keploy/go_freeze_time_amd64

# Build with faketime tag
RUN go build -tags=faketime -o jwt-go-demo .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/jwt-go-demo .
EXPOSE 8080
ENV PORT=8080
CMD ["./jwt-go-demo"]
