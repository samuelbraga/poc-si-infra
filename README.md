# poc-si-infra
Code base for implementing the infrastructure used in a POC in Information Systems


aws eks update-kubeconfig --region sa-east-1 --name poc-dev

kubectl apply -f <folder> -n namespace


kubectl run nginx --image=nginx --namespace application
kubectl exec nginx --namespace application -i -t -- bash


apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: required-mtls-auth
spec:
  mtls:
    mode: PERMISSIVE

apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: required-mtls-auth
spec:
  mtls:
    mode: STRICT