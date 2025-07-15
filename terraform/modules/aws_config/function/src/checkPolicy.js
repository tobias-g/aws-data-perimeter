/**
 * Checks a IAM policy has an explicit deny for access from outside the AWS
 * organization.
 * @param {Object} policy
 */
module.exports = (resourceArn, policy) => {
  if (!policy) {
    return {
      annotation: 'Resource has no policy set',
      complianceType: 'NOT_APPLICABLE'
    }
  }

  const jsonPolicy = typeof policy === 'string' ? JSON.parse(policy) : policy
  const statements = jsonPolicy.Statement

  for (let i = 0; i < statements.length; i++) {
    const statement = statements[i]

    if (statementExternalOrgDeny(statement, resourceArn)) {
      return {
        annotation: 'Resource has explicit deny on actions from outside our org',
        complianceType: 'COMPLIANT'
      }
    }
  }

  return {
    annotation: 'Resource has no explicit deny on actions from outside our org',
    complianceType: 'NON_COMPLIANT'
  }
}

const statementExternalOrgDeny = (statement, resourceArn) => {
  const resource = resourceArn.split(':')[2]

  return statement.Effect === 'Deny' &&
    statement.Principal === '*' &&
    (statement.Action === `${resource}:*` || statement.Action === '*') &&
    statement.Resource.includes(resourceArn) &&
    statement.Resource.includes(`${resourceArn}/*`) &&
    statement.Condition.StringNotEquals['aws:PrincipalOrgID'] === process.env.ORG_ID
}
