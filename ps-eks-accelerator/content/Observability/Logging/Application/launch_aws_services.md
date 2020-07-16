+++
title = "Launching AWS Services for Logging"
date = 2020-06-16T19:01:12-04:00
weight = 15
chapter = true
pre = "<b></b>"
+++

# Launch AWS Services

For our sample application we are going to be using the fluent-bit hybrid setup shown in the last chapter.

___
Fluent-bit ships logs directly to Cloudwatch logs for long term retention, and directly to Kinesis Firehose which ships to Amazon Elasticsearch. We use Kibana for log viewing.
![Option 4](/images/observability/logging/application/diagram_5.png)


### Create Elastisearch Domain

```bash
aws es create-elasticsearch-domain \
  --domain-name robotshop \
  --elasticsearch-version 7.4 \
  --elasticsearch-cluster-config \
  InstanceType=m5.large.elasticsearch,InstanceCount=1 \
  --ebs-options EBSEnabled=true,VolumeType=standard,VolumeSize=100 \
  --access-policies '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":["*"]},"Action":["es:*"],"Resource":"*","Condition":{"IpAddress": {"aws:SourceIp": "192.168.0.0/16"}}}]}'
  ```

You can check the status of the domain in the Elastisearch console

You could also check this way via AWS CLI:

```bash
  aws es describe-elasticsearch-domain --domain-name robotshop-logs --query 'DomainStatus.Processing'
```

If the output value is false that means the domain has been processed and is now available to use.

Feel free to move on to the next section for now.

### Create S3 Bucket backup for Elastisearch

Next let's make a bucket to store our Elastisearch backups

```bash
aws s3 mb s3://us-west-2-robotshop-es
```

### Create Firehose and Firehose IAM role

Go to the robot-shop folder and launch the file ```aws/application_logging/firehose.json```

**Replace the AWS s3 bucket with the bucket you created in this file BEFORE launching**

```bash
aws firehose create-delivery-stream --cli-input-json file://firehose.json
```

### Create Fluent-bit IAM policy

Go to the robot-shop folder and launch the file ```aws/application_logging/fluent-bit-iam.json```


```bash
aws iam create-policy --policy-name fluent-bit-robotshop --policy-document file://fluent-bit-iam.json
```


Now let's go launch the Kubernetes resources to get the application logging working.

### Create Fluent-bit IAM role service account

We use eksctl to create an IAM service account here for the fluent-bit daemon-set. To know more about how this works check out the AWS [blog](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/)

```bash
eksctl create iamserviceaccount \
    --name fluent-aws-for-fluent-bit \
    --namespace robotshop \
    --cluster robotshop \
    --attach-policy-arn arn:aws:iam::164382793440:policy/fluent-bit-robotshop \
    --approve \
    --override-existing-serviceaccounts
```

We can verify that came up correctly by running

```bash
kubectl get serviceaccounts

NAME                        SECRETS   AGE
default                     1         2d23h
fluent-aws-for-fluent-bit   1         1h
```

Awesome now that our AWS resources are all created let's launch the Kubernetes resources.