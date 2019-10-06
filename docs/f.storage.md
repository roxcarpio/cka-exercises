# Storage (7%)

## Curriculum
* [Understand PersistentVolumeClaims for storage](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes)
* [Understand persistent volumes and know how to create them](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
* [Understand access modes for volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)
* [Understand persistent volume claims primitive](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
* [Understand Kubernetes storage objects](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes)
* [Know how to configure applications with persistent storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/)

### Exercice

1. Create a configmap called config-volume from a literal value. Add the ConfigMap name under the volumes section of the Pod specification (/cm-vol).
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create cm cm-volume --from-literal=file=example-config-volumen

    vim cm-pod.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: cm-volume-pod
    spec:
      containers:
        - name: test-container
          image: k8s.gcr.io/busybox
          command: [ "/bin/sh", "-c", "ls /cm-vol ; cat /cm-vol/file" ]
          volumeMounts:
          - name: config-volume
            mountPath: /cm-vol
      volumes:
        - name: config-volume
          configMap:
            # Provide the name of the ConfigMap containing the file
            name: cm-volume
      restartPolicy: Never

    kubectl create -f cm-pod.yaml 

    kubectl logs cm-volume-pod 
    ```

    </p>
    </details>


1. Create a pod with a emptyDir volume in path /etc/empty using the nginx image
    <details><summary>show</summary>
    <p>

    ```bash
    vim emptydir-pod.yaml

    apiVersion: v1
    kind: Pod
    metadata:
      name: emptydir-pod
    spec:
      containers:
      - image: nginx
        name: test-container
        volumeMounts:
        - mountPath: /etc/empty
          name: empty-volume
      volumes:
      - name: empty-volume
        emptyDir: {}

    kubectl create -f emptydir-pod.yaml

    kubectl exec emptydir-pod -- ls /etc | grep empty
    kubectl exec emptydir-pod -- ls /etc/empty        
    ```

    </p>
    </details>


1.  Mounts a directory (/tmp/host-test) from the host node’s filesystem into your Pod (/mnt/host-path). The host directory does not exist.
    <details><summary>show</summary>
    <p>

    ```bash
    vim host-pod.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: host-pod
    spec:
      containers:
      - image: nginx
        name: test-container
        volumeMounts:
        - mountPath: /mnt/host-path
          name: host-volume
      volumes:
      - name: host-volume
        hostPath:
          # directory location on host
          path: /tmp/host-test
          type: DirectoryOrCreate  

    kubectl create -f host-pod.yaml

    # Check that the volume is empty
    kubectl exec host-pod -- ls /mnt/host-path
    ```

    </p>
    </details>


1. Check in which node the previous pod is running. Go to the node and create a file in the /tmp/host-test directory. Check the file in the pod.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods -o wide
    NAME            READY   STATUS      RESTARTS   AGE   IP          NODE     NOMINATED NODE   READINESS GATES
    host-pod        1/1     Running     0          9s    10.40.0.2   node01   <none>           <none>

    ssh node01 'echo "HELLO WORLD" > /tmp/host-test/hello-world'

    kubectl exec host-pod -- ls /mnt/host-path
    kubectl exec host-pod -- cat /mnt/host-path/hello-world
    ```

    </p>
    </details>            

1. Mounts a directory (/tmp/host-created) from the host node’s filesystem using type Directory into your Pod (/mnt/host-path-2).
    <details><summary>show</summary>
    <p>

    ```bash
    vim host-pod-2.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: host-pod-2
    spec:
      containers:
      - image: nginx
        name: test-container
        volumeMounts:
        - mountPath: /mnt/host-path-2
          name: host-volume
      volumes:
      - name: host-volume
        hostPath:
          # directory location on host
          path: /tmp/host-created
          type: Directory  

    kubectl create -f host-pod-2.yaml

    kubectl describe pods host-pod-2
    The pod status is ContainerCreating because the host-volume volume can not mount the /tmp/host-created host directory.
    ```

    </p>
    </details>


1. Resolve the previous problem. Do not change the type.
    <details><summary>show</summary>
    <p>

    ```bash
    TBC
    ```

    </p>
    </details>


1. Create a secret called secret-vol from a literal value (user=john,password=pass123). Add the secret name under the volume section of the Pod specification (/tmp/passwords).
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create secret generic secret-vol --from-literal=user=john --from-literal=password=pass123

    vim secret-pod.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: secret-volume-pod
    spec:
      containers:
        - name: test-container
          image: nginx
          volumeMounts:
          - name: secret-volume
            mountPath: /tmp/passwords
      volumes:
        - name: secret-volume
          secret:
            # Provide the name of the secret containing the files
            secretName: secret-vol
      restartPolicy: Never

    kubectl create -f secret-pod.yaml

    kubectl exec secret-volume-pod -- sh -c 'ls /tmp/passwords ; cat /tmp/passwords/user' 
    ```

    </p>
    </details>


1. Change the user field of the previous secret and check that the new data has been transfered to the pod. 

     New user: eve
    ```bash
    echo -n 'eve' | base64 
    ZXZl
    ```

    <details><summary>show</summary>
    <p>
 
    ```bash
    kubectl edit secrets secret-vol
    apiVersion: v1
    data:
      password: cGFzczEyMw==
      user: ZXZl # change the user
    kind: Secret
    metadata:
      creationTimestamp: "2019-09-25T05:28:54Z"
      name: secret-vol
      namespace: default
      resourceVersion: "1105"
      selfLink: /api/v1/namespaces/default/secrets/secret-vol
      uid: 5d3c5256-df55-11e9-895a-0242ac11000d
    type: Opaque

    # wait for aprox. 1 min
    kubectl exec secret-volume-pod -- sh -c 'cat /tmp/passwords/user'  
    eve
    ```

    </p>
    </details>

1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash

    kubectl create secret generic secret-vol --from-literal=user=eve --from-literal=password=pass123 
    vim secret-pod-2.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: secret-volume-pod-2
    spec:
      containers:
        - name: test-container
          image: nginx
          volumeMounts:
          - name: secret-user-volume
            mountPath: /tmp/users
          - name: secret-pass-volume
            mountPath: /tmp/passwords          
      volumes:
        - name: secret-user-volume
          secret:
            # Provide the name of the secret containing the files
            secretName: secret-vol
            items:
            -  key: user 
               path: user-1
        - name: secret-pass-volume
          secret:
            # Provide the name of the secret containing the files
            secretName: secret-vol
            items:
            -  key: password
               path: pass-1
      restartPolicy: Never      
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>

1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>


1. HOLA
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create sa sa-security-example
    ```

    </p>
    </details>            