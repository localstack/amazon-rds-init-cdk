# Supporting Amazon RDS initialization using CDK

| Key          | Value                                                                                 |
| ------------ | ------------------------------------------------------------------------------------- |
| Environment  | <img src="https://img.shields.io/badge/LocalStack-deploys-4D29B4.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAKgAAACoABZrFArwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAALbSURBVHic7ZpNaxNRFIafczNTGIq0G2M7pXWRlRv3Lusf8AMFEQT3guDWhX9BcC/uFAr1B4igLgSF4EYDtsuQ3M5GYrTaj3Tmui2SpMnM3PlK3m1uzjnPw8xw50MoaNrttl+r1e4CNRv1jTG/+v3+c8dG8TSilHoAPLZVX0RYWlraUbYaJI2IuLZ7KKUWCisgq8wF5D1A3rF+EQyCYPHo6Ghh3BrP8wb1en3f9izDYlVAp9O5EkXRB8dxxl7QBoNBpLW+7fv+a5vzDIvVU0BELhpjJrmaK2NMw+YsIxunUaTZbLrdbveZ1vpmGvWyTOJToNlsuqurq1vAdWPMeSDzwzhJEh0Bp+FTmifzxBZQBXiIKaAq8BBDQJXgYUoBVYOHKQRUER4mFFBVeJhAQJXh4QwBVYeHMQJmAR5GCJgVeBgiYJbg4T8BswYPp+4GW63WwvLy8hZwLcd5TudvBj3+OFBIeA4PD596nvc1iiIrD21qtdr+ysrKR8cY42itCwUP0Gg0+sC27T5qb2/vMunB/0ipTmZxfN//orW+BCwmrGV6vd63BP9P2j9WxGbxbrd7B3g14fLfwFsROUlzBmNM33XdR6Meuxfp5eg54IYxJvXCx8fHL4F3w36blTdDI4/0WREwMnMBeQ+Qd+YC8h4g78wF5D1A3rEqwBiT6q4ubpRSI+ewuhP0PO/NwcHBExHJZZ8PICI/e73ep7z6zzNPwWP1djhuOp3OfRG5kLROFEXv19fXP49bU6TbYQDa7XZDRF6kUUtEtoFb49YUbh/gOM7YbwqnyG4URQ/PWlQ4ASllNwzDzY2NDX3WwioKmBgeqidgKnioloCp4aE6AmLBQzUExIaH8gtIBA/lFrCTFB7KK2AnDMOrSeGhnAJSg4fyCUgVHsolIHV4KI8AK/BQDgHW4KH4AqzCQwEfiIRheKKUAvjuuu7m2tpakPdMmcYYI1rre0EQ1LPo9w82qyNziMdZ3AAAAABJRU5ErkJggg=="> <img src="https://img.shields.io/badge/AWS-deploys-F29100.svg?logo=amazon">                                                                     |
| Services     | RDS, Lambda, SecretsManager, ECR                                                        |
| Integrations | AWS CDK, AWS SDK for JavaScript                                                       |
| Categories   | Databases;                             |
| Level        | Intermediate                                                                          |
| GitHub       | [Repository link](https://github.com/localstack/amazon-rds-init-cdk)                  |


## Introduction

This sample show cases how to support Amazon RDS instances initialization using CDK and CloudFormation Custom Resources. 
For the compute layer, it uses a Lambda function implemented in Node.js which is able to run custom SQL scripts with the purpose of initializing the Amazon RDS instance, but also to execute custom commands supported by the [Node.js client for MySQL2](https://www.npmjs.com/package/mysql2).  

Additionally, there is a lambda that can be used to run queries against the RDS database after successful deployment.

More details about the original sample can be found in the following AWS blog post: https://aws.amazon.com/blogs/infrastructure-and-automation/use-aws-cdk-to-initialize-amazon-rds-instances/ 




## Architecture Diagram

TODO

* [RDS](https://docs.localstack.cloud/user-guide/aws/rds/) as the central part of this demo, will be initialized and pre-filled with data
* [Lambda](https://docs.localstack.cloud/user-guide/aws/lambda/) to initialize the database, and query data
* SecretsManager to store the credentials and configuration of the database


## Pre-Requisites
- LocalStack Pro with the [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli).
- [AWS CLI](https://docs.localstack.cloud/user-guide/integrations/aws-cli/) with the [`awslocal` wrapper](https://docs.localstack.cloud/user-guide/integrations/aws-cli/#localstack-aws-cli-awslocal).
- [CDK](https://docs.localstack.cloud/user-guide/integrations/aws-cdk/) with the [`cdklocal`](https://www.npmjs.com/package/aws-cdk-local) wrapper.
- [Node.js](https://nodejs.org/en/download/)


## Instructions

### Run LocalStack
Start LocalStack Pro with the `LOCALSTACK_API_KEY` pre-configured:

```shell
export LOCALSTACK_API_KEY=<your-api-key>
localstack start
```

The sample uses RDS with a MySQL Engine. Currently, by default LocalStack will use a MariaDB engine instead (please check details in our [docs](https://docs.localstack.cloud/user-guide/aws/rds/#mysql-engine)). You can enable the use of real MySQL engine, which will start a MySQL instance in a separate docker container, by setting the env `RDS_MYSQL_DOCKER=1`, e.g.: 

```shell
export LOCALSTACK_API_KEY=<your-api-key>
RDS_MYSQL_DOCKER=1 localstack start
```


### Installation and Deployment steps
You can build and deploy the sample application on LocalStack by running our `Makefile` commands:
`build`, `bootstrap`, and `deploy`. 

Alternatively, here are instructions to deploy it manually step-by-step.

First, install the dependencies of the project using `npm`.

There is an additional Node.js lambda located in `demos/rds-query-fn-code`, which also uses external dependencies. 
Those need to be installed as well before deploying the sample.

```shell
npm install && cd demos/rds-query-fn-code && npm install && cd ../../
```

Next, we need bootstrap and deploy the sample:  
```
cdklocal bootstrap
cdklocal deploy --require-approval never
```

In the end you will see some `Outputs` similar to:
```shell
RdsInitExample.RdsInitFnResponse = {"status":"OK","results":[{"fieldCount":0,"affectedRows":0,"insertId":0,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":0,"insertId":0,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":0,"insertId":0,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":0,"insertId":0,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":1,"insertId":1,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":1,"insertId":2,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":1,"insertId":3,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":1,"insertId":1,"info":"","serverStatus":10,"warningStatus":0},{"fieldCount":0,"affectedRows":1,"insertId":2,"info":"","serverStatus":2,"warningStatus":0}]}
RdsInitExample.functionName = my-lambda-rds-query-helper
RdsInitExample.secretName = /rdsinitexample/rds/creds/mysql-01
```

* `RdsInitExample.RdsInitFnResponse` relates to the execution of the SQL script (`demos/rds-init-fn-code/script.sql`) and the corresponding result.
* `RdsInitExample.functionName` is the name of the function than can be used to run test-queries against RDS
* `RdsInitExample.secretName`the name of the secret, holding information about the database. The name is required as input for the lambda to run queries.


## Test the Sample

The sample initializes the database with some tables and a few dummy data. 
We added a lambda function `my-lambda-rds-query-helper` for demo purpose, it can be used to run queries against the RDS database.

The lambda expects a query using the parameter `sqlQuery`, and the secret containing the database connection details with the key `secretName`. 

For example, you query the authors of books like this for AWS CLI v1:

```shell
awslocal lambda invoke --function-name my-lambda-rds-query-helper --payload '{"sqlQuery": "select Author from books", "secretName":"/rdsinitexample/rds/creds/mysql-01"}' output
```

If you are using AWS CLI v2, please use the following:
```shell
awslocal lambda invoke --cli-binary-format raw-in-base64-out --function-name my-lambda-rds-query-helper --payload '{"sqlQuery": "select Author from books", "secretName":"/rdsinitexample/rds/creds/mysql-01"}' output
```

To see the actual result, check the `output`:
```shell
cat output
````

You should see the following result:
```shell
{"status":"SUCCESS","results":[{"Author":"Jane Doe"},{"Author":"Jane Doe"},{"Author":"LocalStack"}]}
```


### Use Cases

In the sample we setup the database by creating some tables and adding some dummy data, by running the script `demos/rds-init-fn-code/scripts.sql`.

Generally, the setup can be enhanced and cover some use cases like:

- Initialize databases.
- Initialize/maintain users and their permissions.
- Initialize/maintain stored procedures, views or other database resources.
- Execute other custom logic as part of a resource initialization process.
- Improve segregation of duties/least privilege by providing a flexible hook in the IaC, in order to manage RDS instances initialization.
- Initialize database tables. (see note below)
- Seed database tables with initial datasets. (see note below)

> NOTE: Please be aware that application specific initilization logic (for example: database tables structure and initial seeding of data) is a concern that is commonly managed on the application side. Overall, we advice to keep infrastructure initialization/management separated from application specific initialization. 

## Technical Implementation Details

In order to achieve custom logic execution during the deployment flow of a CDK stack, we make use of CloudFormation Custom Resources. In the context of CDK, we use the `AwsCustomResource` construct to invoke a deployed lambda containing the RDS initialization logic (execute SQL scripts).

> Optionally you can read more about making custom AWS API calls using the AwsCustomResource construct: https://docs.aws.amazon.com/cdk/api/latest/docs/custom-resources-readme.html#custom-resources-for-aws-apis


### Client implementation based on Node.js

To execute SQL scripts on the provisioned Amazon RDS instance we make use of the `mysql` NPM module, it allow us to easily execute custom SQL scripts or any other support client -> server command:
```js
const mysql = require('mysql2')
const connection = mysql.createConnection({
  host,
  user,
  password,
  multipleStatements: true
})
connection.connect()

connection.query("SELECT 'Hello World!';", (err, res) => {
  // ...
})
```
> Full Node.js implementation example for MySQL is available at `./demos/rds-init-fn-code/index.js`

### Docker container images for Lambda functions

To avoid unnecessary overhead dealing with software dependencies, we promote the usage of Docker container images to package the RDS initialization Lambda function code. 

Docker container images are automatically managed by CDK and there is no need to interact with ECR repositories, simply use: 
```js
const fnCode = DockerImageCode.fromImageAsset(`${__dirname}/your-fn-code-directory`, {})
```
> You can see a Lambda function code example inside the `./demos/rds-init-fn-code` directory.  

### Lambda function for querying RDS

An additional lambda function to show case querying of RDS database, uses code from assets. 
This requires to run `npm install` in the directory first, so that the node-modules are available.

```js
// create a new Lambda to run queries against the database for testing purpose after init
const lambdaQuery = new lambda.Function(this, 'MyLambdaRDSQueryHelper', {
  code: new lambda.AssetCode(`${__dirname}/rds-query-fn-code`),
  handler: 'index.handler',
  runtime: lambda.Runtime.NODEJS_16_X,
  memorySize: 1024,
  timeout: cdk.Duration.seconds(300),
  functionName: "my-lambda-rds-query-helper"
})
```

### The CdkResourceInitializer construct

TThe `CDKResourceInitializer` CDK construct generalizes the proposed solution, it encapsulates the integration requirements behind `CloudFormation Custom Resources` and `CDK`, to support the execution of AWS Lambda functions with custom initialization logic. 
The implementation can be found in `lib/resource-initializer.ts`.
