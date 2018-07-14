#!/bin/bash


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
################                                                ENVIRONNEMENT                                            #####################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

export MAISON=`pwd`
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

# - Provision Traefik.io - #
kubectl apply -f $MAISON/treafik.io/treafik-rbac.yml
kubectl apply -f $MAISON/treafik.io/treafik-deployment.yml
echo " ---------------------------------------------------- "
echo " ---------------------------------------------------- "
