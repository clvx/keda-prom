APP=poddebug
REPOSITORY=clvx/${APP}
TAG=latest
CONTEXT=.
K8S=${APP}.yaml
K8S_TEMPLATE=k8s.tpl

install-prometheus:
	@kubectl create ns prom
	@helm repo add stable https://charts.helm.sh/stable --force-update
	@helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f k8s/01-prometheus.yaml -n prom

install-keda:
	@kubectl create ns keda
	@helm repo add kedacore https://kedacore.github.io/charts --force-update
	@helm install keda kedacore/keda --version 2.0.0 --namespace keda

install: install-prometheus install-keda

build:
	@docker build -t ${REPOSITORY}:${TAG} ${CONTEXT}

push:
	@docker push ${REPOSITORY}:${TAG}

configure:
	@sed 's%<image>%${REPOSITORY}:${TAG}%' ${K8S_TEMPLATE} > ${K8S}
	@sed -i 's%<app>%${APP}%' ${K8S}
	@sed -i 's%<containerPort>%3000%' ${K8S}

deploy:
	@kubectl apply -f ${K8S}
	@kubectl apply -f k8s/02-servicemonitor.yaml
	@kubectl apply -f k8s/03-scaledobject.yaml

proxy-app:
	@kubectl port-forward service/${APP}-service 8080:80

proxy-prom:
	@kubectl port-forward -n prom service/prometheus-kube-prometheus-prometheus 9090:909

test:
	@curl localhost:8080

load:
	@./hey -n 2000 http://localhost:8000 2> /dev/null || echo -n "hey is required: download it at https://github.com/rakyll/hey\nor sudo snap install hey"


.PHONY: .build .push .test .proxy .deploy

