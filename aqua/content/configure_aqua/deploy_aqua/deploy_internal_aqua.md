+++
title = "Deploy with PostGreSQL container"
date = 2020-06-16T19:01:12-04:00
weight = 7
chapter = false
pre = "<b></b>"
+++

Launch **Aqua Enterprise** in an Amazon EKS cluster and secure your artifacts, hosts and workloads with Aqua. Well-suited for non-production deployments, it allows you to hit the ground running while providing a sneak peak into Aqua's full-blown cloud-native security capabilities.

## Deploy Aqua Enterprise Platform using containerized PostGres
Go to the AWS Cloud9 IDE and follow the steps in succession.

```shell
./aquactl deploy csp 
```

{{% notice info %}}
It’s an interactive command line tool, so it prompts you to enter all the relevant options.
{{% /notice %}}

Respond to the aquactl command-line prompts shown in the figure.
These are:
* Aqua license details.
* Database configuration
* Aqua administrator password.

![aquactl output](/images/configure_aqua/aquactl-internal-output.png)

Note the Aqua Console Service endpoint.

```shell
AQUA_ELB=$(kubectl get svc aqua-web --namespace aqua -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

AQUA_CONSOLE="http://$AQUA_ELB:8080"

echo $AQUA_CONSOLE
```

## Login to the Aqua Console
Open a browser and log in to the Aqua Console using the ```AQUA_CONSOLE``` URL from the above output, plus the Aqua administrator password.
![aqua console](/images/configure_aqua/aqua-console.png)

Once you are logged in, enter the Aqua license token from your Aqua account.

![aqua license](/images/configure_aqua/aqua-license.png)

