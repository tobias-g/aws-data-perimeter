const checkPolicy = require('./checkPolicy')
const saveComplianceStatus = require('./saveComplianceStatus')

exports.handler = async ({ invokingEvent, resultToken }) => {
  try {
    // Log the AWS config event, useful for debugging.
    console.dir(invokingEvent, { depth: null, colors: false })

    // Get the details of the bucket config.
    const { configurationItem } = JSON.parse(invokingEvent)
    const bucketName = configurationItem.resourceName
    const policy = configurationItem.supplementaryConfiguration.BucketPolicy.policyText

    // Check compliance.
    console.log(`Checking bucket "${bucketName}" policy "${policy}" complies with data perimeter configuration`)
    const { complianceType, annotation } = checkPolicy(`arn:aws:s3:::${bucketName}`, policy)
    console.log(`Bucket "${bucketName}" compliance status is "${complianceType}" with the reason "${annotation}"`)

    // save compliance status to AWS Config.
    await saveComplianceStatus(
      configurationItem,
      complianceType,
      annotation,
      resultToken)
  } catch (err) {
    console.log(err)
    const { configurationItem } = JSON.parse(invokingEvent)
    await saveComplianceStatus(
      configurationItem,
      'INSUFFICIENT_DATA',
      'Error when checking bucket compliance',
      resultToken)
  }
}
