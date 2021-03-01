# **ScyllaDB 3-Node Cluster - EC2**

This is a simple project i worked on during my freetime. The main reason behind the project is to learn about ScyllaDB, and also to improve my knowledge on Ansible and Terraform. 

## **How this works?**

### **Prerequisites**

 - AWS account with access key and token
 - Terraform Installed
 - Ansible Installed

### **Structural Breakdown**

If you have noticed, there are 3 directories in this repository; Ansible, Resources and Terraform. In this section, I will briefly describe what files each of these directories contains by default. When the cluster is being built, you will notice some additonal files in these said directories. But we will discuss them later.

The *Ansible* directory contains 2 files:

 - `ansible.cfg` - This is the ansible configuration file, where, it is explicitly told to refer to the particular Inventory file when the Ansible Playbook is run. A dynamic inventory file will be created by Terraform when you invoke terraform. 
 - `ScyllaDB_Cluster_Playbook.yml` - This is the Ansible Playbook that will install and configure Scylla Nodes on each given host.

The *Resources* directory contains 2 files:

 - `cassandra-rackdc.properties.j2` - This is the templated configuration file to determine which datacenters and racks nodes belong to. [Reference](https://docs.datastax.com/en/dse/5.1/dse-dev/datastax_enterprise/config/configCstarRackDCProps.html)
 - `scylla.yml.j2` - This is the templated scylla.yml configuration file. This contains all the configurations required to function the Scylla Node. [Reference](https://github.com/scylladb/scylla/blob/master/conf/scylla.yaml)
 
The *Terraform* directory contains 5 files:

 - `main.tf` - This file defines the entire AWS infrastructure that is needed to create the 3 node ScyllaDB cluster.
 - `output.tf` - This file defines what type of output that Terraform should print upon a successful resource creation. This will simply print out individual ssh commands for each ansible.cfg - This is the ansible configuration file, where, it is explicitly told to refer to the particular Inventory file when the Ansible Playbook is run. A dynamic inventory file will be created by Terraform when you invoke terraform.
e AWS in this scenario.

 - `terraform.tfvars.example` - This file contains the secrets for your AWS account. This file should be renamed to *terraform.tfvars* (Remove ".example" from the file name). If not, Terraform will not be able to connect with your AWS account.

 - `variables.tf` - This file contains all the global variables that will be used by *main.tf<nolink>*. Note: The only variables that you should consider updating are: *Instance_Type* and *Region*.


 ### **Let's get started, shall we?**

 1. Let's begin with renaming this file: `Terraform/terraform.tfvars.example` to `Terraform/terraform.tfvars`. 

 2. Open `Terraform/terraform.tfvars` and enter your AWS secrect ID and key. Then save it.

```
    Access_Key_ID = "dsadDSDD33fdsfd"
    Secret_Access_Key = "Scxsadwr344fddsfsdfsd3"
```
 3. This step is optional. By default, the selected AWS region for resource creation is "ap-southeast-1" - Singapore. But feel free to change it to your closest region. The terraform variable file is in: `Terraform/variables.tf` 

 ```
    variable "Region" {
    type = string
    default = "ap-southeast-1"
    }
```
4. After you have done the basic configuration, change the directory to `Terraform`. Because now on, you will be using several Terraform commands to create the cluster.

```
   cd Terraform
```
5. Let's run `Terraform init` to initialize the current working directory. It will also install required modules that we will need to run Terraform.

6. Now it is time to run the main Terraform file. There are 2 ways to run the command:

```
   yes 'yes' | terraform apply
```
​  ​​​ ​​​​ ​​​​​         or

```
   terraform apply
```
7. This is it! You made it to the end! If you happen to come across any issues, make sure to raise it. 
