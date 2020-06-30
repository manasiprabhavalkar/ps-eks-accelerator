+++
title = "Eksctl"
date = 2020-06-16T19:01:12-04:00
weight = 15
chapter = true
pre = "<b></b>"
+++

# Eksctl

Chapter about Building Clusters Examples

The first method to launch an EKS cluster is using [eksctl](https://eksctl.io/) the tool built by weaveworks.

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

eksctl can be used via the command line to launch a cluster, or use a cluster file. The cluster file is defined in yaml, and follows the cluster file [schema](https://eksctl.io/usage/schema/). There are many options within the cluster spec that can configured to fit your exact need, but we are going to start off with a best practices cluster, and explain what each flag is doing.

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

  # - name: robotshop-ng-b
  #   desiredCapacity: 1
  #   minSize: 1
  #   maxSize: 2
  #   iam:
  #     withAddonPolicies:
  #       imageBuilder: true
  #       autoScaler: true
  #       externalDNS: true
  #       certManager: true
  #       appMesh: true
  #       ebs: true
  #       fsx: true
  #       efs: true
  #       albIngress: true
  #       xRay: true
  #       cloudWatch: true
  #   availabilityZones: ["us-west-2b"]
  #   ssh: # An existing key pair for EC2 hosts
  #     publicKeyName: kube
  #   volumeSize: 50

# Use the encryption key from the CLI
secretsEncryption:
  keyARN: "arn:aws:kms:us-west-2:164382793440:key/751f1d85-43fd-4be4-835d-906189f64c8c"

cloudWatch:
  clusterLogging:
    enableTypes: ["*"]
```