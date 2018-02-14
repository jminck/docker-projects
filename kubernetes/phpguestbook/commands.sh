wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/redis-master-deployment.yaml
wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/redis-master-service.yaml
wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/redis-slave-deployment.yaml
wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/redis-slave-service.yaml
wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/frontend-deployment.yaml
wget https://kubernetes.io/docs/tutorials/stateless-application/guestbook/frontend-service.yaml

kubectl apply -f redis-master-deployment.yaml
kubectl get pods
kubectl apply -f redis-master-service.yaml
kubectl get service
kubectl apply -f redis-slave-deployment.yaml
kubectl get pods
kubectl apply -f redis-slave-service.yaml
kubectl get services
kubectl apply -f frontend-deployment.yaml
kubectl get pods -l app=guestbook -l tier=frontend
kubectl apply -f frontend-service.yaml
kubectl get services
minikube service frontend --url
kubectl get service frontend
kubectl scale deployment frontend --replicas=5
kubectl get pods
kubectl scale deployment frontend --replicas=2
kubectl get pods

read -t5 -n1 -r -p 'deployment will be deleted in five seconds...' key

kubectl delete deployment -l app=redis
kubectl delete service -l app=redis
kubectl delete deployment -l app=guestbook
kubectl delete service -l app=guestbook
