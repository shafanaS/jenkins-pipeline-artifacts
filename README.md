# jenkins-pipeline-artifacts

This repository contains resources needed for CICD pipeline.


#### Structure
```
.
├── cfn
│   └── jenkins.yaml
├── jenkinsfile
│   ├── aws
│   │   └── Jenkinsfile
│   └── k8s
├── README.md
└── scripts
    ├── packer
    │   ├── packer.json
    │   └── packer-resources
    │       ├── conf
    │       │   ├── limits.conf
    │       │   ├── sources.list
    │       │   └── sysctl.conf
    │       ├── config.sh
    │       └── util
    │           ├── ei
    │           │   ├── ei.sql
    │           │   ├── mb.sql
    │           │   ├── provision_db_ei.sh
    │           │   └── provision_db_mb.sh
    │           └── ei-init.sh
    └── puppet
        ├── apply-config.sh
        └── construct-puppet-module.sh
```
* cfn: This directory holds the CFN for the Jenkins server
* jenkinsfile: This directory contains Main pipeline script for each infrastructure
* scripts: This directory holds utility scripts needed for Packer and Puppet

#### How to Start
The jenkins.yaml file holds the CFN (template file) for the Jenkins Server in region us-east-1.
Steps to Run:
1.  Upload the jenkins.yaml file as template.
2.  Specify the required parameters mentioned below.
    *   AWSAccessKeyId - AWS Access Key ID
    *   AWSAccessKeySecret - AWS Secret Key
    *   KeyPairName - This key pair name will be used to as the private key used to log in to instances through SSH.
    *   CertificateName - A valid SSL certificate used for HTTPS
    *   WSO2InstanceType - The aws inatnce type that you want to create. This must be a valid EC2 instance type. This can be any of following type.
        -   t2.medium
        -   t2.large
        -   t2.2xlarge
        -   m3.large
        -   m3.xlarge
        -   m3.2xlarge
        -   m4.large
        -   m4.xlarge (recommended)
    *   WUMPassword - Password for WUM
    *   WUMUsername - Username for WUM
    *   DBUsername - Database Username
    *   DBPassword - Database Password
    *   JDKVersion - Java Version
    *   GITREPOARTIFACTS - Git URL of the artifacts repository. The artifacts in this repository will be deployed from the Pipeline.
    *   GITREPOCF - Git URL of the repository that contains the CFN scripts for staging and production (https://github.com/wso2-incubator/cicd-deployment-scripts.git)
    *   GITREPOPUPPET - Git URL of the repository that contains the puppet scripts (https://github.com/wso2-incubator/cicd-configurations.git)
    *   Email - In case of any failures in the pipeline an email will be sent to this email.

3.  Create the stack.
4.  Configure github webhook for the jenkins server
5.  Make a push to the git hub repository

The following parameters are required to be given when uploading the file.

#### How to create a Github Webhook
1.  Sign in to your GitHub account.
2.  Select the related repository you own.
3.  Click on "Settings" on the right panel.
4.  Then click on "Webhooks" on the left panel.
5.  Click on the "Add WebHook" Button.
4.  Paste the URL of the Jenkins server in the URL form field.
5.  Select "application/json" as the content type.
6.  Select "Just the push event".
7.  Leave the "Active" checkbox checked.
8.  Click on "Add webhook" to save the webhook.
Once the webhook is created, when a push is made to the repository, the jenkins build will be triggered, which will start the Pipeline.

### Jenkins Pipeline Flow

1. Setup the Environment
    - clone the repositories and make the directory structure
2. Build the pack
    - product pack is created as a .zip file
3. Build Image for EI Instances
    - this steps returns an AMI ID that are used in the steps 4 and 5.
4. Deploy to Staging
    - staging stack is created and the test endpoint is returned.
5. Run tests staging
    - run tests on staging environment.
6. Deploy to Production
    - production stack is created and the test point for product endpoint is returned.
7. Run tests on production

The returned endpoint returned in step 4 and 6 are not app specific. In order to test for app specific end points the tests cases should specify the app specific URI.

### How to configure the pipeline from another region

To configure the CICD pipeline for any region, copy the AMI specified in Jenkins.yaml file under mappings for the region us-east-1 to that required region. Include the copied AMI for that region in the jenkins.yaml file, under mappings.


