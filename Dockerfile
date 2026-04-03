FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our template config
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Copy site files
COPY *.html /usr/share/nginx/html/

# Railway sets $PORT dynamically — nginx:alpine auto-substitutes
# environment variables in .template files
CMD ["nginx", "-g", "daemon off;"]
