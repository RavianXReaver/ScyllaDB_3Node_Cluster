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
 - `output.tf` - This file defines what type of output that Terraform should print upon a successful resource creation. This will simply print out individual ssh commands for each node in the cluster. 

 - `provider.tf` - This file contains the configuration details of the selected cloud provider, which happens to be AWS in this scenario.

 - `terraform.tfvars.example` - This file contains the secrets for your AWS account. This file should be renamed to *terraform.tfvars* (Remove ".example" from the file name). If not, Terraform will not be able to connect with your AWS account.

 - `variables.tf` - This file contains all the global variables that will be used by *main.tf<nolink>*. Note: The only variables that you should consider updating are: *Instance_Type* and *Region*.