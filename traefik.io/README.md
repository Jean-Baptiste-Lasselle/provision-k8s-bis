# Utilisation

Ref:

https://docs.traefik.io/configuration/backends/kubernetes/
https://docs.traefik.io/user-guide/kubernetes/

## Provison Traefik

### Etape 1 Configurer un Role RBAC pour l'utilisateur Traefik

Avec la CLI, depuis votre poste opérateur, exécuter le commande: 

```
export URI_FICHIER_CONF=https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
export FICHIER_CONF_LOCAL=./traefik-rbac.yaml
if [ -f $FICHIER_CONF_LOCAL ]; then rm $FICHIER_CONF_LOCAL; else echo "Téléchargement du fichier [$FICHIER_CONF_LOCAL] ..."; fi
curl -o $FICHIER_CONF_LOCAL $URI_FICHIER_CONF
./kubectl apply -f ./traefik-rbac.yaml
```

### Etape 2: Déploiement de Traefik

Soit avec la CLI: 

```
export URI_FICHIER_CONF=https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-deployment.yaml
export FICHIER_CONF_LOCAL=./traefik-deployment.yaml
if [ -f $FICHIER_CONF_LOCAL ]; then rm $FICHIER_CONF_LOCAL; else echo "Téléchargement du fichier [$FICHIER_CONF_LOCAL] ..."; fi
curl -o $FICHIER_CONF_LOCAL $URI_FICHIER_CONF
./kubectl apply -f $FICHIER_CONF_LOCAL
```


Avec le Dashboard graphique, copiez-collez la configuration yaml ci-dessous, du déploiement de Traefik: 

```
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
---
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
  labels:
    k8s-app: traefik-ingress-lb
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: traefik-ingress-lb
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      containers:
      - image: traefik
        name: traefik-ingress-lb
        ports:
        - name: http
          containerPort: 80
        - name: admin
          containerPort: 8080
        args:
        - --api
        - --kubernetes
        - --logLevel=INFO
---
kind: Service
apiVersion: v1
metadata:
  name: traefik-ingress-service
  namespace: kube-system
spec:
  selector:
    k8s-app: traefik-ingress-lb
  ports:
    - protocol: TCP
      port: 80
      name: web
    - protocol: TCP
      port: 8080
      name: admin
  type: NodePort
```


```
export NOM_DU_POD1=salut-kytes-io-86cddf59d5-lz6vv
export NOM_DU_POD2=salut-kytes-io-86cddf59d5-r25n6

./kubectl exec $NOM_DU_POD2 -- printenv | grep SERVICE
./kubectl exec $NOM_DU_POD1 -- printenv | grep SERVICE

# ce qui afichera la liste des variables d'environnements pour chaque pod.
```


## "Décomission"  Traefik



## Exploitation  Traefik


### Ops Std


# Reprise 

https://docs.traefik.io/user-guide/kubernetes/

https://medium.com/@carlosedp/multiple-traefik-ingresses-with-letsencrypt-https-certificates-on-kubernetes-b590550280cf

https://medium.com/@Oskarr3/setting-up-ingress-on-minikube-6ae825e98f82

# Portotype d'application à développer

Développer une application typique, avec architecture suggérée par traefik


* [api.domain.com][api.kytes.io] permet d'accéder à l'API depuis internet
* [domain.com/web][kytes.io/web] permet d'accéder au micro service qui sert le client Angular 5 [ CORS, et appli angular qui appelle directement le back officer? d'après le schema d'architecture, il n'y aurait pas d'autre raison pour laquelle le back-office devrait être accessible de l'extérieur]
* [backoffice.domain.com][backoffice.kytes.io] pointera vers le endpoint de la couche métier, et sera load-balancée, avec un replicaSet que l'on scalera de 2 à 7.


![architecture](https://github.com/Jean-Baptiste-Lasselle/provision-k8s-bis/raw/master/images/traefik/architecture.png)

et:

![internals](https://github.com/Jean-Baptiste-Lasselle/provision-k8s-bis/raw/master/images/traefik/internal.png)

# Dernières informatiosn obtenues


Après avori exécuté:

```
./deploiement-applis/trois/operations.sh
```

D'abord depuis l'hôte CentOS, je peux faire des ping d'adresses réseaux dans le réseau défininit par POD_NETWORK_CIDR, un paramètre de provision du cluster Kubernetes.

Ensuite, je peux utiliser la commande : 
```
kubectl get endpoints
```

et essayer de faire un curl de tus les endpoints répertoriés. Normalement , j'arrive à voir des URLs auxuquelles j'ai accès aux applis : 

```
[jbl@traefik-ui provision-test-k8s]$ curl 10.244.1.13
<html>
  <head>
    <style>
      html {
        background: url(./bg.png) no-repeat center center fixed;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
      }

      h1 {
        font-family: Arial, Helvetica, sans-serif;
        background: rgba(187, 187, 187, 0.5);
        width: 3em;
        padding: 0.5em 1em;
        margin: 1em;
      }
    </style>
  </head>
  <body>
    <h1>Stilton</h1>
  </body>
</html>

```

```
[jbl@traefik-ui provision-test-k8s]$ kubectl get endpoints --namespace=kube-system
NAME                      ENDPOINTS                                               AGE
kube-controller-manager   <none>                                                  2h
kube-dns                  10.244.0.4:53,10.244.0.5:53,10.244.0.4:53 + 1 more...   2h
kube-scheduler            <none>                                                  2h
traefik-ingress-service   10.244.1.7:80,10.244.1.7:8080                           1h
traefik-web-ui            10.244.1.7:8080                                         1h
[jbl@traefik-ui provision-test-k8s]$ curl 10.244.1.7:8080
<a href="/dashboard/">Found</a>.

```


```
[jbl@traefik-ui provision-test-k8s]$ kubectl get endpoints
NAME                                           ENDPOINTS                         AGE
cheddar                                        10.244.1.11:80,10.244.1.14:80     1h
kubernetes                                     192.168.1.21:6443                 2h
salut-kytes-io-k8service-to-load-balance-b8b   10.244.1.8:8080,10.244.1.9:8080   1h
stilton                                        10.244.1.10:80,10.244.1.13:80     1h
wensleydale                                    10.244.1.12:80,10.244.1.15:80     1h
[jbl@traefik-ui provision-test-k8s]$ ip addr|grep  10.
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:63:a0:10 brd ff:ff:ff:ff:ff:ff
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
5: enp0s10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.244.0.0/32 scope global flannel.1
8: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    inet 10.244.0.1/24 scope global cni0
10: vethc55a308c@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue master cni0 state UP group default
[jbl@traefik-ui provision-test-k8s]$

```