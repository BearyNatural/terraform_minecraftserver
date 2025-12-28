# terraform_minecraftserver
Minecraft server tested in dev environment before being deployed into production. 


# directory structure
terraform_minecraftserver/
  └── main.tf
  └── vpc.tf
  └── ecs.tf
  └── efs.tf
  └── alb.tf
  └── variables.tf
  └── dev.tf
  └── prod.tf

# features (WIP - vomited)
- separate dev and prod (isolated)
- automated idle check to run every 10 mins to check if players are on the server, if no players are found it will trigger a shutdown and backup of the world files
- shutdown and backup logic:
    - if no players → stop ECS service
    - launch task to back up data to S3
    - then send notification to Discord via webhook
- dns setup
    - CNAME minecraft.bearynatural.dev




# OIDC
https://github.com/aws-actions/configure-aws-credentials

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_ORG>/<GITHUB_REPOSITORY>:ref:refs/heads/<GITHUB_BRANCH>"
        }
      }
    }
  ]
}