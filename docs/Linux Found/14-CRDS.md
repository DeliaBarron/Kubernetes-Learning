# Custom Resources Definitions
Once these Resources have been added, the objects can be created and accessed using standard calls and commands, like kubectl.  The creation of a new object stores new structured data in the etcd database and allow access via `kube-apiserver`.

If you add a new API object and controller you can use the existing kube-apiserver to maonitor the object.

apiextensions.k8s.io/v1.