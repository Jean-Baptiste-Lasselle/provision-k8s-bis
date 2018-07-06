# - 

# export http_proxy=http://proxy:8080
# export https_proxy=http://proxy:8080
WHERE_TO_PULL_DASHBOARD_YML_CONF_FROM=https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
curl "$WHERE_TO_PULL_DASHBOARD_YML_CONF_FROM" -o ./kubernetes-dashboard.yaml
sudo kubectl apply -f ./kubernetes-dashboard.yaml


WHERE_TO_PULL_KUBEDNS_YML_CONF_FROM=https://icicimov.github.io/blog/download/kube-dns.yml
curl "$WHERE_TO_PULL_KUBEDNS_YML_CONF_FROM" -o ./kube-dns.yaml
sudo kubectl apply -f ./kube-dns.yaml


