+++
title = "Stateful Storage Architecture Examples"
date = 2020-06-16T19:01:12-04:00
weight = 5
chapter = true
pre = "<b></b>"
+++

### Chapter 6 Examples

# Stateful Storage Architecture Examples

Chapter about Stateful Storage Architecture Examples


To download and install the EBS CSI driver

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.4.0/docs/example-iam-policy.json


aws iam create-policy --policy-name Amazon_EBS_CSI_Driver \
--policy-document file://example-iam-policy.json

kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```