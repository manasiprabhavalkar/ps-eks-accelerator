+++
title = "Terraform"
date = 2020-06-16T19:01:12-04:00
weight = 20
chapter = true
pre = "<b></b>"
+++

# Terraform

When it comes to launching EKS cluster's the second method to launch an EKS cluster we will go over is using [terraform](https://www.terraform.io/) the tool built by hashicorp.

### Installation

#### For linux: 

{{%expand "Expand to see Linux Terraform install Instructions" %}}

Download the terraform binary:

```bash
curl --silent --location "https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip" | tar xz -C /tmp

sudo mv -v /tmp/terraform /usr/local/bin

terraform version
```
{{% /expand %}}

#### For MacOSx 

{{%expand "Expand to see Mac OSX terraform install Instructions" %}}

Install via Homebrew


```bash
brew install terraform

terraform version
```

{{% /expand %}}


#### For Windows 

{{%expand "Expand to see Windows terraform install Instructions" %}}

Install via Chocolatey


```bash
chocolatey install terraform 

terraform version
```
{{% /expand %}}

#### Bash Completion

{{%expand "Expand to enable Bash-completion Instructions" %}}

```bash
terraform -install-autocomplete
```
{{% /expand %}}

### Terraform Information

terraform is a popular open source Infrastructure as code tool which builds, launches, and controls resources using state. 

### Terraform Information

eksctl can be used via the command line to launch a cluster. The most common terraform file structure is

1. ##### main.tf
2. ##### variables.tf
3. ##### outputs.tf

Terraform can get much more in depth when utilzing modules, and sub-modules but we will cover the basics to create the EKS cluster we made in the Eksctl chapter using terraform.

### Terraform main.tf

In this main.tf we create

- IAM role
- VPC and vpc components
- EKS control plane
- EKS nodegroups

##### Control plane
Within the file, we can change variables such as the cluster name, version, and tags. To see a complete list of options check out the eks module [Docs](https://github.com/terraform-aws-modules/terraform-aws-eks)

##### Node Groups
The ```eks``` module utilizes the nested worker group component to define the launch configuration used for the worker group. To see a complete list of options check out the eks module worker group [Docs](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups)

```yaml
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  cluster_version = "1.16"
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "robotshop-ng-a"
      instance_type                 = "m5.large"
      key_name                      = "kube"
      disk_size                     = 50
      min_capacity                  = 1
      max_capacity                  = 2
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
}
```

### Launching the cluster

We use the example terraform cluster at K8s/terraform/main.tf

```bash
cd K8s/terraform

#initialize modules
terraform init

# plan the infrastructure
terraform plan

# deploy the infrastructure
terraform apply

# delete the infrastructure
terraform destroy -auto-approve

# terraform adds a kubeconfig to the directoy 
kubectl get svc --kubeconfig kubeconfig_robotshop

# kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   1m

```

### Upgrading the eksctl control plane and nodegroups

In  terraform to upgrade the components you only need to update the ```main.tf ``` file with the new desired changes, and re-run

```bash
terraform plan

terraform apply
```

### Upgrading un-tracked control plane components

In  terraform to some components are configured for you, but not included in the ```main.tf ``` such as

1. ##### kube-proxy
2. ##### aws-node (VPC cni)
3. ##### coredns


To update the version of these components find the current version on the EKS [Docs](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html)

Then patch the existing objects with the newest versions.

```bash

# kube Proxy

kubectl patch daemonset kube-proxy \
-n kube-system \
-p '{"spec": {"template": {"spec": {"containers": [{"image": "602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/kube-proxy:v1.16.8","name":"kube-proxy"}]}}}}'

# aws-node (vpc CNI)

kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.6/config/v1.6/aws-k8s-cni.yaml


# Coredns

kubectl set image --namespace kube-system deployment.apps/coredns \
coredns=602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/coredns:v1.6.6
```