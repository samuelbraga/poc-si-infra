# Implementação do Istio em EKS com Terraform

Este projeto fornece uma implementação do Istio em um cluster Kubernetes da Amazon EKS utilizando Terraform. A configuração permite que você configure rapidamente um ambiente de microsserviços com as funcionalidades avançadas que o Istio oferece, como gerenciamento de tráfego, segurança e observabilidade.

## Índice

- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração do EKS](#configuração-do-eks)
- [Instalação do Istio](#instalação-do-istio)
- [Verificação da Instalação](#verificação-da-instalação)
- [Uso](#uso)
- [TLS](#tls)
- [Monitoramento](#monitoramento)

## Pré-requisitos

Antes de começar, verifique se você possui os seguintes pré-requisitos:

- Conta da AWS com permissões para criar EKS, VPCs e IAM roles.
- [Terraform](https://www.terraform.io/downloads.html) instalado na sua máquina local.
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) instalado para interagir com o cluster Kubernetes.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) instalado e configurado com suas credenciais.

## Instalação

1. Clone o repositório:

   ```bash
   git clone https://github.com/samuelbraga/poc-si-infra.git
   cd poc-si-infra/terraform
   ```
2. Crie um arquivo backend.config contendo as informações do seu [remote state](https://developer.hashicorp.com/terraform/language/state/remote)

```
bucket = "bucket"
key    = "file.tfstate"
region = "region"
```
2. Configure as variáveis no arquivo `variables.tf` de acordo com suas necessidades.

3. Inicialize o Terraform:

   ```bash
   terraform init -backend-config=backend.config
   ```

4. Verifique o que será criado:

   ```bash
   terraform plan
   ```

5. Aplique a configuração do Terraform:

   ```bash
   terraform apply
   ```

## Configuração do EKS

Após a criação do cluster EKS, configure o `kubectl` para usar o contexto do cluster:

```bash
aws eks --region <sua-região> update-kubeconfig --name <nome-do-cluster>
```

Substitua `<sua-região>` e `<nome-do-cluster>` pelos valores apropriados.

## Verificação da Instalação

Verifique se todos os pods do Istio estão em execução:

```bash
kubectl get pods -n istio-system
```

Você deve ver os pods `istiod` e `istio-ingressgateway` em estado `Running`.

## Uso

Para testar a configuração, você pode implantar nossa estrutura que esta na pasta kubernetes:

```bash
cd poc-si-infra/kubernetes
```
Estrutura de monitoramento:
```bash
kubectl apply -f monitoring
```

Aplicativo:
```bash
kubectl apply -f application -n application
```

Verifique se os serviços estão expostos e se o aplicativo está acessível através do Ingress Gateway.

```bash
kubectl get svc -n application
```

Agora, pegue o endereço do load balance provisionado e altere nas variáveis de ambiente do arquivo [application.yaml](https://github.com/samuelbraga/poc-si-infra/blob/main/kubernetes/application/application.yaml#L164). Assim, o load generator irá gerar uma massa de dados para que você consiga validar seus testes.

## TLS

Você pode testar a conectividade restrita ao TLS. Basta subir dois containers [NGINX](https://nginx.org/). E realizar uma chamada curl simples para o serviço frontend. Um container você pode subir no namespace default e outro no namespace da aplicação 

```bash
kubectl run nginx --image=nginx --namespace default
```
Para entrar no container
```bash
kubectl exec nginx --namespace default -i -t -- bash
```

```bash
kubectl run nginx --image=nginx --namespace application
```
Para entrar no container
```bash
kubectl exec nginx --namespace application -i -t -- bash
```

Ao realizar a chamada curl:
```bash
curl curl http://frontend-external.application.svc.cluster.local
```

Vamos perceber que com a regra permissiva todas as chamadas retornam 200

Ao alterar a permissividade no arquivo [istio.yaml](https://github.com/samuelbraga/poc-si-infra/blob/main/kubernetes/application/istio.yaml#L93)
para strict:

```bash
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: required-mtls-auth
spec:
  mtls:
    mode: STRICT
```
Faremos novamente os testes nos container nginx e veremos como essa restrição consegue ser efetiva na nossa malha de serivços.

## Monitoramento:

Podemos utilizar o kubectl port-forward para criar tuneis dos serviços na nossa máquina, e assim, acessar os serviços de monitoramento

```bash
kubectl port-forward svc/grafana -n istio-system 3000:3000
kubectl port-forward svc/tracing -n istio-system 20080:80
kubectl port-forward svc/kiali -n istio-system 20001:20001

http://localhost:3000
http://localhost:20080
http://localhost:20001
```

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests. 
