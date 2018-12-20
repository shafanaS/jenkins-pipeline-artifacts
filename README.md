# jenkins-pipeline-artifacts

This repository contains the resources needed for the CICD pipeline.

#### Folder Structure
The following diagram shows the folder structure in this repository:

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
* cfn: This directory holds the cloud formation template for the Jenkins server.
* jenkinsfile: This directory contains the main pipeline scripts for each infrastructure.
* scripts: This directory holds the utility scripts needed for Packer and Puppet.

#### How to start the pipeline
The jenkins.yaml file holds the CFN (template file) for the Jenkins server in region us-east-1.

Steps to start:
1.  Upload the jenkins.yaml file as the template.
2.  Specify the required parameters mentioned below.
    *   AWSAccessKeyId - AWS Access Key ID.
    *   AWSAccessKeySecret - AWS Secret Key.
    *   KeyPairName - This key pair name will be used as the private key when a user logs in to instances through SSH.
    *   CertificateName - A valid SSL certificate used for HTTPS.
    *   WSO2InstanceType - The AWS instance type that you want to create. This must be any of the following valid EC2 instance types:
        -   t2.medium
        -   t2.large
        -   t2.2xlarge
        -   m3.large
        -   m3.xlarge
        -   m3.2xlarge
        -   m4.large
        -   m4.xlarge (recommended)
    *   WUMPassword - Password for WUM.
    *   WUMUsername - Username for WUM.
    *   DBUsername - Database username.
    *   DBPassword - Database password.
    *   JDKVersion - Java version.
    *   GITREPOARTIFACTS - Git URL of the artifact repository. The artifacts in this repository will be deployed from the pipeline.
    *   GITREPOCF - Git URL of the repository that contains the CFN scripts for staging and production (https://github.com/wso2-incubator/cicd-deployment-scripts.git).
    *   GITREPOPUPPET - Git URL of the repository that contains the puppet scripts (https://github.com/wso2-incubator/cicd-configurations.git).
    *   Email - In case of any failures in the pipeline, a message will be sent to this email.

3. Create the stack.
4. Once the EI instance is created, log in to the instance through a web browser using "<public DNS> (IPV4):8080".
5. Go Global Jenkins Credentials, and update your AWS credentials (under aws_creds) and WUM credentials (under wum_creds) respectively.
6. Configure GitHub webhook for the jenkins server. Follow the steps given below.
    a. Sign in to your GitHub account.
    b. Select the related repository you own.
    c. Click "Settings" on the right panel.
    d. Then click "Webhooks" on the left panel.
    e. Click the "Add WebHook" button.
    f. Paste the URL of the Jenkins server in the URL form field.
    g. Select "application/json" as the content type.
    h. Select "Just the push event".
    i. Leave the "Active" check box selected.
    j. Click "Add webhook" to save the webhook.
    When the webhook is created, the jenkins build will be triggered once a push is made to the repository. This will start the pipeline.
5.  Make a push to the GitHub repository.

### Jenkins pipeline flow
Once the pipeline is started, the following steps will be executed:

1. Setup the environment.
    - clone the repositories and make the directory structure.
2. Build the pack.
    - product pack is created as a .zip file.
3. Build the image for EI Instances.
    - this step returns an AMI ID that is used in steps 4 and 5.
4. Deploy to staging.
    - staging stack is created and the test endpoint is returned. Note that this endpoint is not app-specific. To be able to test app-specific endpoints (in the next step), the test cases should already contain the app-specific URI.
5. Run tests on staging.
    - run tests in the staging environment.
6. Deploy to production.
    - production stack is created and the test endpoint for the production environment is returned. Note that this endpoint is not app-specific. To be able to test app-specific endpoints in the next step, the test cases should already contain the app-specific URI.
7. Run tests on production.

### How to configure the pipeline from another region

To configure the CICD pipeline for any region: Copy the AMI specified in the Jenkins.yaml file (under mappings) for the us-east-1 region to the AMI in the Jenkins.yaml file in the required region.
