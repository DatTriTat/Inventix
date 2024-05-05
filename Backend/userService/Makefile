all: clean

clean:
	mvn clean

compile:
	mvn compile

build: compile
	mvn package

run: build
	echo Starting Spring at:  http://localhost:8080
	java -jar target/userService-0.1.jar 

# MySQL DB

docker-run:
	docker run --name service-registry -td -p 8761:8761 service-registry

mysql:
	docker run -d --network inventix-network --name mysql -td -p 3306:3306 -e MYSQL_ROOT_PASSWORD=data mysql:8.0

mysql-shell:
	docker exec -it mysql bash 


docker-clean:
	docker stop service-registry
	docker rm service-registry
	docker rmi service-registry

docker-shell:
	docker exec -it service-registry bash 

docker-push:
	mvn package
	docker login
	docker build -t dattritat/service-registry:v0.1 .
	docker push dattritat/service-registry:v0.1

# Compose

network-ls:
	docker network ls 

network-create:
	docker network create --driver bridge inventix-network

network-prune:
	docker network prune

compose-up:
	docker-compose up --scale starbucks=2 -d

lb-up:
	docker-compose up -d lb 

starbucks-up:
	docker-compose up -d starbucks

mysql-up:
	docker-compose up -d mysql 

compose-down:
	docker-compose down 	

lb-stats:
	echo "user = admin | password = admin"
	open http://localhost:1936

lb-test:
	open http://localhost


# Pod

pod-run:
	kubectl apply -f pod.yaml

pod-list:
	kubectl get pods

pod-desc:
	kubectl describe pods service-registry

pod-delete:
	kubectl delete -f pod.yaml

pod-shell:
	kubectl exec -it service-registry -- /bin/bash

pod-logs:
	kubectl logs -f service-registry

# Deployment

deployment-create:
	kubectl create -f deployment.yaml --save-config 

deployment-get:
	kubectl get deployments

deployment-get-pods:
	kubectl get pods -l name=service-registry

deployment-pod-shell:
	kubectl exec -it $(pod) -- /bin/bash

deployment-upgrade:
	kubectl apply  -f deployment.yaml

deployment-delete:
	kubectl delete deployment service-registry-deployment

# Service

service-create:
	kubectl create -f service.yaml

service-get:
	kubectl get services

service-get-ip:
	kubectl get service service-registry -o wide

service-delete:
	kubectl delete service service-registry

# Ingress

ingress-apply:
	kubectl apply -f ingress.yaml

ingress-ip:
	kubectl get ingress service-registry-ingress
