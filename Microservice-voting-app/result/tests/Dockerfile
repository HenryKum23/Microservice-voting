FROM alpine:latest

# Install only what's needed
RUN apk add --no-cache \
    bash \
    curl

WORKDIR /app

# Copy test script
COPY test.sh .

# Make executable
RUN chmod +x test.sh

# Run tests
CMD ["./test.sh"]