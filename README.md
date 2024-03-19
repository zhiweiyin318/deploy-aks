# deploy-aks

## Install all manifests

1. Apply prerequisites CRDs and Create `open-cluster-management` ns.

```
kubectl apply -k deploy/prerequisites
```
2. Create an image pull secret named `multiclusterhub-operator-pull-secret` in `open-cluster-management` ns.
3. Install cluster-manager.

```
kubectl apply -k deploy/cluster-manager
```

4. Create clusterManager CR.

```
kubectl apply -k deploy/cluster-manager/samples
```
5. Install foundation.

```
kubectl apply -k deploy/foundation
```

6. Set hub apiserver URL to the `spec.hubKubeAPIServerURL` in the `deploy/foundation/klusterletconfig/klusterletconfig.yaml`

```
kubectl apply -k deploy/foundation/klusterletconfig
```

7. Install addons.

```
kubectl apply -k deploy/addons
```

8. Import local-cluster.

```
kubectl apply -k deploy/local-cluster
```

## Install multicluster-engine 

### Option 1
```
kubectl apply -k multicluster-engine/olm
```

### Option 2
```
kubectl apply -k multicluster-engine/operator
```

## Install multicluster-engine CR
```
kubectl apply -k multicluster-engine/sammples
```

## Install policy addon
