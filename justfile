help:
    @just --list

# Run localstack
up:
    docker-compose up -d

# Stop and teardown the infra
down:
    docker-compose down
    rm -rf terraform/.terraform*
    rm -rf terraform/terraform*

# Init and Plan the terraform run
plan:
    terraform -chdir=./terraform init
    terraform -chdir=./terraform plan

# Apply the terraform
apply:
    terraform -chdir=./terraform apply

# Apply the k8s manifests
k8s-apply DIR:
    kubectl apply -f {{ DIR }} --force

# Remove all the k8s resources
k8s-remove DIR:
    kubectl delete -f {{ DIR }} --force

# List all k8s resources
k8s-resources:
    kubectl get all -A
    kubectl get mutatingwebhookconfigurations -A

# Install the admission controller
k8s-install:
    helm repo add c7n https://cloud-custodian.github.io/helm-charts/
    helm repo update
    helm install c7n-kube c7n/c7n-kube  --namespace c7n-system -f values.yml --create-namespace



# Run core c7n on a policy directory
run DIR:
    ./c7n-local.py run -s output {{ DIR }} -v
# Run a policy directory with c7n-left
run-left DIR:
    c7n-left run -p {{ DIR }} -d terraform/
