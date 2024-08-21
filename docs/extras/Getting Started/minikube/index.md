# Minikube
Start a 1-container k8s deployment in your local server
1. `minikube start`
2. `echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check`
3.`sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`
4. `sudo apt-get update`
5. `sudo apt-get install -y apt-transport-https ca-certificates curl gnupg`
6. ` curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg`
7. `sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring`
8. `echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list`
9. `sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list `  # helps tools such as command-not-found to work correctly
10. `sudo apt upgrade`
11. `sudo apt-get install -y kubectl`
12. `kubectl version`
13. `alias kubectl="minikube kubectl --"`
14. `kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080`
15. `kubectl get deployments`