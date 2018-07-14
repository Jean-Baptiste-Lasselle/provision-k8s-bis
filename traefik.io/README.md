# Utilisation

## Provison Traefik

### etape 1 Configurer un Role RBAC pour l'utilisateur Traefik

Avec la CLI, depuis votre poste opérateur, exécuter le commande: 

```
export URI_FICHIER_CONF=https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
export FICHIER_CONF_LOCAL=./traefik-rbac.yaml
if [ -f $FICHIER_CONF_LOCAL ]; then rm $FICHIER_CONF_LOCAL; else echo "Téléchargement du fichier [$FICHIER_CONF_LOCAL] ..."; fi
curl -o $FICHIER_CONF_LOCAL $URI_FICHIER_CONF
./kubectl apply -f ./traefik-rbac.yaml
```

### etape 2: Déploiement de Traefik

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


