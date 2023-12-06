FROM nginx:mainline-alpine
RUN rm /etc/nginx/conf.d/*
ADD test/helloworld.conf /etc/nginx/conf.d/
ADD test/index.html /usr/share/nginx/html/