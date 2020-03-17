# Scheduling (5%)

## Curriculum

* [Use label selectors to schedule Pods.](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
* [Understand the role of DaemonSets.](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
* [Understand how resource limits can affect Pods scheduling.](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/)
* [Understand how to run multiple schedulers and how to configure Pods to use them.](https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/)
* [Manually schedule a pod without a scheduler.](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/)
* [Display scheduler events.](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/)
* [Know how to configure the Kubernetes scheduler.](https://kubernetes.io/docs/concepts/scheduling/kube-scheduler/)

## Extra Links
* [Kubernetes.io - Managing Compute Resources for Containers.](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container)

### Exercice

1. Create the following enviroment for the next exercices.

    ```bash
    kubectl run --generator=run-pod/v1 nginx-1 --image=nginx --labels=tier=frontend,env=dev,author=john
    kubectl run --generator=run-pod/v1 nginx-2 --image=nginx --labels=tier=download-service,env=dev,author=eve
    kubectl run --generator=run-pod/v1 nginx-3 --image=nginx --labels=tier=chat-ui,env=dev,author=eve
    kubectl run --generator=run-pod/v1 nginx-4 --image=nginx --labels=tier=fronend,env=prod,author=john
    ```

    1. List pods and show labels for all pods
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl get pods --show-labels

        NAME      READY   STATUS    RESTARTS   AGE   LABELS
        nginx-1   1/1     Running   0          28s   author=john,env=dev,tier=frontend
        nginx-2   1/1     Running   0          28s   author=eve,env=dev,tier=download-service
        nginx-3   1/1     Running   0          28s   author=eve,env=dev,tier=chat-ui
        nginx-4   1/1     Running   0          27s   author=john,env=prod,tier=fronend
        ```

        </p>
        </details>

    1. List pods with label `env=dev`
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl get pods -l env=dev --show-labels

        NAME      READY   STATUS    RESTARTS   AGE    LABELS
        nginx-1   1/1     Running   0          9m1s   author=john,env=dev,tier=frontend
        nginx-2   1/1     Running   0          9m1s   author=eve,env=dev,tier=download-service
        nginx-3   1/1     Running   0          9m1s   author=eve,env=dev,tier=chat-ui
        ```

        </p>
        </details>

    1. List pods with label `author!=john`
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl get pods -l author!=john --show-labels

        NAME      READY   STATUS    RESTARTS   AGE   LABELS
        nginx-2   1/1     Running   0          12m   author=eve,env=dev,tier=download-service
        nginx-3   1/1     Running   0          12m   author=eve,env=dev,tier=chat-ui
        ```

        </p>
        </details>

    1. List pods with label `author=eve` and `tier!=chat-ui`
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl get pods -l author=eve,tier!=chat-ui --show-labels

        NAME      READY   STATUS    RESTARTS   AGE    LABELS
        nginx-2   1/1     Running   0          102s   author=eve,env=dev,tier=download-service
        ```

        </p>
        </details>   

    1. Update pod `nginx-1` with the label `release` and the value `1.3.0`.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label pods nginx-1 release=1.3.0

        kubectl get pods -l release=1.3.0 --show-labels

        NAME      READY   STATUS    RESTARTS   AGE     LABELS
        nginx-1   1/1     Running   0          3m45s   author=john,env=dev,release=1.3.0,tier=frontend
        ```

        </p>
        </details>

    1. Update pod `nginx-3` with the label `author` and the value `alice`, overwriting any existing value.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label --overwrite pods nginx-3 author=alice

        kubectl get pods -l author=alice --show-labels

        NAME      READY   STATUS    RESTARTS   AGE     LABELS
        nginx-3   1/1     Running   0          4m46s   author=alice,env=dev,tier=chat-ui
        ```

        </p>
        </details>  

    1. Update pod `nginx-4` by removing a label named `tier` if it exists.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label pods nginx-4 tier-

        kubectl get pods nginx-4 --show-labels

        NAME      READY   STATUS    RESTARTS   AGE     LABELS
        nginx-4   1/1     Running   0          6m26s   author=john,env=prod
        ```

        </p>
        </details>    

    1. Delete all pods for cleaning the enviroment
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl delete pods --all
        ```
        or 
        ```bash
        kubectl delete pod nginx-1
        kubectl delete pod nginx-2
        kubectl delete pod nginx-3
        kubectl delete pod nginx-4
        ```

        </p>
        </details>

1. List nodes. Update node `node01` with the label `tier` and the value `backend`. List the nodes again and show the labels.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get nodes
    NAME     STATUS   ROLES    AGE    VERSION
    master   Ready    master   110m   v1.14.0
    node01   Ready    <none>   110m   v1.14.0

    kubectl label nodes node01 tier=backend

    kubectl get nodes --show-labels
    NAME     STATUS   ROLES    AGE    VERSION   LABELS
    master   Ready    master   110m   v1.14.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=master,kubernetes.io/os=linux,node-role.kubernetes.io/master=
    node01   Ready    <none>   110m   v1.14.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=node01,kubernetes.io/os=linux,tier=backend
    ```

    </p>
    </details>

1. Create a taint on `node01` with key of 'author', value of 'john' and effect of 'NoSchedule'
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl taint nodes node01 author=john:NoSchedule
    ```

    </p>
    </details>

1. Create a pod named `nginx-5` with the NGINX image, which has a toleration set equal to the taint "john"
    <details><summary>show</summary>
    <p>

    ```bash
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-5
    spec:
      containers:
      - name: nginx
        image: nginx
        imagePullPolicy: IfNotPresent
      tolerations:
      - key: "author"
        operator: "Equal"
        value: "john"
        effect: "NoSchedule"
    EOF        
    ```

    </p>
    </details>

 1. Create a pod named `nginx-6` with the NGINX image, which has a toleration set equal to the taint "eve". Check the status of the pod.
    <details><summary>show</summary>
    <p>

    ```bash
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx-6
    spec:
      containers:
      - name: nginx
        image: nginx
        imagePullPolicy: IfNotPresent
      tolerations:
      - key: "author"
        operator: "Equal"
        value: "eve"
        effect: "NoSchedule"
    EOF

    kubectl get pods

    NAME      READY   STATUS    RESTARTS   AGE
    nginx-5   1/1     Running   0          14m     
    nginx-6   0/1     Pending   0          16m                
    ```
    > _Explanation:_ Error: 0/2 nodes are available: 2 node(s) had taints that the pod didn't tolerate. The pod will not be able to schedule onto the node01, because there is no toleration matching the eve taint.

    </p>
    </details>   

1. Remove from node `node01` all the taints with key 'author' and effect of 'NoSchedule'. Check again the status of the pods. Remove all pods.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl taint nodes node01 author:NoSchedule-

    kubectl get pods

    NAME      READY   STATUS    RESTARTS   AGE
    nginx-5   1/1     Running   0          17m     
    nginx-6   1/1     Running   0          19m 

    kubectl delete pods --all
    ```

    </p>
    </details>

1. Create a nginx Deamonset called nginx-deamon.
    <details><summary>show</summary>
    <p>

    ```bash
    cat <<EOF | kubectl apply -f -
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: nginx-deamon
      labels:
        name: nginx
    spec:
      selector:
        matchLabels:
          name: nginx
      template:
        metadata:
          labels:
            name: nginx
        spec:
          tolerations:
          - key: node-role.kubernetes.io/master
            effect: NoSchedule
          containers:
          - name: nginx-pod
            image: nginx 
    EOF
    ```

    </p>
    </details>

1. Create a deployment named `nginx-7` with the NGINX image, which has cpu requests to "200m" and memory limits to "512Mi"
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=deployment/v1beta1 nginx-7 --image=nginx --requests=cpu=200m --limits=memory=512Mi
    ```

    </p>
    </details>

1. Set the `nginx-7` deployment cpu request to "5". Get the pod events. Remove the deployment.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl set resources deployment nginx-7 --requests=cpu=5

    kubectl describe pods nginx-7-6776b99666-xghjt
    Events:
    Type     Reason            Age                   From               Message
    ----     ------            ----                  ----               -------
    Warning  FailedScheduling  23s (x10 over 9m16s)  default-scheduler  0/2 nodes are available: 2 Insufficient cpu.

    kubectl delete deploy nginx-7
    ```
    > _Explanation:_ the Pod named “nginx-7-6776b99666-xghjt” fails to be scheduled due to insufficient CPU resource on the node. 

    </p>
    </details>

1. Create a static nginx pod on the `node01`. Configure the kubelet on the node01 to use the `/tmp/static-pods` for creating static pods.
    <details><summary>show</summary>
    <p>

    ```bash
    ssh node01

    mkdir /tmp/static-pods

    vim /var/lib/kubelet/config.yaml
      ...
      runtimeRequestTimeout: 3m0s
      serializeImagePulls: true
      staticPodPath: /tmp/static-pods  # Modify this line to point to the static pods watcher directory
      streamingConnectionIdleTimeout: 4h0m0s

    systemctl status kubelet.service

    cat <<EOF >/tmp/static-pods/static-nginx.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: static-nginx
      namespace: default
    spec:
      containers:
        - name: nginx
          image: nginx
    EOF
    ```
    kubectl get pods
    NAME                  READY   STATUS    RESTARTS   AGE
    static-nginx-node01   1/1     Running   0          32s
    </p>
    </details>

1. Configure a second kubernetes scheduler. 
    > _Tipp:_ Use the k8s.gcr.io/kube-scheduler:v1.15.0 docker image 

    <details><summary>show</summary>
    <p>

    ```bash
    # Define a Kubernetes Deployment for the scheduler
    vim my-scheduler.yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: my-scheduler
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: my-scheduler-as-kube-scheduler
    subjects:
    - kind: ServiceAccount
      name: my-scheduler
      namespace: kube-system
    roleRef:
      kind: ClusterRole
      name: system:kube-scheduler
      apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      labels:
        component: scheduler
        tier: control-plane
      name: my-scheduler
      namespace: kube-system
    spec:
      selector:
        matchLabels:
          component: scheduler
          tier: control-plane
      replicas: 1
      template:
        metadata:
          labels:
            component: scheduler
            tier: control-plane
            version: second
        spec:
          serviceAccountName: my-scheduler
          containers:
          - command:
            - kube-scheduler
            - --bind-address=0.0.0.0
            - --kubeconfig=/etc/kubernetes/scheduler.conf
            - --leader-elect=false
            - --scheduler-name=my-scheduler
            image: k8s.gcr.io/kube-scheduler:v1.15.0
            livenessProbe:
              httpGet:
                path: /healthz
                port: 10251
              initialDelaySeconds: 15
            name: kube-second-scheduler
            readinessProbe:
              httpGet:
                path: /healthz
                port: 10251
            resources:
              requests:
                cpu: '0.1'
            securityContext:
              privileged: false
            volumeMounts:
            - mountPath: /etc/kubernetes/scheduler.conf
              name: kubeconfig
              readOnly: true
          hostNetwork: false
          nodeName: master
          hostPID: false
          volumes:
          - hostPath:
              path: /etc/kubernetes/scheduler.conf
              type: FileOrCreate
            name: kubeconfig

    # Creatte the deployment running
    kubectl create -f my-scheduler.yaml

    # Verify that the scheduler pod is running:
    kubectl get pods --namespace=kube-system

    # Add your scheduler name to the resourceNames
    kubectl edit clusterrole system:kube-scheduler

    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
      metadata:
      annotations:
        rbac.authorization.kubernetes.io/autoupdate: "true"
      labels:
        kubernetes.io/bootstrapping: rbac-defaults
    name: system:kube-scheduler
    rules:
    - apiGroups:
      - ""
      resourceNames:
      - kube-scheduler
      # Add this line
      - my scheduler
      resources:
      - endpoints
      verbs:
      - delete
      - get
      - patch
      - update    

    # Create a pod without specifing a scheduler
    vim pod1.yaml

    apiVersion: v1
    kind: Pod
    metadata:
      name: no-annotation
      labels:
        name: multischeduler-example
    spec:
      containers:
      - name: pod-with-no-annotation-container
        image: k8s.gcr.io/pause:2.0

    kubectl create -f pod1.yaml

    # Create a pod and specify the default scheduler
    vim pod2.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: annotation-default-scheduler
      labels:
        name: multischeduler-example
    spec:
      schedulerName: default-scheduler
      containers:
      - name: pod-with-default-annotation-container
        image: k8s.gcr.io/pause:2.0

    kubectl create -f pod2.yaml 

    # Create a pod and specify the second scheduler   
    vim pod3.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: annotation-second-scheduler
      labels:
        name: multischeduler-example
    spec:
      schedulerName: my-scheduler
      containers:
      - name: pod-with-default-annotation-container
        image: k8s.gcr.io/pause:2.0

    kubectl create -f pod3.yaml

    # Verify that all pods are running
    kubectl get pods

    # Verifying that the pods were scheduled using the desired schedulers
    kubectl get events
    ```

    </p>
    </details>