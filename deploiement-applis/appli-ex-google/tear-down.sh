#!/bin/bash


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
################                                                ENVIRONNEMENT                                            #####################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------



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

# cd $MAISON
clear
# - Déploiement application exemple google - #
echo " ------------ ++ # - -------------------------------------- - # ++ ------------ "
echo " ------------ ++ # - Un-deploy  application exemple google - # ++ ------------ "
echo " ------------ ++ # - -------------------------------------- - # ++ ------------ "
echo " ------------ ++ # - -------------------------------------- - # ++ ------------ "

export NOM_DU_DEPLOIEMENT=$NOM_DU_DEPLOIEMENT
export NOM_DU_SERVICE_K8S=$NOM_DU_SERVICE_K8S
kubectl delete services $NOM_DU_SERVICE_K8S
kubectl delete deployment $NOM_DU_DEPLOIEMENT