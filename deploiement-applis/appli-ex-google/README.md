# Utilisation

## Déploiement du "hello world" Google


On suppose que l'on a fait le build d'une image Docker, que cette image est tagguée formations-k8s/image-application1:v1.0.0 , et

poussée sur un registry Docker privé accessible à l'URI host_ou_adresse_ip:no_port . Par exemple, le nom d'hôte réseau, et le nom de domaine du registry Docker chez Bosstek pourrait être: [docker-registry.kytes-io.net


### etape 1. Créer un déploiement

L'exécution des commandes ci-dessous:

    créée un “déploiement” , nommé salut-kytes-io . Vérifiez-le en exécutant ensuite ./kubectl get deployments
    créée un “Replica Set”, dont le nom est automatiquement généré, en concaténant le nom du déploiement (salut-kytes-io ), à un chiffre généré aléatoirement (un Hash). Vérifiez-le en exécutant ensuite ./kubectl get replicaSets.
    Au cours d'un de mes tests, par exemple, mon Replica Set a été nommé : “salut-kytes-io-86cddf59d5”
    Comme l'on a indiqué que l'on souhaite 2 répliques de ce service, deux pods sont automatiquement créés, et pour chacun d'entre eux, un nom est généré, en concaténant le nom du “Replica Set”, avec un nombre généré aléatoirement. Vérifiez-le en exécutant ensuite ./kubectl get pods
    Au cours d'un de mes tests, par exemple, mes 2 Pods ont été nommés : “salut-kytes-io-86cddf59d5-lz6vv” et “salut-kytes-io-86cddf59d5-r25n6”

```
export NOM_DU_DEPLOIEMENT=salut-kytes-io
export NOM_DU_LOAD_BALANCER=notre-petit-load-balancer
export NO_PORT_APPLICATIF=8080
export NOM_IMAGE=google-samples/node-hello
export NO_VERSION_IMAGE=1.0
# export REGISTRY_DOCKER_BOSSTEK_HOTE=docker-registry.kytes-io.net
export REGISTRY_DOCKER_BOSSTEK_HOTE=gcr.io
./kubectl run $NOM_DU_DEPLOIEMENT --replicas=2 --labels="run=$NOM_DU_LOAD_BALANCER" --image=$REGISTRY_DOCKER_BOSSTEK_HOTE/$NOM_IMAGE:$NO_VERSION_IMAGE --port=$NO_PORT_APPLICATIF
```
Analogie Docker: éclairons le NO_PORT_APPLICATIF. Pensez à docker run -p192.168.1.23:21776:9443 …. ici, 8080 correspond à 9443, et n'est donc pas le numéro de port externe par lequel on accédera à l'application

### etape 2. Créer un service, exposer le déploiement par ce service

On expose le déploiement, en lui attribuant un [service, au sens de Kubernetes](https://kubernetes.io/docs/concepts/services-networking/service/) : 
```
export NOM_DU_DEPLOIEMENT=salut-kytes-io
export NOM_DU_SERVICE_K8S=salut-kytes-io-k8service-to-load-balance-b8b
./kubectl expose deployment $NOM_DU_DEPLOIEMENT --type=NodePort --name=$NOM_DU_SERVICE_K8S
```

### etape 3. Accéder à l'application déployée, par les Nodes

Récupérer le numéro de port via lequel l'application sera disponible: 

```
export NOM_DU_DEPLOIEMENT=salut-kytes-io
./kubectl describe services $NOM_DU_DEPLOIEMENT | grep NodePort
```

Et accédez à l'application de la manière suivante: 


```
export ADRESSE_IP_WORKER_1=172.19.15.84
export ADRESSE_IP_WORKER_2=172.19.15.86
# ./kubectl describe services $NOM_DU_SERVICE_K8S | grep NodePort
export NO_PORT_IP_NODEPORTK8S=32199

# vous pouvez acccéder à l'application déployée via le node worker 1:
firefox http://$ADRESSE_IP_WORKER_1:$NO_PORT_IP_NODEPORTK8S/
# ou via le node worker 2:
firefox http://$ADRESSE_IP_WORKER_2:$NO_PORT_IP_NODEPORTK8S/
```


À tester:

```
export NOM_DU_POD1=salut-kytes-io-86cddf59d5-lz6vv
export NOM_DU_POD2=salut-kytes-io-86cddf59d5-r25n6

./kubectl exec $NOM_DU_POD2 -- printenv | grep SERVICE
./kubectl exec $NOM_DU_POD1 -- printenv | grep SERVICE

# ce qui afichera la liste des variables d'environnements pour chaque pod.
```



## "Un-deploy" du "hello world" Google


```
export NOM_DU_DEPLOIEMENT=salut-kytes-io
export NOM_DU_SERVICE_K8S=salut-kytes-io-k8service-to-load-balance-b8b
kubectl delete services $NOM_DU_SERVICE_K8S
kubectl delete deployment $NOM_DU_DEPLOIEMENT
# ce qui ...
```


