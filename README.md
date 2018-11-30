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

