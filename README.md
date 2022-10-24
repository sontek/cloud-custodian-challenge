# Cloud Custodian Challenge!
This is a repo that provides some infrastructure as code files that wouldn't
pass most compliance requirements. It is a nice playground for testing cloud
custodian!

# Challenge 1 - The Cloud (AWS)
We should not allow public s3 buckets or unencrypted s3 buckets!

To get started we need to run [LocalStack](https://localstack.cloud/) so we
aren't creating non-compliant resources in an actual public cloud. We've
provided a docker-compose file for you:

```sh
docker-compose up -d
source .envrc
```

Now lets run a plan of our terraform to see what it'll produce:

```sh
terraform -chdir=./terraform init
terraform -chdir=./terraform plan
```

You should see that we can't tell if the bucket will be encrypted or not by
default:

```
      + server_side_encryption_configuration {
          + rule {
              + bucket_key_enabled = (known after apply)

              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = (known after apply)
                }
            }
        }
```

Apply the terraform to create the infrastructure and check to see if you have
secure resources.

```sh
terraform -chdir=./terraform apply
```

Now fetch the bucket encryption:

```sh
aws s3api get-bucket-encryption --bucket my-unencrypted-bucket --endpoint-url=http://localhost:4566

An error occurred (ServerSideEncryptionConfigurationNotFoundError) when calling the GetBucketEncryption operation: The server side encryption configuration was not found
```

This is bad!  We always want to have server side encryption enabled on our
buckets.

## GOAL
*Write a cloud custodian policy that identifies that this resource is not
encrypted and deletes it!*

We've provided a script that will allow you to run custodian policies
against your local stack.

To use it, you would do something like this:

```
./c7n-local.py run -s output policies/ -v
```

# Challenge 2 - Terraform
The previous challenge identified resources that were in violation *after* they
landed in our account.  Ideally we want to stop the resources *before* they
get deployed.  To do this we are going to use `c7n-left` to run a policy against
the terraform directly.

## GOAL
- *Write a cloud custodian policy that identifies which terraform resource hasn't
enabled server side encryption*
- *Write a cloud custodian policy that prevents using AES256 (i.e require aws:kms)
enabled server side encryption*

# Challenge 3 - Kubernetes
Kubernetes is effectively a cloud of its own and so you'll want the same type of
governance on it that you would in AWS or Terraform. We've provided a `kubernetes`
folder with a set of resources you can install in your cluster so we can start
governing them.

## GOAL
- *write a cloud custodian policy that requires resource requests limits on pods*
- *write a cloud custodian policy that requires `app.kubernetes.io/managed-by` 
  label on pods*

# Challenge 3 - Kubernetes Admission Controller
The previous challenge identified resources that were in violation *after* they
were deployed to the cluster.  Ideally we want to stop the resources *before*
they ge deployed.  To do this we are going to enable the `c7n-kube` admission
controller on our cluster.
