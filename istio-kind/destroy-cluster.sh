# Carga la configuración
source environment

# Eliminamos el cluster
kind delete cluster --name $CLUSTER_NAME 
