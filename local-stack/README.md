# Local Stack

What does this project do? This project is for deploying a kubernetes cluster that can run SN-Platform from StreamNative and Pulsar. It uses Terraform to provision the cluster on your local machine using Minikube.

## Table of Contents

1. [File Structure](#file-structure)
2. [Getting Started](#getting-started)
3. [Prerequisites](#prerequisites)
4. [Installing](#installing)
6. [Deployment](#deployment)
7. [Minikube](#minikube)
8. [Kubernetes](#kubernetes)
9. [Cleanup](#cleanup)
10. [Versioning](#versioning)

## File Structure

The project is structured into several modules. Each module has its own `main.tf`, `variables.tf`, and `outputs.tf`.

Please note that in order to run the terraform commands, you should cd into each module folder (e.g. 00_Kubernetes) before running the commands.

```css
.
├── 00_Kubernetes
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
├── 01_StreamNative
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
├── 02_Pulsar
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
├── terraform.tfvars
└── README.md
```

- `main.tf`: The main Terraform configuration file. It includes the provider configuration and the resources that will be created.

- `variables.tf`: Defines the variables that will be used in the `main.tf` file.

- `terraform.tfvars`: Contains the values for the variables defined in `variables.tf`. This file is ignored by git and should not be checked in.

Please note that you will have to fill out the `terraform.tfvars` file with your desired values. Also, you might need to add other variables in `variables.tf` and `main.tf` as per your requirement.

## Getting Started

These instructions get you a working version of Minikube, Kubernetes, SN-Platform and Apache Pulsar up and running on your local machine for development and testing purposes.

### Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/) installed on your local machine
- [Terraform](https://www.terraform.io/) installed on your local machine
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed on your local machine
- Fill in the necessary variables in `terraform.tfvars`

### Installing

1. Clone the repository

```sh
git clone https://github.com/martijngonlag/local-stack.git
```

2. Change into the root of the project

```sh
cd local-stack
```

3. Change into each module folder and run `terraform init`, `plan`, and `apply`

4. Repeat step 3 for each module

### Deployment

#### Minikube

Steps on how to get started with minikube:

1. Install Minikube on your local machine. You can find the installation instructions for your operating system [here](https://minikube.sigs.k8s.io/docs/start/).
2. Start Minikube by running the command minikube start.
3. Verify that Minikube is running by running the command `minikube status`.
4. Connect to the Minikube cluster by running the command `minikube kubectl -- get nodes`.

#### Kubernetes

To deploy the Kubernetes to Minikube cluster using Terraform:

1. Fill out the variables in the `terraform.tfvars` file with your desired values.
2. Change directory into `00_Kubernetes` by running the command `cd 00_Kubernetes`
3. Initialize Terraform by running the command `terraform init`.
4. Create a Terraform plan by running the command `terraform plan --var-file=../terraform.tfvars`.
5. Apply the Terraform plan by running the command `terraform apply --var-file=../terraform.tfvars`.
6. Verify that the kubernetes cluster has been created by running the command `kubectl get nodes`.

#### Cleanup

Run `terraform destroy --var-file=../terraform.tfvars` in each module directory to delete the resources created by Terraform.

### Versioning

This project uses [SemVer](https://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/martijngonlag/local-stack/tags).
