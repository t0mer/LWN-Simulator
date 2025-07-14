# Stage 1: Builder
FROM golang:1.21 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    make \
    git

# Install statik tool (needed for UI embedding)
RUN go install github.com/rakyll/statik@latest

# Add statik to PATH
ENV PATH="/go/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy project files
COPY . .


RUN make install-dep

RUN make build

# Stage 2: Runtime image
FROM golang:1.21

WORKDIR /app

# Copy compiled files from the builder
COPY --from=builder /app .

# Expose app port (adjust if needed)
EXPOSE 8000

# Start the application
CMD ["./bin/lwnsimulator"]
