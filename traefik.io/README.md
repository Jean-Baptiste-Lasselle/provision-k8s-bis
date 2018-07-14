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


# Portotype d'application à développer

Développer une application typique, avec architecture suggérée par traefik


* [api.domain.com][api.kytes.io] permet d'accéder à l'API depuis internet
* [domain.com/web][kytes.io/web] permet d'accéder au micro service qui sert le client Angular 5 [ CORS, et appli angular qui appelle directement le back officer? d'après le schema d'architecture, il n'y aurait pas d'autre raison pour laquelle le back-office devrait être accessible de l'extérieur]
* [backoffice.domain.com][backoffice.kytes.io] pointera vers le endpoint de la couche métier, et sera load-balancée, avec un replicaSet que l'on scalera de 2 à 7.


![architecture](https://github.com/Jean-Baptiste-Lasselle/provision-k8s-bis/raw/master/images/traefik/architecture.png)

et:

![internals](https://github.com/Jean-Baptiste-Lasselle/provision-k8s-bis/raw/master/images/traefik/internnal.png)


voilà.
