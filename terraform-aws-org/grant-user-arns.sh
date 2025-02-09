#!/bin/bash

# Define the user ARN and the role ARNs
USER_ARN="arn:aws:iam::753493924839:user/luke.howsam"
ROLE_ARNS=(
  "arn:aws:iam::481665083516:role/Admin"
  "arn:aws:iam::686255954350:role/Admin"
  "arn:aws:iam::982534381495:role/Admin"
)

# Create the policy document
POLICY_DOCUMENT=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "${ROLE_ARNS[0]}",
        "${ROLE_ARNS[1]}",
        "${ROLE_ARNS[2]}"
      ]
    }
  ]
}
EOF
)

# Function to create and attach the policy in each account
create_and_attach_policy() {
  local account_id=$1

  # Check if the policy already exists
  POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='AssumeRolePolicy'].Arn" --output text --region eu-west-2)
  if [ -z "$POLICY_ARN" ]; then
    # Create the policy if it does not exist
    POLICY_ARN=$(aws iam create-policy --policy-name AssumeRolePolicy --policy-document "$POLICY_DOCUMENT" --query 'Policy.Arn' --output text --region eu-west-2)
  fi

  # Attach the policy to the user
  aws iam attach-user-policy --user-name luke.howsam --policy-arn "$POLICY_ARN" --region eu-west-2
}

# Loop through each account and create/attach the policy
for role_arn in "${ROLE_ARNS[@]}"; do
  account_id=$(echo $role_arn | cut -d: -f5)
  create_and_attach_policy "$account_id"
done

echo "AssumeRole permissions granted for user $USER_ARN in all specified accounts."