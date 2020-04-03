# Application Lifecycle Management (8%)

## Curriculum
* [Understand Deployments and how to perform rolling updates and rollbacks.](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
* Know various ways to configure applications.
    * [ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
    * [Application's resources.](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/)
    * [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
    * [Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
    * [Environment variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
* [Know how to scale applications.](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#scaling-your-application)
* [Understand the primitives necessary to create a self-healing application.](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
    * [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

## Extra Links

## Exercices

1. Create a deployment with 3 replicas called nginx-test using the nginx 1.7.1 docker image.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=deployment/v1beta1 nginx-test --image=nginx:1.7.1 --replicas=3
    ```

    </p>
    </details>


1. Check if the nginx-test deployment has been created.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get deployments
    ```

    </p>
    </details>

1. See the nginx-test deployment rollout status.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl rollout status deployment/nginx-test
    ```

    </p>
    </details>

1. See the ReplicaSet created by the nginx-test deployment.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get rs
    ```

    </p>
    </details>

1. See the labels that were automatically generated for each pod.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get pods --show-labels
    ```

    </p>
    </details>

1. Upgrade the nginx-test deployment to use the nginx:1.8 image.
    > _Tipp:_ Append the --record flag to save the kubectl command that is making changes to the resource.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl --record deploy/nginx-test set image nginx-test=nginx:1.8
    ```
    or    
    ```bash
    kubectl edit deploy/nginx-test
    ```    

    </p>
    </details>

1. Get the details of the nginx-test deployment in order to check the new docker image.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl describe deployments nginx-test
    ```

    </p>
    </details>

1. List all deployment revisions. See the details of the first revision.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl rollout history deploy/nginx-test
    kubectl rollout history deploy/nginx-test --revision=1
    ```

    </p>
    </details>    

1. Upgrade the nginx pod to use nginx:1.90 image. If an error is found, rollback to the previous revision.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl set image deploy/nginx-test nginx-test=nginx:1.90 --record=true
    kubectl rollout status deploy/nginx-test #The rollout gets stuck.
    kubectl rollout history deploy/nginx-test
    kubectl rollout undo deploy/nginx-test
    ```

    </p>
    </details>

1. Change to another revision, for example to 1.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl rollout undo deploy/nginx-test --to-revision=1
    ```
    </p>
    </details>       

1. Scale the nginx-test deployment to 8.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl scale deploy/nginx-test --replicas=8
    ```

    </p>
    </details>  

1. Auto scale the nginx-test deployment, with the number of pods between 1 and 5, target CPU utilization at 30%:
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl autoscale deploy/nginx-test --min=1 --max=5 --cpu-percent=30
    ```

    </p>
    </details> 


1. Pause the nginx-test deployment. Change the docker image to 1.9.1. Check the rollout status to see that the docker image was not changed. Resume the nginx deployment.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl rollout pause deploy/nginx-test
    kubectl set image deploy/nginx-test nginx-test=nginx:1.9.1
    kubectl rollout status deploy/nginx-test
    kubectl rollout resume deploy/nginx-test
    ```

    </p>
    </details> 

1. Set to 2 the `.spec.revisionHistoryLimit` parameter in order to retaing only 2 rs.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl patch deploy nginx-test -p '{"spec":{"revisionHistoryLimit":2}}'
    ```

    </p>
    </details> 

1. Remove the nginx-test deployment.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl remove deploy nginx-test
    ```

    </p>
    </details> 

1. Create a configmap called config-files from the configmap-files directory with the following files. Check the configmap content.

    Create the files with

    ```bash
    mkdir -p configmap-files
    echo -e "License File" > configmap-files/LICENSE
    echo -e "enemies=aliens\nlives=3\nenemies.color=green" > configmap-files/game.env
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create configmap config-files --from-file=configmap-files/
    kubectl describe configmaps config-files
    ```

    </p>
    </details>

1. Mount the previous configmap in a nginx pod under `/mnt/space-game`. Check the files inside the pod.

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=run-pod/v1 nginx --image=nginx -o yaml --dry-run > pod.yaml
    ```

    ```YAML
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: nginx
      name: nginx
    spec:
      containers:
      - image: nginx
        imagePullPolicy: IfNotPresent
        name: nginx
        resources: {}
        volumeMounts: 
        - name: game-volume # the name that you specified in pod.spec.volumes.name
          mountPath: /mnt/space-game # the path inside your container
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      volumes: # add a volumes list
      - name: game-volume # just a name, you'll reference this in the pod
        configMap:
          name: config-files # name of your configmap
    ```
    ```bash
    kubectl create -f pod.yaml
    kubectl exec nginx -- sh -c 'ls /mnt/space-game'
    ```

    </p>
    </details>    

1. Modify the previous configmap (e.g change the LICENSE file). Check that the file has been updated automatically in the nginx pod. Remove the configmap and the pod

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl exec nginx -- sh -c 'cat /mnt/space-game/LICENSE' # Check initial value
    kubectl edit configmaps config-files
    # Kubernetes needs some time for updating the file
    kubectl exec nginx -- sh -c 'cat /mnt/space-game/LICENSE' # Check updated value

    kubectl delete pod nginx
    kubectl delete cm config-files
    ```

    </p>
    </details>

1. Create and display a configmap called configmap-two-files from the following two files.

    Create the files with:

    ```bash
    echo -e "foo1=Hello\nfoo2=World" > welcome.txt
    echo -e "foo3=Bye\nfoo4=World" > farewell.txt
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create cm configmap-two-files --from-file=welcome.txt  --from-file=farewell.txt
    kubectl get cm configmap-two-files -o yaml
    ```

    </p>
    </details>

1. Create a ConfigMap from an env-file.

    Create the file with the command:

    ```bash
    echo -e "# Path User\nPATH_USER=/home/john\n\n# Path Projects\nPATH_GAME=/tmp/game\nPATH_UI=/tmp/ui" > config-game.env
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create cm config-game --from-env-file=config-game.env
    kubectl get cm config-game -o yaml
    ```

    </p>
    </details>

1. When passing `--from-env-file` multiple times to create a ConfigMap from multiple data sources, only the last env-file is used, test it.

    Create the files with the command:

    ```bash
    echo -e "USER=king" > config-king.env
    echo -e "USER=queen" > config-queen.env
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create cm config-test --from-env-file=config-king.env --from-env-file=config-queen.env

    kubectl get cm config-test -o yaml
    apiVersion: v1
    data:
      USER: queen
    kind: ConfigMap
    metadata:
      creationTimestamp: null
      name: config-test
      selfLink: /api/v1/namespaces/default/configmaps/config-test
    ```

    </p>
    </details>

1. Create a configmap from a file and set up the key to password-special.

    Create the file with the command:
    ```bash
    echo -e "test123" > password
    ```    
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create configmap configmap-password --from-file=password-special=password

    kubectl get cm configmap-password -o yaml
    apiVersion: v1
    data:
      password-special: |
        test123
    kind: ConfigMap
    metadata:
      name: configmap-password
      namespace: default
    ```

    </p>
    </details> 

1. Create a configmap from literal values:
    * special.how=very
    * special.type=charm

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create configmap config-literal --from-literal=special.how=very --from-literal=special.type=charm

    kubectl get configmaps config-literal -o yaml
    apiVersion: v1
    data:
      special.how: very
      special.type: charm
    kind: ConfigMap
    metadata:
      name: config-literal
      namespace: default
    ```

    </p>
    </details> 

1. Mount the previous configmap as enviroment varibles.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2
    ```

    </p>
    </details> 

1. Create a configMap 'bash-script' using the script.sh file. Load this file with permission 777 (octal) inside an nginx pod on path '/etc/example'. Create the pod and run the script.
Note that the JSON spec doesn’t support octal notation, therefore, translate the octal number to decimal.
    ```bash
    echo "echo 'Executing a file inside of a pod :)'" > script.sh

    # Octal to Decimal
    echo "ibase=8; 777" | bc
    ```

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create configmap bash-script --from-file=script.sh
    kubectl run --generator=run-pod/v1 nginx --image=nginx -o yaml --dry-run -o yaml > pod.yaml
    vi pod.yaml
    ```

    ```YAML
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: nginx
      name: nginx
    spec:
      volumes: # add a volumes list
      - name: myvolume # just a name, you'll reference this in the pods
        configMap:
          name: bash-script # name of your configmap
      containers:
      - image: nginx
        name: nginx
        resources: {}
        volumeMounts: # your volume mounts are listed here
        - name: myvolume # the name that you specified in pod.spec.volumes.name
          mountPath: /etc/example # the path inside your container
          defaultMode: 511 # change permission
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}
    ```

    ```bash
    kubectl create -f pod.yaml
    kubectl exec nginx -- sh -c '/etc/example/script.sh'
    ```

    </p>
    </details>


1. Create the YAML for an nginx pod that runs a container with UID 1000. No need to create the pod.

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl run --generator=run-pod/v1 nginx --image=nginx -o yaml --dry-run -o yaml > pod.yaml
    vi pod.yaml
    ```

    ```YAML
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: nginx
      name: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        securityContext: # insert this line
          runAsUser: 1000 # UID for the user
        resources: {}
      dnsPolicy: ClusterFirst
      restartPolicy: Always
    status: {}

    ```

    </p>
    </details>


1. Create a secret called my-secret-1 manually using YAML files. This secret saves two strings: username and password. Get the value of my-secret-1.


    <details><summary>show</summary>
    <p>

    ```bash
    # For example:
    echo -n 'pepe' | base64
    echo -n 'pepito123' | base64

    kubectl create secret generic my-secret-1  --from-literal=username=xx --from-literal=password=xxx --dry-run -o yaml > secret.yaml
    vim secret.yaml
    ```

    ```YAML
    apiVersion: v1
    data:
      password: eHh4 # Replace this value with cGVwZQ==
      username: eHg= # Replace this value with cGVwaXRvMTIz
    kind: Secret
    metadata:
      creationTimestamp: null
      name: my-secret-1
    ```

    ```bash
    kubectl create -f secret.yaml
    kubectl get secrets my-secret-1 -o yaml

    echo 'cGVwZQ==' | base64 -d # shows 'pepe'
    echo 'cGVwaXRvMTIz' | base64 -d # shows 'pepito123'
    ```

    </p>
    </details>

1. Create a secret called my-secret-2 with unencoded strings using the stringData map.
    > The stringData field is provided for convenience, and allows you to provide secret data as unencoded strings.
    
    String data example: 
        * app_url=http://wwww.my-app.com
        * username=lola
        * password=lolita123

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create secret generic my-secret-2 --from-literal=app_url=x --from-literal=username=x --from-literal=password=x --dry-run -o yaml > secret.yaml
    vim secret.yaml
    ```

    Change the secret.yaml file from:

    ```YAML
    apiVersion: v1
    data:
      app_url: eA==
      password: eA==
      username: eA==
    kind: Secret
    metadata:
      creationTimestamp: null
      name: my-secret-2
    ```

    to:

    ```YAML
    apiVersion: v1
    stringData: # change the map from data to stringData 
      app_url: http://wwww.my-app.com # Add this line
      password: lola # Add this line
      username: lolita123 # Add this line
    kind: Secret
    metadata:
      creationTimestamp: null
      name: my-secret-2
    ```

    ```bash
    kubectl create -f secret.yaml
    kubectl get secrets my-secret-2 -o yaml

    echo 'aHR0cDovL3d3d3cubXktYXBwLmNvbQ==' | base64 -d # shows 'http://wwww.my-app.com'
    echo 'bG9sYQ==' | base64 -d # shows 'lola'
    echo 'bG9saXRhMTIz' | base64 -d # shows 'lolita123'
    ```

    </p>
    </details>


  1. If a field is specified in both data and stringData maps, the value from stringData is used. Test it in a new secret.

      String data examples:
      * data map --> alien
      * stringData map --> cowboy 

      <details><summary>show</summary>
      <p>

      ```bash
      echo -n 'alien' | base64 # Enconde alien --> YWxpZW4=

      # Create a secret file
      vim secret.yaml
      ```


      ```YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: my-secret-3
      type: Opaque
      data:
        username: YWxpZW4=
      stringData:
        username: cowboy
      ```


      ```bash
      kubectl create -f secret.yaml
      kubectl get secrets my-secret-3 -o yaml

      echo 'Y293Ym95' | base64 -d # shows 'cowboy'
      ```

      </p>
      </details>

1. Create a service account. Add imagePullsecrets to the already created service account. Create a nginx pod that uses the previous service. Describe the pod in order to see the imagePullPolicy.

    <details><summary>show</summary>
    <p>

    ```bash
    kubectl create serviceaccount docker-registry-sa

    kubectl create secret docker-registry docker-registry-sa --docker-server=myregistry.com --docker-username=user --docker-password=pwd --docker-email=user@mydomain.com

    kubectl patch serviceaccount docker-registry-sa -p '{"imagePullSecrets": [{"name": "docker-registry-sa"}]}'

    ```bash
    kubectl get pods -o yaml --export nginx | grep "serviceAccount:"
    or 
    kubectl get sa docker-registry-sa -o=jsonpath='{.imagePullSecrets[0].name}{"\n"}'
    ```

    </p>
    </details>