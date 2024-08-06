FROM nginx:alpine

# Remove the default NGINX welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy the index.html, imgs, styles, js file to the NGINX document root
COPY index.html /usr/share/nginx/html/
COPY images/ /usr/share/nginx/html/images/
COPY main.js /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
