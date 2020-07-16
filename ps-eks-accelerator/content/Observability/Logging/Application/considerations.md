+++
title = "Logging Considerations"
date = 2020-06-16T19:01:12-04:00
weight = 10
chapter = true
pre = "<b></b>"
+++

# Logging Considerations

When it comes to working with application logging there are a few considerations for EKS. This will quickly cover the basics, the componenets, and the high level architecture for adding application logging for EKS.


### Collector

The collector is most often a daemon-set living on the EKS node, or a sidecar container in the kubernetes deployment.

The AWS prescribed tools are:

{{%expand "Expand to see Pros and Cons of Fluent-bit" %}}

```md
Pros:
- Lightweight written in C
- Plugins built for AWS (Cloudwatch, Firehose, Firelens)

Cons:
- Rapidly changing
```

{{% /expand %}}


{{%expand "Expand to see Pros and Cons of Fluentd" %}}

```md
Pros:
- Product has been around for a while, and many open source plugins

Cons:
- Slightly slower
```

{{% /expand %}}

##### AWS Recommended: Fluent-bit


### Aggregator (optional)

This is an optional componenet often used when utilizing sidecar logging patterns to keep the sidecar resource quote low

##### AWS Recommended: Fluentd

### Log Shipper

The log shipper is the compenent, or combination of components to move logs from the cluster to the log storage location.

Using Fluent-Bit there are a few good options we can quickly configure

___
**Option 1** ships logs directly from fluent-bit to Kinesis Firehose, and then to Amazon Elasticsearch
![Option 1](/images/observability/logging/application/diagram_1.png)
___
**Option 2** ships logs directly from fluent-bit to Kinesis Firehose, and then to Amazon S3 for long term retention, and lastly to Amazon Elasticsearch. This is the recommended approach when utilizing Amazon Athena to perform insights on logs.
![Option 2](/images/observability/logging/application/diagram_2.png)
___
**Option 3** ships logs directly from fluent-bit to Amazon Cloudwatch Logs for long term retention, and then sets up a Cloudwatch logs subscription using Lambda to ship logs to Amazon Elasticsearch
![Option 3](/images/observability/logging/application/diagram_3.png)
___
**Option 4** is a hybrid approach, and ships logs directly from fluent-bit to Cloudwatch logs for long term retention, and Kinesis Firehose to Amazon Elasticsearch. 
![Option 4](/images/observability/logging/application/diagram_4.png)
___
**Option 5** is another hybrid approach, and ships logs directly from fluent-bit to Kinesis Firehose which streams it to S3 for long term retention, and Amazon Elasticsearch for real time analysis. 
![Option 4](/images/observability/logging/application/diagram_5.png)
___

### Long Term Retention

{{%expand "Expand to see Pros and Cons of Elastisearch" %}}

```md
Pros:
- Fast
- Good tie-ins with common logging components (Kibana/Logstash)

Cons:
- Expensive
```

{{% /expand %}}


{{%expand "Expand to see Pros and Cons of S3" %}}

```md
Pros:
- Good Ties in with Amazon Services
- Low Cost

Cons:
- Low Performance
```

{{% /expand %}}

{{%expand "Expand to see Pros and Cons of Amazon Cloudwatch Logs" %}}

```md
Pros:
- Good Ties in with Amazon Services
- Visual component built in
- Low Cost

Cons:
- Difficult for navigation between log streams
- Difficult search features
```

{{% /expand %}}


### Visual Log Component

**Kibana** is the visual Component when using **Elastisearch** for long term rentention 

**Athena**  is the visual Component when using **S3** for long term rentention 

**Cloudwatch** is the visual Component when using **Cloudwatch Logs** for long term rentention 

___

Logging has quite a lot of options, and now that we've gone through all the common options, and components we will be better equiped walking through adding logging to our example application.
