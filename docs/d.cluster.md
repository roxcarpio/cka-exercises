# Cluster (11%)

## Curriculum
* [Understand Kubernetes cluster upgrade process.](https://kubernetes.io/docs/tasks/administer-cluster/cluster-management/#upgrading-a-cluster)
   * [Kubeadm upgrade](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-upgrade/)
   * [Kubeadm Upgrade 1.14](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade-1-14/)
* [Facilitate operating system upgrades.](https://kubernetes.io/docs/tasks/administer-cluster/cluster-management/#maintenance-on-a-node)
* [Implement backup and restore methodologies.](https://elastisys.com/2018/12/10/backup-kubernetes-how-and-why/)

## Extra Links
* [Backup and Restore a Kubernetes Master with Kubeadm](https://labs.consol.de/kubernetes/2018/05/25/kubeadm-backup.html)

### Exercice

1. Create a kubernetes cluster version 1.14 using kubeadm. The architecture of the cluster is: 1 node-plane and 2 slaves-nodes.
    <details><summary>show</summary>
    <p>


    ```bash
    ## CONTROL-PLANE Configuration 

    # Update the package manager and install some dependencies
    sudo apt-get update -y && sudo apt-get install -y apt-transport-https curl
    
    # Install runtime
    sudo apt-get install docker.io -y

    # Install kubelet, kubectl  and kubeadm version 1.14.6 using sudo
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    apt-get update
    apt-get install -y kubelet=1.14.6-00 kubeadm=1.14.6-00 kubectl=1.14.6-00
    apt-mark hold kubelet kubeadm kubectl    

    # Create the control-plane node
    sudo kubeadm init

    # To start using your cluster, you need to run the following as a regular user:
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # Install the newtork pluging (e.g weave)
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

    Then you can join any number of worker nodes by running the following on each as root:

    sudo kubeadm join 10.128.0.37:6443 --token 4fgl53.q60ets7mhwoqe0ou \
    --discovery-token-ca-cert-hash sha256:18df297e0728067a85ff0e402f10ef3e21aabeb375af59925afa1a6128df4408

    ## WORKER Configuration 

    # Update the package manager and install some dependencies
    sudo apt-get update -y && sudo apt-get install -y apt-transport-https curl
    
    # Install runtime
    sudo apt-get install docker.io -y

    # Install kubelet and kubeadm version 1.14.6 using sudo
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    apt-get update
    apt-get install -y kubelet=1.14.6-00 kubeadm=1.14.6-00
    apt-mark hold kubelet kubeadm

    # Join the cluster
    sudo kubeadm join 10.128.0.37:6443 --token wdpxq6.bbk30i0ggx31w5ih \
    --discovery-token-ca-cert-hash sha256:18df297e0728067a85ff0e402f10ef3e21aabeb375af59925afa1a6128df4408    
    ```

    </p>
    </details>

1. Create a nginx deployment with 6 replicas.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=deployment/v1beta1 nginx --image=nginx --replicas=6
    ```

    </p>
    </details>

1. Get the pods details using -o wide 
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods -o wide 

    NAME                     READY   STATUS    RESTARTS   AGE     IP          NODE     NOMINATED NODE   READINESS GATES
    nginx-7c66db5c95-9vpsg   1/1     Running   0          5m51s   10.44.0.4   node-1   <none>           <none>
    nginx-7c66db5c95-j8w8c   1/1     Running   0          5m51s   10.36.0.2   node-2   <none>           <none>
    nginx-7c66db5c95-rtps9   1/1     Running   0          5m51s   10.36.0.4   node-2   <none>           <none>
    nginx-7c66db5c95-tv8n6   1/1     Running   0          5m51s   10.44.0.5   node-1   <none>           <none>
    nginx-7c66db5c95-xgchs   1/1     Running   0          5m51s   10.44.0.3   node-1   <none>           <none>
    nginx-7c66db5c95-zbst8   1/1     Running   0          5m51s   10.36.0.3   node-2   <none>           <none>
    ```

    </p>
    </details>

1. Expose the deployment using the port 80
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl expose deploy nginx --port=80
    ```

    </p>
    </details>

1. Create a backup of the etc key store.
    <details><summary>show</summary>
    <p>

    ```bash
    mkdir -p backup

    # Backup certificates
    sudo cp -r /etc/kubernetes/pki backup/
    
    # Make etcd snapshot
    ETCDCTL_API=3 etcdctl snapshot save snapshot.db
    ls
    ```

    </p>
    </details>   

1. Upgrade the cluster to version 1.15.
    <details><summary>show</summary>
    <p>

    ```bash
    ## CONTROL-PLANE Update

    # Find version 1.15 
    sudo apt update
    sudo apt-cache policy kubeadm

    # Upgrade kubeadm
    sudo apt-mark unhold kubeadm && \
    sudo apt-get update && sudo apt-get install -y kubeadm=1.15.0-00 && \
    sudo apt-mark hold kubeadm

    # Upgrade the control-plane
    sudo kubeadm upgrade plan
    sudo kubeadm upgrade apply v1.15.0

    # Upgrade kubelet and kubectl
    sudo apt-mark unhold kubelet kubectl && \
    sudo apt-get update && sudo apt-get install -y kubelet=1.15.0-00 kubectl=1.15.0-00 && \
    sudo apt-mark hold kubelet kubectl

    # Restart kubelet
    sudo systemctl restart kubelet

    ## WORKER NODE Update
    ## Node-1 

    # Upgrade kubeadm
    sudo apt-mark unhold kubeadm && \
    sudo apt-get update && sudo apt-get install -y kubeadm=1.15.0-00 && \
    sudo apt-mark hold kubeadm    

    # Prepare the node for maintenance
    kubectl drain node-1 --ignore-daemonsets # Run it in the control-plane
    
    # Upgrade the kubelet configuration
    sudo kubeadm upgrade node

    # Upgrade kubelet and kubectl
    sudo apt-mark unhold kubelet kubectl && \
    sudo apt-get update && sudo apt-get install -y kubelet=1.15.0-00 kubectl=1.15.0-00 && \
    sudo apt-mark hold kubelet kubectl

    # Restart kubelet
    sudo systemctl restart kubelet
    kubectl uncordon node-1 # Run it in the control-plane

    ## Node-2

    # Upgrade kubeadm
    sudo apt-mark unhold kubeadm && \
    sudo apt-get update && sudo apt-get install -y kubeadm=1.15.0-00 && \
    sudo apt-mark hold kubeadm    

    # Prepare the node for maintenance
    kubectl drain node-2 --ignore-daemonsets # Run it in the control-plane
    
    # Upgrade the kubelet configuration
    sudo kubeadm upgrade node config --kubelet-version $(kubelet --version | cut -d ' ' -f 2)

    # Upgrade kubelet and kubectl
    sudo apt-mark unhold kubelet kubectl && \
    sudo apt-get update && sudo apt-get install -y kubelet=1.15.0-00 kubectl=1.15.0-00 && \
    sudo apt-mark hold kubelet kubectl

    # Restart kubelet
    sudo systemctl restart kubelet
    
    kubectl uncordon node-2 # Run it in the control-plane

    # Verify the status of the cluster
    kubectl get nodes # Run it in the control-plane
    ```

    </p>
    </details>

1. Delete all nginx pods.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl delete deploy nginx
    ```

    </p>
    </details>

1. Restore the etcd backup
    <details><summary>show</summary>
    <p>

    ```bash
    ETCDCTL_API=3 etcdctl \
    snapshot restore snapshot.db \
    --data-dir /var/lib/etcd-from-backup \
    --initial-cluster master-1=https://<IP_MASTER_1>:2380 \
    --initial-cluster-token etcd-cluster-1 \
    --initial-advertise-peer-urls https://${INTERNAL_IP}:2380

    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. HOLI
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>     