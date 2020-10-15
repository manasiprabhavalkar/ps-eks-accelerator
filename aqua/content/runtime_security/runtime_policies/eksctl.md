+++
title = "Eksctl"
date = 2020-06-16T19:01:12-04:00
weight = 15
chapter = true
pre = "<b></b>"
+++

# Eksctl

When it comes to launching EKS cluster's the first method to launch an EKS cluster is using [eksctl](https://eksctl.io/) the tool built by weaveworks.

### Installation

#### For linux: 

{{%expand "Expand to see Linux Eksctl install Instructions" %}}

Download the eksctl binary:

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

sudo mv -v /tmp/eksctl /usr/local/bin

eksctl version
```
{{% /expand %}}

#### For MacOSx 

{{%expand "Expand to see Mac OSX Eksctl install Instructions" %}}

Install via Homebrew


```bash
brew install eksctl

eksctl version
```

{{% /expand %}}


#### For Windows 

{{%expand "Expand to see Windows Eksctl install Instructions" %}}

Install via Chocolatey


```bash
chocolatey install -y eksctl 

eksctl version
```
{{% /expand %}}

#### Bash Completion

{{%expand "Expand to enable Bash-completion Instructions" %}}

```bash
eksctl completion bash >> ~/.bash_completion
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
```
{{% /expand %}}

### Eksctl Information

eksctl is a command line tool which builds, launches, and controls Amazon EKS clusters for you. It uses Cloudformation, and the Kubernetes API under the hood to manage the lifecycle of events.

### The Eksctl File

eksctl can be used via the command line to launch a cluster, or use a cluster file. The cluster file is defined in yaml, and follows the cluster file [eksctl schema](https://eksctl.io/usage/schema/). There are many options within the cluster spec that can configured to fit your exact need, but we are going to start off with a best practices cluster, and explain what each flag is doing.

```yaml
apiVersion: eksctl.io/v1alpha5 #version of the eksctl schema
kind: ClusterConfig

metadata:
  name: robotshop # Name of the eks cluster
  region: us-west-2 #Region of the eks cluster

iam:
  withOIDC: true #uses IAM for service account
  serviceAccounts: # Create a service account which links to the Xray policy. This later gets attached to the pod for fine grained access control
  - metadata:
      name: xray-daemon
      namespace: robotshop
      labels: {aws-usage: "application"}
    attachPolicyARNs:
    - "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  - metadata:
      name: cluster-autoscaler
      namespace: kube-system
      labels: {aws-usage: "cluster-ops"}
    #Here we define a new IAM policy to attach to our autoscaler service account
    attachPolicy:
      Version: "2012-10-17"
      Statement:
      - Effect: Allow
        Action:
        - "autoscaling:DescribeAutoScalingGroups"
        - "autoscaling:DescribeAutoScalingInstances"
        - "autoscaling:DescribeLaunchConfigurations"
        - "autoscaling:DescribeTags"
        - "autoscaling:SetDesiredCapacity"
        - "autoscaling:TerminateInstanceInAutoScalingGroup"
        Resource: '*'

nodeGroups:
  - name: robotshop-ng-a
    tags:
      # EC2 tags required for cluster-autoscaler auto-discovery
      k8s.io/cluster-autoscaler/enabled: "true"
      k8s.io/cluster-autoscaler/robotshop: "owned"
    desiredCapacity: 1
    minSize: 1
    maxSize: 2
    iam:
      withAddonPolicies:
        autoScaler: true
        externalDNS: true
        certManager: true
        ebs: true
        albIngress: true
        xRay: true
        cloudWatch: true
    availabilityZones: ["us-west-2a"]
    ssh: # An existing key pair for EC2 host test
      publicKeyName: kube
    volumeSize: 50

# Use the encryption key from the CLI
secretsEncryption:
  keyARN: "arn:aws:kms:us-west-2:164382793440:key/751f1d85-43fd-4be4-835d-906189f64c8c"

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
```

{{%expand "Expand to see Creation for the secretsEncryption commands" %}}

```bash

MASTER_KEY_ARN=$(aws kms create-key --query KeyMetadata.Arn --output text)
aws kms create-alias \
      --alias-name alias/eks-accelerator-master-key \
      --target-key-id $(echo $MASTER_KEY_ARN | cut -d "/" -f 2)
export MASTER_KEY_ARN=$MASTER_KEY_ARN

echo $MASTER_KEY_ARN

# Add this key arn to the eksctl file under secretsEncryption.keyARN
```
{{% /expand %}}

### What does eksctl create?

The eksctl command will spin up 3 cloudformation stacks using during cluster creation.

To learn more in depth visit the official docs:
[eksctl.io](https://eksctl.io/introduction/)

1. ##### The control plane and VPC setup for EKS
2. ##### The nodegroup ASG
3. ##### The service accounts and OIDC setup

### Common Configuration Options for eksctl

eksctl has quite a few confuration options, and we're going to cover a few common ones before we launch our cluster.

Options include:

1. ##### [Existing VPC configurations](https://github.com/weaveworks/eksctl/blob/master/examples/04-existing-vpc.yaml)
2. ##### [Windows Nodes](https://github.com/weaveworks/eksctl/blob/master/examples/14-windows-nodes.yaml)
3. ##### [Fargate on EKS](https://github.com/weaveworks/eksctl/blob/master/examples/16-fargate-profile.yaml)
4. ##### [Spot Instances](https://github.com/weaveworks/eksctl/blob/master/examples/08-spot-instances.yaml)
5. ##### [Managed Nodegroups](https://github.com/weaveworks/eksctl/blob/master/examples/15-managed-nodes.yaml)


### Launching the cluster

Let's use the cluster file we looked at earlier to launch our EKS cluster.

```bash
eksctl create cluster -f K8s/eksctl/eksctl.yaml

[ℹ]  eksctl version 0.21.0
[ℹ]  using region us-west-2
[ℹ]  setting availability zones to [us-west-2d us-west-2b us-west-2a]
[ℹ]  will create a CloudFormation stack for cluster itself and 1 nodegroup stack(s)
[ℹ]  will create a CloudFormation stack for cluster itself and 0 managed nodegroup stack(s)

....

kubectl get svc

# kubernetes   ClusterIP   10.100.0.1   <none>        443/TCP   1m

```

### Upgrading the eksctl control plane

```bash
# To upgrade control plane to the next available version or target version
eksctl upgrade cluster --name=<clusterName>

eksctl upgrade cluster --name<clusterName> --version=1.16

# To update kube-proxy, run:
eksctl utils update-kube-proxy

#To update aws-node, run:
eksctl utils update-aws-node

#To update coredns, run:
eksctl utils update-coredns


```

### Upgrading the eksctl nodegroup

Nodegroups can have differing versions from each other, and from the control plane in EKS. You can have a cluster on version `1.16` and a nodegroup on `1.14` and they can still function.


To update nodegroups in eksctl you must 

1. ##### Create New Nodegroup
2. ##### Delete old Nodegroup

The pods/services/daemonsets get drained, and re-balanced through the kubernetes scheduler to keep services up and running at proper capacity.

```bash
# Add new nodegroup with DIFFERENT name to the config file. Then create the new nodegroup, and delete the old group.

#Create new group
eksctl create nodegroup --config-file=K8s/eksctl/eksctl.yaml

#Delete old group
eksctl delete nodegroup --config-file=K8s/eksctl/eksctl.yaml --only-missing --approve

```

