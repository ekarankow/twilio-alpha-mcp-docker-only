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

USER mcp

# Run the MCP server in stdio mode
CMD npx -y @twilio-alpha/mcp "$TWILIO_ACCOUNT_SID/$TWILIO_API_KEY:$TWILIO_API_SECRET"