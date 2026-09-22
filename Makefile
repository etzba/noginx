NAME ?= noginx
TAG ?= latest
REPO ?= etzba/${NAME}

all: test up exec down

# docker
up:
	docker-compose down
	docker-compose up -d noginx

down:
	docker-compose down 

cleanup:
	docker rm $$(docker stop $$(docker ps -a -q --filter ancestor=etzba/noginx:latest --format="{{.ID}}"))

# run container
.PHONY: docker-run
docker-run:
	docker run -t --rm  ${REPO}:${TAG}

# build \ push to dockerhub
.PHONY: docker-build
docker-build:
	docker build -t ${REPO}:${TAG} .

.PHONY: docker-push
docker-push:
	docker push ${REPO}:${TAG}

# install or upgrade helm in kubernetes
install:
	helm install ${NAME} chart/ -n ${NAME} --create-namespace

upgrade:
	helm upgrade --install ${NAME} chart/ -n ${NAME}

remove:
	kubectl delete ns ${NAME}