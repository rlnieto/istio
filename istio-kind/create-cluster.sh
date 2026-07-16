# Carga la configuración
source environment

# Incrementamos el número de open files (temporal, desaparece al reiniciar el host)
echo "Incrementando el número de open files..."
scripts/increase-open-files.sh

# Crea el fichero de configuración para kind expandiendo las
# variables con los valores que tenemos en 'environment'
# (crea el fichero kind-config.yaml en cada ejecución)
envsubst < kind-config.yaml.template > kind-config.yaml

# Creamos el cluster
# En el fichero 'kind-config.yaml' indicamos los puertos 
# que va a poder usar el cluster kind
kind create cluster --name $CLUSTER_NAME --config kind-config.yaml

# Nos quedamos a la espera hasta que el cluster levante
echo -e "\n"
echo -n "Esperando control plane ... "
kubectl wait \
      --for=condition=Ready node/"${CLUSTER_NAME}-control-plane" \
      --timeout=300s > /dev/null
echo "[READY]"

echo -n "Esperando pods ... "
kubectl wait \
      --namespace kube-system \
      --for=condition=Ready pod \
      --all \
      --timeout=300s > /dev/null
echo "[READY]"

# Instalamos istio
echo "Instalando istio"
istioctl install --set profile=demo -y

# Una vez instalado istio actualizamos el nodeport del ingress 
# porque necesitamos abrir ese puerto en el contenedor de kind
# y el valor varía con cada instalación
scripts/ingress_nodeport_patch.sh