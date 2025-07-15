const { ConfigServiceClient, PutEvaluationsCommand } = require('@aws-sdk/client-config-service')
const configClient = new ConfigServiceClient({ region: 'eu-west-1' })

module.exports = (resource, complianceType, annotation, resultToken) => {
  const putEvaluationsRequest = {
    ResultToken: resultToken,
    Evaluations: [{
      ComplianceResourceType: resource.resourceType,
      ComplianceResourceId: resource.resourceId,
      ComplianceType: complianceType,
      OrderingTimestamp: new Date(resource.configurationItemCaptureTime),
      Annotation: annotation
    }]
  }
  return configClient.send(new PutEvaluationsCommand(putEvaluationsRequest))
}
