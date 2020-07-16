+++
title = "Launching Kube Resources for Logging"
date = 2020-06-16T19:01:12-04:00
weight = 20
chapter = true
pre = "<b></b>"
+++

# Launch Kube Resources


### Understanding the Fluent-bit Config

In the kubeneretes files we are about to launch there is a configmap with the fluent-bit configuration. If you want to edit values according to the fluent-bit [documentation](https://github.com/aws/aws-for-fluent-bit)

Let's take a look at our configuration which has the Kinesis Firehose configuration

We add in input path from the containers log on each host, and our output is where we add in the firehose configuration from the last step.

```yaml
    [SERVICE]
        Parsers_File /fluent-bit/parsers/parsers.conf

    [INPUT]
        Name              tail
        Tag               kube.*
        Path              /var/log/containers/*.log
        DB                /var/log/flb_kube.db
        Parser            docker
        Docker_Mode       On
        Mem_Buf_Limit     5MB
        Skip_Long_Lines   On
        Refresh_Interval  10

    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc.cluster.local:443
        Merge_Log           On
        Merge_Log_Key       data
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
    [OUTPUT]
        Name            firehose
        Match           *
        region          us-west-2
        delivery_stream robotshop
```


### Create Fluent-bit Resources

Let's launch our fluent-bit resources, with the daemonset using the Serviceaccount from the last step.

```yaml

    spec:
      serviceAccountName: fluent-aws-for-fluent-bit
      containers:
        - name: aws-for-fluent-bit
          imagePullPolicy: IfNotPresent
          image: "amazon/aws-for-fluent-bit:2.2.0"

```

```bash
kubectl apply robot-shop/K8s/kubectl/templates/fluent-bit-clusterrole.yaml
kubectl apply robot-shop/K8s/kubectl/templates/fluent-bit-clusterrolebinding.yaml
kubectl apply robot-shop/K8s/kubectl/templates/fluent-bit-configmap.yaml
kubectl apply robot-shop/K8s/kubectl/templates/fluent-bit-daemonset.yaml
```

Now lets check to see all our resources spun up correctly.

```bash
k get daemonset -l app.kubernetes.io/name=aws-for-fluent-bit

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
fluent-aws-for-fluent-bit   3         3         3       3            3           <none>          1h
```

So our daemon-set up is up and running, lets go see how we check our application logs.

Go to **AWS > Elastisearch > Kibana Endpoint**

you might need to go the access policy, and change it to let in your VPN IP address, and or use IAM based authentication.

**AWS > Elastisearch > Edit > Modify Acess Policy**

![ES access](/images/observability/logging/application/elastisearch_access.png)


### How to find application logs

Go to the kibana console. I'm using * as the index pattern here, but you could create indexes for larger logging clusters.

We apply a filter of

**kubernetes.labels.service IS web**

![Kibana_search](/images/observability/logging/application/Kibana_search.png)


Now we are able to view all of our access logs from each of our microservices in one pane/view.

There is much more to application logging, so check out more guides and documentation, and check out the Partner chapter even more solutions.