
# Install OLM

Option 1:
1. Download operator-sdk from https://github.com/operator-framework/operator-sdk/releases/tag/v1.34.1
2. Install OLM. 

```
operator-sdk olm install 
```

Option 2:

Install OLM by the scripts.

```
bash ./prepare/olm/prepare-olm.sh 
```

# Deploy MCE on non-OCP cluster

## Install MCE via OLM

1. Create ns `multicluster-engine`, fill your `dockerconfigjson` to the image pull secret `multicluster-engine/prerequisites/image-pull-secret.yaml` and create image pull secret in the `multicluster-engine` ns.

    The images are from `quay.io` and `quay.io:443 ` in the MCE catalogSource.

    The test images are all public, so no need to fill `dockerconfigjson`.

    ```
    kubectl apply -k multicluster-engine/prerequisites/
    ```

2. Install MCE catalogSource and subscription.

    ```
    kubectl apply -k multicluster-engine/olm
    ```

3. Install multicluster-engine CR and klusterletConfig after the `multicluster-engine-operator` pods are running in the `multicluster-engine` ns.

    Change the hubKubeAPIServerURL in` multicluster-engine/samples/klusterletconfig.yaml` and then deploy.

    ```
    kubectl apply -k multicluster-engine/samples
    ```

## Install MCE via manifests
1. Create ns `multicluster-engine`. The images in the manifests are all public, no need image pull secret.

    ```
    kubectl apply -k multicluster-engine/prerequisites/
    ```

2. Create manifests

    ```
    kubectl apply -k multicluster-engine/manifests/
    ```

3. Install multicluster-engine CR and klusterletConfig.

    Change the hubKubeAPIServerURL in` multicluster-engine/samples/klusterletconfig.yaml` and then deploy.

    ```
    kubectl apply -k multicluster-engine/samples
    ```

# Install Policy addon 

## Install Policy addon controller 

    ```
    kubectl apply -k policy/manifests/
    ```

## Install Policy addon CRs to the cluster namespace
    
Need to create policy addon CRs to each managed cluster namespace to enable addons.

    ```
    kubectl apply -k policy/addons/ -n <cluster name>
    ```


# Install ACM on non-OCP cluster

## Install ACM via OLM

1. Create ns `open-cluster-management`, fill your `dockerconfigjson` to the image pull secret `multiclusterhub/prerequisites/image-pull-secret.yaml` and create image pull secret in the `open-cluster-management` and `olm` ns.

    The images are from `quay.io` and `quay.io:433 ` in the ACM catalogSource.

    The test images are all public, so no need to fill `dockerconfigjson`.

    ```
    kubectl apply -k multiclusterhub/prerequisites/
    ```

2. Install ACM and MCE catalogSources and subscpriton.

    ```
    kubectl apply -k multiclusterhub/olm
    ```

3. Install MCH CR after the pods `multiclusterhub-operator` are running in `open-cluster-management` ns.  

    ```
    kubectl apply -f multiclusterhub/samples/multiclusterhub.yaml
    ```

4. Install klusterletConfig after MCE CR is created.
 
    Change the hubKubeAPIServerURL in `multicluster-engine/samples/klusterletconfig.yaml` and then deploy.

    ```
    kubectl apply -f multiclusterhub/samples/klusterletconfig.yaml
    ```

## Uninstall ACM

1. delete MCH CR
    ```bash
      kubectl delete mch -n open-cluster-management multiclusterhub
    ```
    this steps may take several minutes. 
    can go to the next step if MCE operator and CR cannot be found.


2. delete acm subscriptions
    ```bash
    kubectl delete subscriptions.operators.coreos.com -n open-cluster-management acm-operator-subscription

    kubectl delete csv -n open-cluster-management advanced-cluster-management.v2.11.0
    ```

3. delete open-cluster-management ns
    ```bash
    kubectl delete ns open-cluster-management
    ```
      if mch CR is deleting, force delete it 
    ```
    kubectl patch mch -n open-cluster-management multiclusterhub --type=merge -p '{"metadata":{"finalizers": []}}'
    ```


4. delete catalogSource
    ```bash
    kubectl delete catalogsources.operators.coreos.com -n olm acm-custom-registry multiclusterengine-catalog
    ```
5. clean up the leftover
    ```bash
 
    kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io multiclusterengines.multicluster.openshift.io multiclusterhub-operator-validating-webhook ocm-validating-webhook

    kubectl get pods -n olm | grep acm | awk '{print $1}' | xargs oc delete pods -n olm

    kubectl get pods -n olm | grep multiclusterengine | awk '{print $1}' | xargs oc delete pods -n olm

    kubectl delete service -n olm acm-custom-registry multiclusterengine-catalog
    ```


# Import managed cluster to MCE/ACM
Refer to the doc: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.10/html/clusters/cluster_mce_overview#importing-managed-cluster-cli

Only need enable `certPolicyController` and `policyController` in the `KlusterletAddonConfig` CR.

```yaml
    apiVersion: agent.open-cluster-management.io/v1
    kind: KlusterletAddonConfig
    metadata:
      name: <cluster name>
      name: <cluster namespace>
    spec:
      certPolicyController:
        enabled: true
      policyController:
        enabled: true

```
