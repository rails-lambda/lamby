
# Lamby [![Build Status](https://travis-ci.org/customink/lamby.svg?branch=master)](https://travis-ci.org/customink/lamby)

<img src="https://user-images.githubusercontent.com/2381/54278425-af365680-4568-11e9-972a-6b73e0a44bb5.jpg" alt="Lamby: Simple Rails & AWS Lambda Integration using Rack." align="right" /><h3>Simple Rails & AWS Lambda Integration using Rack</h3>

The goal of this project is to provide minimal code to convert API Gateway `event` and `context` objects into Rack events for your Rails application in a Lambda handler. Most everything else is [documentation](https://github.com/customink/lamby/issues?q=is%3Aissue+is%3Aopen+label%3Adocs+sort%3Acreated-asc).

```ruby
def handler(event:, context:)
  Lamby.handler $app, event, context
end
```


## Getting Started

A simple Hello Rails application example using Lamby.

#### Installing AWS CLI & SAM

This is fairly easy on Macs using Homebrew. For other platforms or first time installers, please follow the [full guides](https://github.com/customink/lamby/issues/18) and configure your AWS CLI before proceeding.

```shell
$ brew install awscli
$ brew tap aws/tap
$ brew install aws-sam-cli
```

#### New Rails Application

Lamby works with existing Rails projects. In theory, any version. In our getting started example, let's create a new application. Here we skip any frameworks not needed, notable ActiveRecord.

```shell
$ rbenv local 2.5.5
$ gem install rails -v 6.0.0.rc1
$ rails new my_awesome_lambda \
  --skip-action-mailer --skip-action-mailbox --skip-action-text \
  --skip-active-record --skip-active-storage --skip-puma \
  --skip-action-cable --skip-spring --skip-listen --skip-turbolinks \
  --skip-system-test --skip-bootsnap --skip-webpack-install
$ cd my_awesome_lambda
```

Add a root to the `routes.rb` file which maps to an `index` action in the application controller and return a simple Hello Rails H1 tag.

```ruby
Rails.application.routes.draw do
  root to: 'application#index'
end

class ApplicationController < ActionController::Base
  def index
    render html: '<h1>Hello Rails</h1>'.html_safe
  end
end
```

#### Add The Gem

Add the Lamby gem to your Rails project's `Gemfile`. Recommend only requiring Lamby in your `app.rb` so your local development or test environment logs still work.

```ruby
gem 'lamby', require: false
gem 'aws-sdk-ssm'
```

#### Install Needed Files

Lamby provides a simple Rake task to install the files needed for AWS Lambda to run your application.

```shell
$ ./bin/rake -r lamby lamby:install:api_gateway
```

This will install the following files.

* `app.rb` - Entry point for the Lambda handler.
* `template.yaml` - Your AWS Serverless Application Model ([SAM](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md)) template.
* `bin/build` - Configurable bash script to build your project with SAM.
* `bin/deploy` - Configurable bash script to deploy your app to with SAM.

#### Create CloudFormation S3 Bucket

The default name for the bucket in the `deploy` script would include your computer's username. You can change this in your script (WHICH WE RECOMMEND) or use the `CLOUDFORMATION_BUCKET` environment varable. Assuming you stick with the default:

```shell
aws s3 mb "s3://lamby.cloudformation.$(whoami)"
```

#### Configuration

We recommend getting started using [Rails Credentials](https://guides.rubyonrails.org/security.html#environmental-security) by setting the `RAILS_MASTER_KEY` environment variable in your `app.rb` file. The value be read from AWS Systems Manager [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) which Lamby has a client wrapper for. To set the master key value, use the following AWS CLI command.

```shell
aws ssm put-parameter \
  --name "/config/my_awesome_lambda/env/RAILS_MASTER_KEY" \
  --type "SecureString" \
  --value $(cat config/master.key)
```

Update your `app.rb` file and add this line right after `require 'lamby'`.

```ruby
ENV['RAILS_MASTER_KEY'] =
  Lamby::SsmParameterStore.get!('/config/my_awesome_lambda/env/RAILS_MASTER_KEY')
```

Finally, updated your `template.yaml` CloudFormation/SAM file by adding this to the `Properties` section of your `RailsFunction`. This addition allows your Lambda's runtime policy to be able to read configs from SSM Parameter store.

```yaml
Policies:
  - Version: "2012-10-17"
    Statement:
      - Effect: Allow
        Action:
          - ssm:GetParameter
          - ssm:GetParameters
          - ssm:GetParametersByPath
          - ssm:GetParameterHistory
        Resource:
          - !Sub arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/config/my_awesome_lambda/*
```

#### First Deploy!

Now your Rails app is ready to be deployed to AWS Lambda via CloudFormation & SAM.

```shell
$ ./bin/deploy
```

To see your newly created Lambda's API Gateway URL, log into the AWS Console or run the following command. This will describe the CloudFormation stack we just deployed and the `Outputs` from that template.

```shell
aws cloudformation describe-stacks \
  --stack-name "awesomebotlambda-production-us-east-1" | \
  grep OutputValue | \
  grep https
```


## Additional Documentation

In order to provide minimal code and ultimate flexibility for any type of Rails application on Lambda, optional or advanced features require that you write additional CloudFormation code or perform AWS Console actions to get the desired results.

To that end, we are using our GitHub issues along with the `[docs]` label as a project-focused Stack Overflow where we encourage you to participate in and ask questions. Here are a few high level docs now that may interests most users. Also, [browse all docs](https://github.com/customink/lamby/issues?q=is%3Aissue+is%3Aopen+label%3Adocs) or open a new `[question]` issue and we would be glad to help!

#### Local AWS Dependencies

* [Installing AWS CLI and AWS SAM](https://github.com/customink/lamby/issues/18)
* [Bin Scripts - Setup, Build, Server, & Deploy](https://github.com/customink/lamby/issues/17)

#### Other Guides Just For You!

* [Environments & Configuration](https://github.com/customink/lamby/issues/28)
* [Asset Hosts & Precompiling](https://github.com/customink/lamby/issues/29)
* [Custom Domain Name, Edge/Regional, & CloudFront](https://github.com/customink/lamby/issues/10)
* [API Gateway Permissions & CloudWatch Logs](https://github.com/customink/lamby/issues/6)
* [How Does Lamby Work?](https://github.com/customink/lamby/issues/12)
* [Performance & Real World Usage](https://github.com/customink/lamby/issues/16)
* [Database Connections](https://github.com/customink/lamby/issues/13)
* [Basic Ruby with Lambda & AWS SAM](https://github.com/customink/lamby/issues/14)
* [Docker Perf on Mac & Root Proxy SAM Bugs](https://github.com/customink/lamby/issues/15)


## About AWS SAM and CloudFormation

AWS SAM is shorthand for the [Serverless Application Model](https://github.com/awslabs/serverless-application-model) and it is a superset of CloudFormation - a language that describes and provisions your infrastructure using code. As your application grows and requires additional AWS resources, learning how to express this in your `template.yaml` is critical. We recommend the following links when needing to learn both SAM and CloudFormation.

* [AWS Serverless Application Model (SAM)](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md)
* [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)


## Contributing

After checking out the repo, run `./bin/setup` to install dependencies. Then, run `./bin/test` to run the tests. **NOTE: There are no tests now but adding them is on our TODO list.**

Bug reports and pull requests are welcome on GitHub at https://github.com/customink/lamby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## Code of Conduct

Everyone interacting in the Lamby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/customink/lamby/blob/master/CODE_OF_CONDUCT.md).
