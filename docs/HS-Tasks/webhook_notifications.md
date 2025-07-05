got to marvin.: monitoring
+

got the values in the helm repo of their gitlab repo  monitoring  > prometheus> helm 


do helm repo update on their ns too 

# we need to update as the teams is until the .28 version 
so Steps
-  do helm repo update on their ns too 
- 
mv values > old_values.yaml

helm show values repo/url --version <> > values.yaml



WE need to manual add the crd and then apply the upgrade with the values.yaml 5to be able to upgrade to the latest major version iof prometheus



------------------
hrlm ls
to check for revision 

k get secrets

db-pxc-db had same values 
