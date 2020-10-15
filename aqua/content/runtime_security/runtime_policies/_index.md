+++
title = "Runtime Policy"
date = 2020-06-16T19:01:12-04:00
weight = 5
chapter = true
pre = "<b></b>"
+++



# Runtime Policy
A runtime policy has three parts:

* Scope — You can create a blanket policy that can be applied to the entire environment. You can also use granular scoping mechanisms based on image attributes, container attributes, or even Kubernetes constructs like pods, deployments, etc.
* Enforcement Mode — You can apply the policy in an Audit mode for current state assessment of your environment, which allows you to perform discovery and provides deeper insight into cloud-native workloads. Switch to the Enforcement mode for actively blocking or enforcing the specified policies.
* Controls — These are security-related tests that are conducted by the Aqua Enforcer while the workload is running.

1. create policy for:
* drift prevention
* exec blacklist
* file block

2. Image profile??

3. Microsegmentation??

