############################################################################################
# kubectl
############################################################################################
list_clusters:
	kubectl config get-clusters
current_cluster:
	kubectl config current-context
set_cluster:
	kubectl config use-context minikube
############################################################################################
# 
############################################################################################
install_istio:
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

dashboard_kiali:
	istioctl dashboard kiali

create_cluster_k3d:
	k3d cluster create -p "8000:30000@loadbalancer" --agents 2

# checar o servicecle
send_traffic:
	while true;do curl http://localhost:8000; echo; sleep 0.5; done;

entrar_no_nod:
	kubectl exec -it nginx-6c9d4d964d-bdjgf -- bash

entrar_no_nod2:
	export APP_POD=$$(kubectl get pods -l app=nginx -o 'jsonpath={.items[0].metadata.name}')
	echo $$APP_POD
	kubectl exec -it "$$APP_POD" -- bash

create_deploy_svc_fortio:
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/httpbin/sample-client/fortio-deploy.yaml
set_FORTIO_POD:
	export FORTIO_POD=$(kubectl get pods -l app=fortio -o 'jsonpath={.items[0].metadata.name}')

send_traffic_fortio_time:
	kubectl exec "$FORTIO_POD" -c fortio -- fortio load -c 2 -qps 0 -t 200s -loglevel Warning http://nginx-service:8000

send_traffic_fortio_number:
	kubectl exec "$FORTIO_POD" -c fortio -- fortio load -c 2 -qps 0 -n 200 -loglevel Warning http://nginx-service:8000

send_traffic_fortio_servicex:
	kubectl exec "$FORTIO_POD" -c fortio -- fortio load -c 2 -qps 0 -n 20 -loglevel Warning http://servicex-service



delete_all:
	kubectl delete svc nginx-service
	kubectl delete svc fortio
	kubectl delete deploy nginx
	kubectl delete deploy nginx-b
	kubectl delete deploy fortio
	kubectl delete VirtualService nginx-vs
	kubectl delete DestinationRule nginx-dr

get_all:
	kubectl get svc
	kubectl get deploy
	kubectl get VirtualService
	kubectl get DestinationRule