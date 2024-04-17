# deploy-aks


## Install multicluster-engine 

1. Download operator-sdk from https://github.com/operator-framework/operator-sdk/releases/tag/v1.34.1
2. Install olm

```
operator-sdk olm install 
```
3. Install service-ca operator

```
kubectl label nodes kind-control-plane node-role.kubernetes.io/master=

kubectl apply -k multicluster-engine/service-ca/crds
kubectl apply -k multicluster-engine/service-ca/manifests
```
4. create ns multicluster-engine 

```
kubectl create ns multicluster-engine
```
5. create image pull secret (optional)

```
kubectl apply -f image-pullsecret.yaml -n multicluster-engine 

```
6. install MCE operator 

change the image in multicluster-engine/olm/catalogsource.yaml
and then deploy
```
kubectl apply -k multicluster-engine/olm
```

7. Install multicluster-engine CR and klusterletConfig

 change the hubKubeAPIServerURL in multicluster-engine/samples/klusterletconfig.yaml 
 and then deploy
```
kubectl apply -k multicluster-engine/sammples
```

## Install policy addon

