
# Lamby [![Build Status](https://travis-ci.org/customink/lamby.svg?branch=master)](https://travis-ci.org/customink/lamby)

<img src="https://user-images.githubusercontent.com/2381/54278425-af365680-4568-11e9-972a-6b73e0a44bb5.jpg" alt="Lamby: Simple Rails & AWS Lambda Integration using Rack." align="right" /><h3>Simple Rails & AWS Lambda Integration using Rack</h3>

The goal of this project is to provide minimal code to convert API Gateway `event` and `context` objects into Rack events for your Rails application in a Lambda handler. Most everything else is [documentation](https://github.com/customink/lamby/issues?q=is%3Aissue+is%3Aopen+label%3Adocs+sort%3Acreated-asc).

```ruby
def handler(event:, context:)
  Lamby.handler $app, event, context
end
```


## Getting Started

#### Add The Gem

Add the Lamby gem to your Rails project's `Gemfile`. Recommend only requiring Lamby in your `app.rb` so your local development or test logs still work.

```ruby
gem 'lamby', require: false
```

#### Create Handler

Create an `app.rb` file that will be the source for the Lambda's handler. Example:

```ruby
require_relative 'config/boot'
require 'lamby'
require_relative 'config/application'
require_relative 'config/environment'

$app = Rack::Builder.new { run Rails.application }.to_app

def handler(event:, context:)
  Lamby.handler $app, event, context
end
```

#### Create SAM Template

Create an [AWS SAM](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md) `template.yaml` file that expresses your function's resources and how it receives events from API Gateway. Please use this full [doc/template.yaml](doc/template.yaml) file hosted here as a starting point. The basic template accomplishes the following.

* Defines a `RailsEnv` input parameter.
  - Applies this to the `RAILS_ENV` environment variable.
* Creates a API Gateway resource named `RailsApi`.
  - Ensures that the stage name is set to the Rails env.
  - Using inline Swagger, define a root `/` via GET and greedy proxy `/{resource+}` via ANY.
  - Allow any binary media type to be a valid response.
* Creates a Lambda function resource named `RailsFunction`.
  - Sets the handler to `app.handler`. File above.
  - Defines events from API above for both root and greedy proxy.
* Simple `Outputs` that echos the resources you created.

#### Git Ignores

Ensure both `/.aws-sam` and `/vendor/bundle` are added to `.gitignore`. AWS SAM uses the `.aws-sam` directory to build your project. No file there should be committed to source control.

```shell
$ echo '/.aws-sam' >> .gitignore
$ echo '/vendor/bundle' >> .gitignore
```

#### Get Running

To run your Lambda locally or deploy it, please read the following docs.

* [Installing AWS CLI and AWS SAM](https://github.com/customink/lamby/issues/18)
* [Bin Scripts - Setup, Build, Server, & Deploy](https://github.com/customink/lamby/issues/17)

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
