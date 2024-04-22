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

## Install service-ca operator

The service-ca operator is a workaround for the serving-cert ca bundle for the webhook annotation.

For KinD cluster, need to add master label for the node. (TODO: remove this step.)
```
kubectl label nodes kind-control-plane node-role.kubernetes.io/master=
```

Install the operator.
```
kubectl apply -k prepare/service-ca/crds
kubectl apply -k prepare/service-ca/manifests
```

## Install MCE 
1. Create ns `multicluster-engine`.

```
kubectl create ns multicluster-engine
```
2. Create image pull secret named `open-cluster-management-image-pull-credentials` in the ns `multicluster-engine`.

```
kubectl apply -f image-pullsecret.yaml -n multicluster-engine 

```

3. Install MCE catalogSource and subscription.

    Option 1: Install dev MCE catalogSource and subscription. 

    Change the image in multicluster-engine/olm-dev/catalogsource.yaml
and then deploy
    ```
    kubectl apply -k multicluster-engine/olm-dev
    ```

    Option 2: Install release MCE catalogSource and subscription.
    Change the image in multicluster-engine/olm-release/catalogsource.yaml
and then deploy
    ```
    kubectl apply -k multicluster-engine/olm-release
    ```
    Currently, cannot pull the MCE operator image since there is no image pull secret in the released csv.  

4. Install multicluster-engine CR and klusterletConfig

 Change the hubKubeAPIServerURL in multicluster-engine/samples/klusterletconfig.yaml 
 and then deploy.
```
kubectl apply -k multicluster-engine/samples
```


## Install policy addon

