FROM nginx:mainline-alpine
RUN rm /etc/nginx/conf.d/*
ARG GITHUB_TOKEN
RUN bin/echo -e "GITHUB_TOKEN"
RUN bin/echo -e $GITHUB_TOKEN
ADD test/helloworld.conf /etc/nginx/conf.d/
ADD test/index.html /usr/share/nginx/html/
