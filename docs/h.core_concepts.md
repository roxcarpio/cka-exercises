# Core Concepts (19%)

## Curriculum
* Understand the Kubernetes API primitives. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/reference/using-api/api-concepts/)
  * Understanding Kubernetes Objects. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) [![es](../icons/spain.png)](https://kubernetes.io/es/docs/concepts/overview/working-with-objects/kubernetes-objects/) 
  * [API Overview v1.15](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.15/)
* Understand the Kubernetes cluster architecture. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/overview/components/)
   * Nodes. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/architecture/nodes/) [![es](../icons/spain.png)](https://kubernetes.io/es/docs/concepts/architecture/nodes/) 
   * Master-Node Communication. [![en](../icons/united-kingdom.png)](https://kubernetes.io/docs/concepts/architecture/master-node-communication/) [![es](../icons/spain.png)](https://kubernetes.io/es/docs/concepts/architecture/master-node-communication/) 
* Understand Services and other network primitives.

## Extra Links

### Exercise

1. List all supported resource types along with their shortnames.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl api-resources
    ```

    </p>
    </details>

1. List the component status of the kubernetes cluster.
    <details><summary>show</summary>
    <p>

    ```bash
    kubectl get componentstatuses
    ```

    </p>
    </details>