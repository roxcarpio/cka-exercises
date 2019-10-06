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
https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/

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
        ```

        </p>
        </details>   

    1. Update pod `nginx-1` with the label `release` and the value `1.3.0`.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label pods nginx-1 release=1.3.0
        ```

        </p>
        </details>

    1. Update pod `nginx-3` with the label `author` and the value `alice`, overwriting any existing value.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label --overwrite pods nginx-3 author=alice
        ```

        </p>
        </details>  

    1. Update pod `nginx-4` by removing a label named `tier` if it exists.
        <details><summary>show</summary>
        <p>

        ```bash
        kubectl label pods nginx-4 tier-
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

1. List nodes. Update node `node01` with the label `tier` and the value `backend`.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get nodes
    NAME     STATUS   ROLES    AGE   VERSION
    master   Ready    master   62m   v1.14.0
    node01   Ready    <none>   61m   v1.14.0
    node02   Ready    <none>   60m   v1.14.0

    kubectl label nodes node01 tier=backend
    ```

    </p>
    </details>

1. Create a taint on node01 with key of 'spray', value of 'mortein' and effect of 'NoSchedule'
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl taint nodes node01 spray=mortein:NoSchedule
    ```

    </p>
    </details>

1. ate another pod named 'bee' with the NGINX image, which has a toleration set to the taint Mortein
    <details><summary>show</summary>
    <p>

    ```bash
    solution
    ```

    </p>
    </details>

1. Remove from node 'foo' all the taints with key 'dedicated'
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

1. Configure a second kubernetes scheduler. 
    > _Tipp:_ Use the k8s.gcr.io/kube-scheduler:v1.14.0 docker image 

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
            image: k8s.gcr.io/kube-scheduler:v1.14.0
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