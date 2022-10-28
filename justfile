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

k8s-resources:
    kubectl get all -A
    kubectl get mutatingwebhookconfigurations -A

# Run core c7n on a policy directory
run DIR:
    ./c7n-local.py run -s output {{ DIR }} -v
# Run a policy directory with c7n-left
run-left DIR:
    c7n-left run -p {{ DIR }} -d terraform/
