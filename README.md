# deploy-aks


## MCE 

### dependency
webhook validating serving-cert 

operatorconditions.operators.coreos.com
multicluster-engine.v2.5.0  OLM upgrade?

### components

cluster-manager
cluster-lifecycle
server-foundation  
discovery
hypershift-local-hosting  
hypershift   ?

console-mce x

local-cluster 


## policy add-on
grc-policy-addon-controller
grc-policy-propagator  metric, validate-webhook (cert) 


## cluster-lifecycle
clusterclaims x
cluster-curator x
cluster-image-set https://github.com/stolostron/cluster-image-set-controller  ?
provider-credential-controller https://github.com/stolostron/provider-credential-controller  x
clusterlifecycle-state-metrics ? 


## server-foundation
webhook serving-cert 
proxyserver serving-cert  APIService inject-cabundle
ocm-controller  hive.openshift.io 
import-controller  hive.openshift.io

## hypershift
hypershift-addon-manager  infrastructures.config.openshift.io multiclusterengines.multicluster.openshift.io clusterserviceversions.operators.coreos.com


## discovery
discovery-operator  https://github.com/stolostron/discovery   x


1. OLM  
2. Helm/Kustomize  MCE 
3. manifests no MCE

1. webhook disable  kind  
2. non-ocp run 
3. 