# Deploy MCE on non-OCP cluster


## Install OLM

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


## Install MCE via OLM
1. Create ns `multicluster-engine`, fill your `dockerconfigjson` to the image pull secret `multicluster-engine/prerequisites/image-pull-secret.yaml` and create image pull secret in the `multicluster-engine` ns.

The images are from `quay.io` and `quay.io:443 ` in the MCE catalogSource.

```
kubectl apply -k multicluster-engine/prerequisites/

```

2. Install MCE catalogSource and subscription.

```
kubectl apply -k multicluster-engine/olm
```

3. Install multicluster-engine CR and klusterletConfig.

Change the hubKubeAPIServerURL in` multicluster-engine/samples/klusterletconfig.yaml` and then deploy.

```
kubectl apply -k multicluster-engine/samples
```

## ## Install MCE via manifests
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

## Install ACM

1. Create ns `open-cluster-management`, fill your `dockerconfigjson` to the image pull secret `multiclusterhub/prerequisites/image-pull-secret.yaml` and create image pull secret in the `open-cluster-management` and `olm` ns.

The images are from `quay.io` and `quay.io:433 ` in the ACM catalogSource.

```
kubectl apply -k multiclusterhub/prerequisites/

```

2. Install MCE catalogSource and subscription.

```
kubectl apply -k multiclusterhub/olm
```

3. Install MCH CR 

```
kubectl apply -f multiclusterhub/samples/multiclusterhub.yaml
```

4. Install klusterletConfig after MCE CR is created.
 
Change the hubKubeAPIServerURL in `multicluster-engine/samples/klusterletconfig.yaml` and then deploy.
```
kubectl apply -f multiclusterhub/samples/klusterletconfig.yaml
```
