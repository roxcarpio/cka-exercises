# Networking (11%)

* Understand the networking configuration on the cluster nodes. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/cluster-administration/networking/)
* Understand Pod networking concepts.
* Understand service networking. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/services-networking/service/)
* Know how to use Ingress rules. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* Know how to configure and use the cluster DNS. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
* Understand CNI. [![en](../icons/united-kingdom.png)](http://www.dasblinkenlichten.com/understanding-cni-container-networking-interface/)
 
### Extra Links
* [How Kubernetes Networking Works – The Basics](https://neuvector.com/network-security/kubernetes-networking/)
* [How Kubernetes Networking Works – Under the Hood](https://neuvector.com/network-security/advanced-kubernetes-networking/)
* [Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
* [Illustrated Guide to Kubernetes Networking](https://speakerdeck.com/thockin/illustrated-guide-to-kubernetes-networking?slide=3)
* Check iptables master node
* check iptable slave node
* check the configuration por pods and servces ip
* Create an endpoint

### Exercise

1. Check the port range that it is possible to use in your cluster.
    <details><summary>show</summary>
    <p>

    ```bash
    # check the name of the apiserver pod
    kubectl get pods -n kube-system
    NAME                                      READY   STATUS             RESTARTS   AGE
    coredns-fb8b8dccf-hfsxj                   1/1     Running            1          19m
    coredns-fb8b8dccf-vc7jt                   1/1     Running            1          19m
    etcd-master                               1/1     Running            0          18m
    kube-apiserver-master                     1/1     Running            0          18m
    kube-controller-manager-master            1/1     Running            0          18m
    kube-keepalived-vip-hq77s                 1/1     Running            0          19m
    kube-proxy-82kqs                          1/1     Running            0          19m
    kube-proxy-dn5h6                          1/1     Running            0          19m
    kube-scheduler-master                     1/1     Running            0          18m
    weave-net-kcg9q                           2/2     Running            1          19m
    weave-net-rgf92                           2/2     Running            1          19m

    kubectl get pods -n kube-system -o yaml kube-apiserver-master | grep service-node-port-range
    <empty output>
    ```
    This means that we are using the default configuration.
    
    Pod range: 30000-32767

    </p>
    </details> 

1. Change the port range to 30000-30100 used by kubernetes to create NodePort services.
    <details><summary>show</summary>
    <p>

    ```bash
    vim /etc/kubernetes/manifests/kube-apiserver.yaml
    Add the following line in the command tag:
        - --service-node-port-range=30000-30100

    # check it:
    kubectl get pods -n kube-system -o yaml kube-apiserver-master | grep service-node-port-range
    ```

    </p>
    </details> 

1. Create a ClusterIP service named my-cluster-headless-svc (in headless mode).
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service clusterip my-cluster-headless-svc --clusterip="None"
    ```

    </p>
    </details>

1. Create a ClusterIP service named my-cluster-svc with target port 8080 and port 80.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service clusterip my-cluster-svc --tcp=80:8080
    ```

    </p>
    </details>

1. Create a NodePort service named my-nodeport-1-svc using with target port 8080 and port 5678. Do not specify a node-port.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service nodeport my-nodeport-1-svc --tcp=5678:8080
    ```

    </p>
    </details>

1. Create a NodePort service named my-nodeport-2-svc using with target port 8080, port 5678 and node-port 20000.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service nodeport my-nodeport-2-svc --tcp=5678:8080  --node-port=20000
    ```
    > The Service "my-nodeport-2-svc" is invalid: spec.ports[0].nodePort: Invalid value: 20000: provided port is not in the valid range. The range of valid ports is 30000-30100

    </p>
    </details>    

1. Create a NodePort service named my-nodeport-2-svc using with target port 8080, port 5678 and node-port 30010.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service nodeport my-nodeport-2-svc --tcp=5678:8080  --node-port=30010
    ```

    </p>
    </details> 

1. Create a LoadBalancer service named my-lbs
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. Create a ExternalName service named my-en-svc using with target port 8080, port 80 and external name of service google.es
    <details><summary>show</summary>
    <p>

    ```bash
     kubectl create service externalname my-en-svc --external-name=google.es --tcp=80:8080
    ```

    </p>
    </details>

1. Create a Cluster IP multi-Port services.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create service clusterip multi-port-svc --tcp=80:9376 --tcp=443:9377
    ```

    </p>
    </details>

1. Check the service-cluster-ip-range CIDR range that is configured for the API server in your cluster.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods -n kube-system -o yaml kube-apiserver-master | grep service-cluster-ip-range
        - --service-cluster-ip-range=10.96.0.0/12
    ```

    </p>
    </details>

1. For example, if you have a Service called "my-service" in a Kubernetes Namespace "my-ns", the control plane and the DNS Service acting together create a DNS record for "my-service.my-ns". Pods in the "my-ns" Namespace should be able to find it by simply doing a name lookup for my-service ("my-service.my-ns" would also work).
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. Kubernetes also supports DNS SRV (Service) records for named ports. If the "my-service.my-ns" Service has a port named "http" with protocol set to TCP, you can do a DNS SRV query for _http._tcp.my-service.my-ns to discover the port number for "http", as well as the IP address.
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>


1. For example, if you start kube-proxy with the --nodeport-addresses=127.0.0.0/8 flag, kube-proxy only selects the loopback interface for NodePort Services. The default for --nodeport-addresses is an empty list. This means that kube-proxy should consider all available network interfaces for NodePort. (That’s also compatible with earlier Kubernetes releases).
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. Create a pods exposing a services and check the enviroment variables. 
    > Kubelet adds a set of environment variables for each active Service.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=run-pod/v1 nginx --image=nginx --port 80 --expose
    
    kubectl exec nginx -- printenv | grep NGINX
    ```

    </p>
    </details>

1. Check your pods’ IPs, You should be able to ssh into any node in your cluster and curl both IPs.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods -o wide
    NAME    READY   STATUS    RESTARTS   AGE    IP          NODE     NOMINATED NODE   READINESS GATES
    nginx   1/1     Running   0          2m5s   10.44.0.1   node01   <none>           <none>

    From the node01:
    curl 10.44.0.1
    ```

    </p>
    </details>

1. Check the endpoints, and note that the IPs are the same as the Pods created in the first step.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl describe svc nginx
    kubectl get ep nginx
    ```

    </p>
    </details>
 
1. What is the network interface configured for cluster connectivity on the master node?
    <details><summary>show</summary>
    <p>

    ```bash
    ip link
    ```

    </p>
    </details>  
1. IP address assigned to the master node.
    <details><summary>show</summary>
    <p>

    ```bash
    ip addr
    ```

    </p>
    </details>  
1. Ip address assigned to the node02.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get nodes -o wide
    ```

    </p>
    </details>  
1. What is the interface/bridge created by docker on this host
    <details><summary>show</summary>
    <p>

    ```bash
    ssh node02  ; ip addr
    ```

    </p>
    </details>  

1. State of the  interface docker0
    <details><summary>show</summary>
    <p>

    ```bash
    ip link show docker0
    ```

    </p>
    </details>   

1. What is the IP address of the Default Gateway?
    <details><summary>show</summary>
    <p>

    ```bash
    ip route show default
    ```

    </p>
    </details>   

1. What is the port the kube-proxy is listing on in the master node?
    <details><summary>show</summary>
    <p>

    ```bash
    netstat -nplt
    ```

    </p>
    </details>   

1. Inspect the kubelet service and identify the network plugin configured for Kubernetes.
    <details><summary>show</summary>
    <p>

    ```bash
    master $ ps aux | grep kubelet
root      1621  2.7  4.9 833032 101036 ?       Ssl  15:08   0:20 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --cgroup-driver=cgroupfs --cni-bin-dir=/opt/cni/bin --cni-conf-dir=/etc/cni/net.d --network-plugin=cni
    ```

    </p>
    </details>   

1. What binary executable file will be run by kubelet after a container and its associated namespace are created.
    <details><summary>show</summary>
    <p>

    ```bash
    cat /etc/cni/net.d/10-weave.conf
    ```

    </p>
    </details>                   


1. What is the POD IP address range configured by weave?
    <details><summary>show</summary>
    <p>

    ```bash
    ip addr show weave
    ```

    </p>
    </details>


1. What is the default gateway configured on the PODs scheduled on node03?
    <details><summary>show</summary>
    <p>

    ```bash
    ssh node03 ip route
    10.32.0.0/12 dev weave  proto kernel  scope link  src 10.38.0.0
    ```

    </p>
    </details>


1. What network range are the nodes in the cluster part of?
    <details><summary>show</summary>
    <p>

    ```bash
    ip addr
    ```

    </p>
    </details>

1. What is the range of IP addresses configured for PODs on this cluster?
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl logs -n kube-system weave-net-94n72 -c weave | grep ipalloc
    ```

    </p>
    </details>

1. What is the IP Range configured for the services within the cluster?
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl describe pods -n kube-system kube-apiserver-master | grep service
    ```

    </p>
    </details>