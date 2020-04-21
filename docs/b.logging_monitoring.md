# Logging/Monitoring (5%)


## Curriculum
* Understand how to monitor all cluster components. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)
* Understand how to monitor applications.
* Manage cluster component logs. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/#looking-at-logs)
* Manage application logs. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

### Exercise

1. Install the Kubernetes Metrics Server.
    <details><summary>show</summary>
    <p>

    ```bash
    git clone https://github.com/kubernetes-incubator/metrics-server.git

    kubectl create -f  metrics-server/deploy/1.8+/
    ```

    </p>
    </details>

1. Check how many nodes your cluster have. Describe one.
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

1. Check the number of pods running in one node.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods --all-namespaces -o wide | grep <NODE_NAME> | wc -l
    ```

    </p>
    </details>  

1. Check the request and limits memory of the API server pod.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl describe pods <API_SERVER_POD_NAME>
    # Check the resources tag
    
    or

    kubectl get pods -n kube-system -o=jsonpath='{.metadata.name}{"\t"}{.spec.containers[*].resources.requests.memory}{"\t"}{.spec.containers[*].resources.limits.memory}' <API_SERVER_POD_NAME>
    ```

    </p>
    </details>

1. Create the following pod. Print Logs for a Container in a Pod.

    ```bash
    kubectl create -f https://raw.githubusercontent.com/roxcarpio/cka-exercises/master/exercices/b.logging_monitoring/log-pod.yaml
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl logs generator-random-numbers
    ```

    </p>
    </details>

1. Printing only the logs since 30s.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl logs generator-random-numbers --since=30s
    ```

    </p>
    </details>