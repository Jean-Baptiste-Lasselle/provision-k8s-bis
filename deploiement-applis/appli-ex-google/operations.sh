#!/bin/bash


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
################                                                ENVIRONNEMENT                                            #####################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

# export MAISON=`pwd`
export MAISON=$(pwd)/../..
export ADRESSE_IP_K8S_API_SERVER_PAR_DEFAUT=0.0.0.0
export ADRESSE_IP_K8S_API_SERVER=$ADRESSE_IP_K8S_API_SERVER_PAR_DEFAUT
export NO_PORT_IP_K8S_API_SERVER_PAR_DEFAUT=6443
export NO_PORT_IP_K8S_API_SERVER=$NO_PORT_IP_K8S_API_SERVER_PAR_DEFAUT

export VERSION_K8S_PAR_DEFAUT=1.11.0
# export VERSION_K8S_PAR_DEFAUT=v1.10.5
export VERSION_K8S=$VERSION_K8S_PAR_DEFAUT

# - ---
# - Kubernetes affecte un nom pour chaque noeud du cluster: cette variable
#   d'environnement permettra de fixer la valeur de ce "node-name", notamment
#   celui-ci doit être différent selon qu'il s'agit d'un maître ou d'un esclave.
# - 
# - ---
# - Les maîtres utilisent l'option [--node-name] de [kubeadm init] pour faire leur set-node-name
# - Les maîtres esclaves utilisent l'option [--hostname-override=$K8S_NODE_NAME] de [kubelet] pour faire leur set-node-name  
export K8S_NODE_NAME_PAR_DEFAUT=tryphon-$RANDOM
# export K8S_NODE_NAME_PAR_DEFAUT=tournesol
export K8S_NODE_NAME=$K8S_NODE_NAME_PAR_DEFAUT

# - pour POD NETWORK: FLANNEL
# export POD_NETWORK_CIDR
export POD_NETWORK_CIDR_PAR_DEFAUT="10.244.0.0/16"
export POD_NETWORK_CIDR=$POD_NETWORK_CIDR_PAR_DEFAUT

# - pour PROXY HTTP éventuel
# export SRV_PROXY_HTTP_DE_LINFRA
# export SRV_PROXY_HTTP_DE_LINFRA_PAR_DEFAUT=htpp://srv-proxy-de-votre-infra:8080
# SRV_PROXY_HTTP_DE_LINFRA=$SRV_PROXY_HTTP_DE_LINFRA_PAR_DEFAUT

export FICHIER_STDOUT_KUBEADM_INIT_MASTER=$MAISON/stdout-stderr-kubeadm-init.master


export NOM_DU_DEPLOIEMENT=salut-kytes-io
export NOM_DU_LOAD_BALANCER=notre-petit-load-balancer
export NO_PORT_APPLICATIF=8080
export NOM_IMAGE=google-samples/node-hello
export NO_VERSION_IMAGE=1.0
# export REGISTRY_DOCKER_BOSSTEK_HOTE=docker-registry.kytes-io.net
export REGISTRY_DOCKER_BOSSTEK_HOTE=gcr.io
export NOM_DU_SERVICE_K8S=salut-kytes-io-k8service-to-load-balance-b8b
# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
################						FONCTIONS						######################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#################                                                OPERATIONS                                              #####################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

cd $MAISON
clear
# - Déploiement application exemple google - #
echo " ------------ ++ # - -------------------------------------- - # ++ ------------ "
echo " ------------ ++ # - Déploiement application exemple google - # ++ ------------ "
echo " ------------ ++ # - Déploiement application exemple google - # ++ ------------ "
echo " ------------ ++ # - -------------------------------------- - # ++ ------------ "

# kubectl apply -f $MAISON/deploiement-applis/treafik-rbac.yml

# - etape 1. Créer un déploiement

kubectl run $NOM_DU_DEPLOIEMENT --replicas=2 --labels="run=$NOM_DU_LOAD_BALANCER" --image=$REGISTRY_DOCKER_BOSSTEK_HOTE/$NOM_IMAGE:$NO_VERSION_IMAGE --port=$NO_PORT_APPLICATIF

# - etape 2. Créer un service, exposer le déploiement par ce service

kubectl expose deployment $NOM_DU_DEPLOIEMENT --type=NodePort --name=$NOM_DU_SERVICE_K8S

# - etape finale: générer le tear-down

# - val. deboggage
# export MAISON=$(pwd)/../..
export NOM_DU_DEPLOIEMENT=salut-kytes-io
export NOM_DU_SERVICE_K8S=salut-kytes-io-k8service-to-load-balance-b8b
# export NOM_DU_DEPLOIEMENT=VAL_NOM_DU_DEPLOIEMENT
# export NOM_DU_SERVICE_K8S=VAL_NOM_DU_SERVICE_K8S
rm $MAISON/deploiement-applis/appli-ex-google/tear-down.sh
cp $MAISON/deploiement-applis/appli-ex-google/tear-down.template.sh $MAISON/deploiement-applis/appli-ex-google/tear-down.sh
sed -i 's/VAL_NOM_DU_DEPLOIEMENT/$NOM_DU_DEPLOIEMENT/g' $MAISON/deploiement-applis/appli-ex-google/tear-down.sh
sed -i 's/VAL_NOM_DU_SERVICE_K8S/$NOM_DU_SERVICE_K8S/g' $MAISON/deploiement-applis/appli-ex-google/tear-down.sh
chmod +x $MAISON/deploiement-applis/appli-ex-google/tear-down.sh
# $MAISON/deploiement-applis/appli-ex-google/tear-down.sh

echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ L'application $REGISTRY_DOCKER_BOSSTEK_HOTE/$NOM_IMAGE:$NO_VERSION_IMAGE est maintenant déployée:  "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 								déploiements présents dans le cluster:		 "
kubectl get deployments 
echo " ------------ ++ 								\"replicaSets\" présents dans le cluster:		 "
kubectl get replicaSets 
echo " ------------ ++ 								\"pods\" présents dans le cluster:		 "
kubectl get pods 
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ Pour afficher le numéro de port via lequel l'application sera disponible, exécutez:  "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										kubectl describe services $NOM_DU_DEPLOIEMENT | grep NodePort "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "cho " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ Accédez à l'application de la manière suivante:  "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "


# Premier arg. de la fonction: le nom k8s du node dont on souhaite récupérer l'adresse IP 
recupererAdresseIP () {
  export NOM_WORKER=$1
  export RESULTAT=$(kubectl describe node $NOM_WORKER | grep /public-ip)
  echo "${RESULTAT:55:15}" && return 0;
}

# -
# Premier arg. de la fonction: le nom du déploiement applicatif dont on souhaite récupérer le NodePort
# du node dont on souhaite récupérer l'adresse IP 
recupererNodePortDuDeploiement () {
  export NOM_DEPLOIEMENT=$1
  export RESULTATI=$(kubectl describe services $NOM_DEPLOIEMENT | grep NodePort:| awk '{print $3}')
  # echo ${RESULTATI::-4} && return 0;
  echo ${RESULTATI::-4} && return 0;
}


# on la liste de tous les noms de nodes du cluster, dans un fichier texte
kubectl get nodes | awk '{print $1}' | grep -v NAME >> liste-workers.kytes
# on itère sur le ifchier, pour afficher l'URL complète d'acès à l'application déployée, via 
export ADRESSE_IP_WORKER_COURANT
export NO_PORT_IP_NODEPORTK8S_DU_DEPLOIEMENT=$(recupererNodePortDuDeploiement $WORKER_COURANT)

while read WORKER_COURANT; do
  ADRESSE_IP_WORKER_COURANT=$(recupererAdresseIP $WORKER_COURANT)
  # echo " worker jbl repéré:  [$WORKER_COURANT]   adresse IP : [$ADRESSE_IP_WORKER_COURANT]"
  echo "  "
  echo "  --  "
  echo "  "
  echo "  via le node \"[$WORKER_COURANT]\", avec l'instruction :"
  echo "      firefox http://$ADRESSE_IP_WORKER_COURANT:$NO_PORT_IP_NODEPORTK8S_DU_DEPLOIEMENT/"
  echo "  --  "
  echo "# ou "
done <liste-workers.kytes
rm liste-workers.kytes





echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										kubectl describe node worker-jbl|grep /public|export RESULTAT=$1 && echo \"\${RESULTAT:55:15}\" "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 			Enfin, vous pouvez nettoyer toutes els traes de cette recette en exécutant le script:							 "
echo " ------------ ++ 										 "
echo " ------------ ++ 				[$MAISON/deploiement-applis/appli-ex-google/tear-down.sh]						 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										kubectl describe node worker-jbl|grep /public|export RESULTAT=$1 && echo \"\${RESULTAT:55:15}\" "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ 										 "
echo " ------------ ++ ------------------------------------------------------------------------------------ "

