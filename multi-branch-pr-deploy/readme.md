Prerequisites
-----
```
brew install aws-iam-authenticator
brew install awscli
# kubectl 
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/7ee32113351bbd913b90f9578bcd52dfe85d675e/Formula/kubernetes-cli.rb
# helm3 
brew install brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/0c516376e23068d65eba2ab3a95d15981a26d75c/Formula/helm.rb
```


Login using your awscli
-----

Configure role
```
aws configure
aws sts assume-role --role-arn <arn> --role-session-name multi-branch-pr-deploy-$(date +%s)
export AWS_ACCESS_KEY_ID=<.Credentials.AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<.Credentials.SecretAccessKey>
export AWS_SESSION_TOKEN=<.Credentials.SessionToken>
```


```
# check credentials and whoami
aws sts get-caller-identity
```

