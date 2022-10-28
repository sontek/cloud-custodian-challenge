help:
    @just --list

# Run localstack
start:
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


# Run a policy directory
run DIR:
    c7n-left run -p {{ DIR }} -d terraform/
