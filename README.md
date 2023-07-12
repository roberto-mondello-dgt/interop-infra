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
