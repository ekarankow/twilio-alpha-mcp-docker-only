FROM node:20-alpine

WORKDIR /app

# Install the Twilio MCP package
RUN npm install -g @twilio-alpha/mcp

# Set environment variables for production
ENV NODE_ENV=production
ENV TWILIO_ACCOUNT_SID=SID
ENV TWILIO_API_KEY=KEY
ENV TWILIO_API_SECRET=SECRET

# Create a non-root user for security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 mcp && \
    chown -R mcp:nodejs /app

# Run the MCP server in stdio mode
#CMD npx -y @twilio-alpha/mcp "$TWILIO_ACCOUNT_SID/$TWILIO_API_KEY:$TWILIO_API_SECRET"
# Create entrypoint script
#RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
#    echo 'set -e' >> /app/entrypoint.sh && \
#    echo 'echo "Starting Twilio MCP with account: $TWILIO_ACCOUNT_SID"' >> /app/entrypoint.sh && \
#    echo 'exec npx -y @twilio-alpha/mcp "$TWILIO_ACCOUNT_SID/$TWILIO_API_KEY:$TWILIO_API_SECRET"' >> /app/entrypoint.sh && \
#    chmod +x /app/entrypoint.sh && \
#    chown -R mcp:nodejs /app
# Create entrypoint script with conditional tags

RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'echo "Starting Twilio MCP with account: $TWILIO_ACCOUNT_SID"' >> /app/entrypoint.sh && \
    echo 'CMD_ARGS="$TWILIO_ACCOUNT_SID/$TWILIO_API_KEY:$TWILIO_API_SECRET"' >> /app/entrypoint.sh && \
    echo 'if [ -n "$TWILIO_TAGS" ]; then' >> /app/entrypoint.sh && \
    echo '  CMD_ARGS="$CMD_ARGS --tags $TWILIO_TAGS"' >> /app/entrypoint.sh && \
    echo 'fi' >> /app/entrypoint.sh && \
    echo 'if [ -n "$TWILIO_SERVICES" ]; then' >> /app/entrypoint.sh && \
    echo '  CMD_ARGS="$CMD_ARGS --services $TWILIO_SERVICES"' >> /app/entrypoint.sh && \
    echo 'fi' >> /app/entrypoint.sh && \
    echo 'exec npx -y @twilio-alpha/mcp $CMD_ARGS' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R mcp:nodejs /app
USER mcp

ENTRYPOINT ["/app/entrypoint.sh"]