#### Getting Started with pipeline - Enterprise Integrator

Setting up a basic pipeline for WSO2 Enterprise Integrator on AWS is quick and simple.

You can set up a simple CI/CD pipeline for WSO2 Enterprise Integrator in few steps.

##### Prerequisites:

* Create and upload an SSL certificate to AWS, which is required to initiate the SSL handshake for HTTPS. Please see https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/ssl-server-cert.html for further details.

* Create a key pair for the desired region, which is required to SSH to instances. (Skip this step if you want to use an existing key pair.) See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html for further details.

Once you have got the above prerequisites satisfied, let’s get started with the deployment.

Step 1: Use the jenkins.yaml file in cfn folder to create the stack which has the jenkins.

Step 2: Enter the parameters in the stack details to create the stack. Specify below values for ProductName and DeploymentPattern parameters.

    ProductName : wso2ei
    DeploymentPattern : ei_integrator
You can specify below values for the repository parameters. <i> Artifacts Repository</i> can be one of your own repository following the structure of <i>https://github.com/wso2-incubator/cicd-test-artifacts.git</i> repository.
    
    Artifacts Repository (git) : https://github.com/wso2-incubator/cicd-test-artifacts.git
    
    CloudFormation Scripts (git) : https://github.com/wso2/aws-cicd-deployment-scripts.git
    
    Configuration Repository (git) : https://github.com/wso2/aws-ei-cicd-configurations.git
 
* If you do not have a wso2 subscription you may leave the WSO2 Subscription Credentials empty.

* If you do not want to configure a githook to the pipeline you may leave the GitHub Credentials empty.
    

Step 3: Once the stack is created get the Jenkins Management console URL from Outputs Tab of AWS Console.

Step 4: Log in to the JenkinsManagementConsoleURL with below username and the password you provided.
    
    Username: admin

Step 5: Once you have logged in, click “Run” on the pop-up window to start the pipeline. Else you can trigger the build by pushing the directory to which the git hook was configured.

Step 5: Approve and select “OK” on the “Approve Staging” and "Approve Production" pop-ups to deploy the product into staging and production environments. 

Once the deployment to each environment is completed, you can get the Management Console URL for each environment from the Outputs tab of each stack.