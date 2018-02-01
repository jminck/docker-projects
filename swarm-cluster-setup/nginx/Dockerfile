# docker build -t reverseproxy /path/to/directory/with/dockerfile
# docker service create --replicas 5 -p 8080:80 --name nginx nginx:alpine
# docker service create --replicas 5 -p 8000-8001:8000-8001 --name reverseproxy reverseproxy

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
