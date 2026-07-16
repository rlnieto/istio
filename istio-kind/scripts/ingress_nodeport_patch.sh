nodeport_index=$(kubectl get svc istio-ingressgateway -n istio-system -o json | jq '.spec.ports | map(.name) | index("http2")')

kubectl patch svc istio-ingressgateway \
  -n istio-system \
  --type='json' \
  -p="[
    {
      \"op\": \"replace\",
      \"path\": \"/spec/ports/${nodeport_index}/nodePort\",
      \"value\": 32040
    }
  ]"