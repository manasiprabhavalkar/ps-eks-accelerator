+++
title = "Introduction"
date = 2020-06-16T19:01:12-04:00
weight = 10
chapter = true
pre = "<b></b>"
+++

# Introduction and Background


### Kubernetess Tools Installation

Kubectl The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters.

Reqiured Tools for EKS
- Kubectl
- AWS IAM Authenticator

#### Install for Linux: 

{{%expand "Expand to see Linux Kubectl install Instructions" %}}

Download the Kubectl binary:

```bash
#Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version --client

#AWS IAM Authcenticator
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator

chmod +x ./aws-iam-authenticator

mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin

echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

aws-iam-authenticator help
```
{{% /expand %}}

#### Install for MacOSx 

{{%expand "Expand to see Mac OSX Kubectl install Instructions" %}}

Install via Homebrew

```bash
#Kubectl
brew install kubectl

kubectl version --client

#AWS IAM Authcenticator
brew install aws-iam-authenticator

aws-iam-authenticator help
```

{{% /expand %}}


#### Install for Windows 

{{%expand "Expand to see Windows Kubectl install Instructions" %}}

Install via Chocolatey


```bash
#Kubectl
choco install kubernetes-cli

kubectl version --client

#AWS IAM Authcenticator
choco install -y aws-iam-authenticator

aws-iam-authenticator help
```
{{% /expand %}}

### Kubernetess Tools Installation
