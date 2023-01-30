# Local Stack

Local Stack streamlines the deployment of a multi-node Kubernetes cluster for local dev and testing, and utilizes OLM and ArgoCD to offer a fast, easy, and repeatable process for deploying operators and apps.

## Table of Contents

1. [File Structure](#file-structure)
2. [Getting Started](#getting-started)
3. [Prerequisites](#prerequisites)
4. [Installing](#installing)
5. [How-to](#how-to)
   - Fork the local-stack repository
   - Connect to the ArgoCD console
   - Modify the version of the operators in the deployment
   - Create additional applications/deployments
6. [Cleanup](#cleanup)

## File Structure

```css
.
├── argocd
│   ├── applications
│   │   └── application.yaml
│   └── deployments
│       └── deployment
│           └── values.yaml
├── olm
│   ├── crds.yaml
│   └── olm.yaml
├── terraform
│   ├── main.tf
│   └── versions.tf
└── README.md
```

1. argocd: This folder contains the configuration files for the ArgoCD deployment.
   - applications: This folder contains the application.yaml file that defines the application deployment in ArgoCD.
   - deployments: This folder contains the deployment folder which in turn contains the values.yaml file that sets the values for the deployment.

2. olm: This folder contains the configuration files for the Operator Lifecycle Manager (OLM).
   - crds.yaml: This file contains the Custom Resource Definitions for the OLM.
   - olm.yaml: This file contains the configuration for the OLM deployment.

3. terraform: This folder contains the Terraform configuration files for the deployment.
   - main.tf: This is the main Terraform configuration file that includes the provider and module configurations.
   - versions.tf: This file sets the version constraints for Terraform modules.

## Getting Started

- Ensure that you have all the prerequisites installed on your system
- Clone the repository and navigate to the `terraform/` folder
- Run Terraform commands (e.g. `terraform init`, `terraform plan`, and `terraform apply`) to deploy the infrastructure
- Verify the deployment by accessing the Argo CD and OLM applications
- Use the `argocd/applications/application.yaml` and `argocd/deployments/deployment/values.yaml` files to configure the Argo CD application deployment
- Clean up the infrastructure using Terraform commands when necessary.

### Prerequisites

- [Docker](https://docs.docker.com/desktop/install/mac-install/) installed on your local machine
- [Terraform](https://www.terraform.io/) installed on your local machine
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed on your local machine

### Installing

1. Clone the repository

```sh
git clone https://github.com/martijngonlag/local-stack.git
```

2. Change into the root of the project

```sh
cd local-stack
```

3. Change into the `terraform/` folder and run `terraform init`, `plan`, and `apply`

If no changes were made to the repository, then the default setup will deploy a total of 25 resources. They are deployed in the following order:

1. Multi-node Kubernetes cluster
2. OLM
3. ArgoCD
4. StreamNative Operators
5. Pulsar

### How-to

#### Fork the local-stack repository

In order to utilize ArgoCD (e.g. auto-deploy changes commited to a repository), you need to fork local-stack.

1. Navigate to [martijngonlag/local-stack](https://github.com/martijngonlag/local-stack)
2. In the top-right corner of the page, click **Fork**
3. Select an owner for the forked repository
4. Optional: Change the name of the fork to distinguish it
5. Optional: Add a description of the fork
6. Choose whether to copy only the default or all branches to your fork
7. Click **Create fork**
8. Clone the forked repository `git clone https://github.com/YOUR-USERNAME/YOUR-FORKED-REPO-NAME`

Once you've cloned the forked repository, make sure to update the `repoURL` field to the forked repository URL, which can be found in the following files:

- `argocd/application.yaml`
- `argocd/applications/pulsar.yaml` & `argocd/applications/sn-platform.yaml`

#### Connect to the ArgoCD console

In order to connect to ArgoCD, follow these steps:

1. Run the following command to forward the service port:

```sh
kubectl port-forward service/argocd-server 8443:443 -n argocd
```

2. Retrieve the initial admin password using the following command:

```sh
kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -D
```

3. Open a web browser and navigate to <https://localhost:8443>
4. Log in using the default username admin and the password obtained in step 2.

You should now be able to access the ArgoCD web interface.

#### Modify the version of the operators in the deployment

To modify the version of the operators in the deployment, follow these steps, and then re-create the environment. If you have forked this repository, simply commit the changes to your forked repository and ArgoCD should automatically pick them up. 

1. Open the file `deployments/sn-platform/pulsar-operator.yaml`
2. Modify the subscription to reflect the desired operator version (change from `stable`)

#### Modify the version of Pulsar in the deployment

To modify the version of Pulsar, follow these steps, and then re-create the environment. If you have forked this repository, simply commit the changes to your forked repository and ArgoCD should automatically pick them up. 

1. Open the respective YAML file in the `deployments/pulsar/` directory for the component you want to modify (bookkeeper, pulsar, pulsar-proxy, or zookeeper).
2. Modify the desired version of Pulsar in the respective YAML file.

#### Create additional applications/deployments

By default, Local Stack deploys the StreamNative Operators and Apache Pulsar. However, the project can easily be adapted to deploy other services. Note that these steps assume you've forked the Local Stack repository. 

1. Create a copy of `argocd/applications/pulsar.yaml` and name it after your application (e.g. `nginx.yaml`), then open it in your favorite text editor and modify the following fields:
   - Under `metadata` edit the `name` field to your application
   - Under `source` edit the `path` field to your application
   - Under `source` edit the `repoURL` field to your GitHub
2. Create a new folder in `argocd/deployments/` named after your application (e.g. `argocd/deployments/nginx/`), and place your deployment `yaml` inside this folder (e.g. `argocd/deployments/nginx/nginx.yaml`). [Go here](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/) for an example of an Nginx deployment.
3. Run `git add <files>` and `git commit -m "Added nginx as an applicaton to ArgoCD"`.

So long as ArgoCD is already up and running, it should automatically pick up any changes to the repository and deploy shortly after. Otherwise, ArgoCD will automatically  

#### Cleanup

To clean up everything, you can run `terraform destroy` in the `terraform/` folder. The `terraform destroy` command is used to destroy the resources created by Terraform. It will prompt you to confirm the resources that will be destroyed, and after confirming, it will remove all resources created in the current working directory. Note that this action is irreversible and should be used with caution. Before destroying, ensure that you have saved any important information related to the resources being destroyed, and that you understand the consequences of this action.
