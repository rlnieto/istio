# Carga la configuración
source environment

# Añade a helm el repositorio de Headlamp
helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update

# Nos aseguramos de estar usando el cluster correcto
kubectl config use-context "kind-${CLUSTER_NAME}"

# Creamos un namespace para Headlamp
kubectl create namespace headlamp

# Habilitamos el sidecar istio para poder acceder a la web
# sin usar forwarding
kubectl label namespace headlamp istio-injection=enabled

# Y lo instalamos
helm install headlamp headlamp/headlamp \
   --namespace headlamp


