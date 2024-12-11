# interop-infra

## Terraform setup

Install [tfenv](https://github.com/tfutils/tfenv)

```bash
cd src/
tfenv install
```

The version output of `terraform --version` should be equal to the one in `.terraform-version`

## Pre-commit setup

```bash
brew install pre-commit

PRE_COMMIT_DIR=~/.git-template
git config --global init.templateDir ${PRE_COMMIT_DIR}
pre-commit init-templatedir -t pre-commit ${PRE_COMMIT_DIR}
```

## Init TF backend resources

⚠️ These steps are necessary only when the AWS account doesn't already contain the TF backend resources. ⚠️

TODO


## External repository
Some resources are created by referencing Terraform modules from the <a href="https://github.com/pagopa/interop-infra-commons/tree/main">interop-infra-commons</a> external repository.

To use a module from an external repository, the current repository must have access to it. 

Once access is established, you can reference a specific module by defining the _source_ field as follows:

```
module "example" {
  source = "git@github.com:[USERNAME]/[REPOSITORY_NAME]//[PATH_TO_MODULE]?ref=[BRANCH_NAME/TAG]"
  ...
}

module "example_2" {
  source = "git@github.com:pagopa/interop-infra-commons//terraform/modules/k8s-deployment-monitoring?ref=v1.3.5"
  ...
}
```
