#!/bin/bash

# Genera tráfico en el mesh llamando a los endpoints:
#   - /productpage
#   - /api/v1/products
HOSTNAME_SIDECAR=productpage.bookinfo-sidecar.svc.cluster.local:9080
HOSTNAME_AMBIENT=productpage.bookinfo-ambient.svc.cluster.local:9080
iteraciones=0

echo -e "Usando hostname: $HOSTNAME\n"

# Bucle
while true; do
  ((iteraciones++))
  echo -n "Iteración $iteraciones... "
#  curl -s http://$HOSTNAME/productpage > /dev/null
  http_code_page1=$(curl -sk -w "%{http_code}" -o /dev/null http://$HOSTNAME_SIDECAR/productpage)
  http_code_page2=$(curl -sk -w "%{http_code}" -o /dev/null http://$HOSTNAME_AMBIENT/productpage)
  sleep 0.5
  http_code_json1=$(curl -sk -w "%{http_code}" -o /dev/null http://$HOSTNAME_SIDECAR/api/v1/products)
  http_code_json2=$(curl -sk -w "%{http_code}" -o /dev/null http://$HOSTNAME_SIDECAR/api/v1/products)
  echo -e "(${http_code_page1}/${http_code_json1} - ${http_code_page2}/${http_code_json2})"
done

echo "Ejecución completada."
