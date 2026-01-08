# terraform_minecraftserver
Minecraft server tested in dev environment before being deployed into production. 


# directory structure
terraform_minecraftserver/
  └── main.tf
  └── vpc.tf
  └── alb.tf
  └── ecs.tf
  └── efs.tf
  └── variables.tf
  └── dev.auto.tfvars
  └── prod.auto.tfvars
..dependencies?

# features (WIP - vomited)
- separate dev and prod (isolated)
- automated idle check to run every 10 mins to check if players are on the server, if no players are found it will trigger a shutdown and backup of the world files
- shutdown and backup logic:
    - if no players → stop ECS service
    - launch task to back up data to S3
    - then send notification to Discord via webhook
- dns setup
    - CNAME minecraft.bearynatural.dev

# testing the terraform code
terraform plan -var-file="dev.auto.tfvars"
terraform plan -var-file="prod.auto.tfvars"


# others to implement
auto start and shutdown needs api
backup of the map is not there
- health checks? are they working

- double check seed and admin rights
Can't keep up! Is the server overloaded? Running 2038ms or 40 ticks behind - do we need more resources?

this task (8d77c21f4db242e2b37bc80457c8e436) logs show great and even doing checks on how long it is until a player connects;
last task deployed after elb updates no longer running right exit code 0

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