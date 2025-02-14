const mysql = require('mysql2')
const AWS = require('aws-sdk')
require('dotenv').config();

// the env AWS_ENDPOINT_URL is automatically injected and available
const endpoint = process.env.AWS_ENDPOINT_URL;
const url = new URL(endpoint);
const hostname = url.hostname;

// configure the secretsmanager to connect to the running LocalStack instance
const secrets = new AWS.SecretsManager({ 
  endpoint: endpoint,
  accessKeyId: 'test',
  secretAccessKey: 'test',
  region: 'us-east-1',
})

// the function expects "secretName" and "sqlQuery" as payload
// sample call using aws-cli:
//     $ awslocal lambda invoke --function-name my-lambda-rds-query-helper --payload '{"sqlQuery": "select Author from books", "secretName":"/rdsinitexample/rds/creds/mysql-01"}' output
// the result is in the 'output' file:
//     $ cat output
exports.handler = async (event, context) => {
  try {
    const { password, username, dbname, port } = await getSecretValue(event.secretName)
    const connection = mysql.createConnection({
      host: hostname,
      user: username,
      database: dbname,
      port,
      password,
      multipleStatements: true
    })

    connection.connect()

    const res = await query(connection, event.sqlQuery)

    return {
      status: 'SUCCESS',
      results: res
    }
  } catch (err) {
    return {
      status: 'ERROR',
      err,
      message: err.message
    }
  }
}

function query (connection, sql) {
  return new Promise((resolve, reject) => {
    connection.query(sql, (error, res) => {
      if (error) return reject(error)

      return resolve(res)
    })
  })
}

function getSecretValue (secretId) {
  return new Promise((resolve, reject) => {
    secrets.getSecretValue({ SecretId: secretId }, (err, data) => {
      if (err) return reject(err)

      return resolve(JSON.parse(data.SecretString))
    })
  })
}
