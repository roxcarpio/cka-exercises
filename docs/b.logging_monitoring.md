# Logging/Monitoring (5%)


## Curriculum
* [Understand how to monitor all cluster components.](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)
* Understand how to monitor applications.
* [Manage cluster component logs.](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)
* [Manage application logs.](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

number of healthy nodes
Deploy the metrics servers in kubernets... Give some time to see the metrics and then use kubectl get top
Once you do remember to wait for atleast 5 minutes to allow the metrics-server enough time to collect and report performance metrics.
kubectl top pod POD_NAME --containers               # Show metrics for a given pod and its containers

## Extra Links

### Exercice

1. Install the Kubernetes Metrics Server
    <details><summary>show</summary>
    <p>

    ```bash
    git clone https://github.com/kubernetes-incubator/metrics-server.git

    kubectl create -f  metrics-server/deploy/1.8+/
    ```

    </p>
    </details>

1. Check how many nodes your cluster. Describe one.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get nodes
    NAME       STATUS   ROLES         AGE    VERSION
    k8s-0001   Ready    master,node   26d    v1.9.2+coreos.0
    k8s-0002   Ready    master,node   26d   v1.9.2+coreos.0
    k8s-0003   Ready    master,node   26d   v1.9.2+coreos.0
    k8s-0005   Ready    node          26d   v1.9.2+coreos.0

    kubectl describe nodes k8s-0001     
    ```

    </p>
    </details>

1. List the nodes with a custom columns (NAME, CAPACITY (CPU), CAPACITY (Memory)).
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get nodes k8s-0001  -o=custom-columns=NAME:.metadata.name,CPU:.status.capacity.cpu,MEMORY:.status.capacity.memory
    ```

    </p>
    </details>

1. Report free disk space in the master node.
    <details><summary>show</summary>
    <p>

    ```bash
    ssh master 'df -h'
    exit
    ```

    </p>
    </details>

1. Analyze the disk space usage in /etc/kubernetes/ repository.
    <details><summary>show</summary>
    <p>

    ```bash
    du -h /etc/kubernetes/
    36K     /etc/kubernetes/pki/etcd
    96K     /etc/kubernetes/pki
    20K     /etc/kubernetes/manifests
    152K    /etc/kubernetes/
    ```

    </p>
    </details>     

1. Check the number of pods running in the cluster.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods --all-namespaces -o wide | grep <NODE_NAME> | wc -l
    ```

    </p>
    </details>  

1. Check the request and limits resources of the API server pod.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl describe pods <API_SERVER_POD_NAME>
    # Check the resources tag
    ```

    </p>
    </details>

1. Create the following pod. <LINK depployment>. Print Logs for a Container in a Pod 
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl logs nginx-monitoring-65448542
    ```

    </p>
    </details>

1. Print logs for all Pods with label app=nginx
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. Printing only the logs since 30s
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl logs nginx-78f5d695bd-czm8z --since=30s
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