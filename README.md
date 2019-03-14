
# Lamby [![Build Status](https://travis-ci.com/customink/lamby.svg?branch=master)](https://travis-ci.com/customink/lamby)

<img src="https://user-images.githubusercontent.com/2381/54278425-af365680-4568-11e9-972a-6b73e0a44bb5.jpg" alt="Lamby: Simple Rails & AWS Lambda Integration using Rack." align="right" /><h3>Simple Rails & AWS Lambda Integration using Rack</h3>

The goal of this project is to provide minimal code along with comprehensive documentation to get your Rails application running under AWS Lambda.

This gem's code will focus mainly on converting API Gateway `event` and `context` objects into a Rack `env` to send to your Rails application. Most everything else is documentation. Please use the table of contents below to quickly navigate to any guides that interests you the most.

### Table of Contents

* [How Does Lamby Work?](#how-does-lamby-work)
* [Getting Started](#getting-started)
* [Installing AWS CLI and AWS SAM](#installing-aws-cli-and-aws-sam)
* [Bin Script Conventions](#bin-script-conventions)
* [SAM Bugs and Patches](#sam-bugs-and-patches)
* [About AWS SAM and CloudFormation](#about-aws-sam-and-cloudformation)
* [Performance](#performance)
* [Database Connections](#database-connections)
* [Basic Ruby and Lambda](#basic-ruby-and-lambda)
* [Contributing](#contributing)
* [Code of Conduct](#code-of-conduct)

The following are code and/or documentation items we are currently working on. Please open an issue and suggest a new one if you do not see it here. Thanks!

* [ ] Ensure Rack integration is solid and high quality.
  - Cookies, Sessions, Query Params, Forms, etc.
* [ ] Encrypted Session Secret via AWS System Manager Parameter Store.
* [ ] Better Gemfile usage for development and/or test groups.
* [ ] Hooking up Rails asset precompile to a S3 bucket and using an asset host.
* [ ] Ensure Rails tagged UUID logging matches APIGateway/Lambda IDs in CloudWatch.
* [ ] Documentation around using ImageMagick and Lambda Layers.
  - https://twitter.com/clare_liguori/status/1087861037712400385
  - https://github.com/mthenw/awesome-layers
* [ ] Explore how New Relic could be used if at all.
* [ ] Add `isBase64Encoded` to response as needed.
* [ ] Better Railtie hooks, and gem structure. Tests.


## How Does Lamby Work?

Since [Rails is on Rack](https://guides.rubyonrails.org/rails_on_rack.html), the Lamby gem relies on converting API Gateway events sent to your `handler` and converting them to a [Rack](https://rack.github.io) `env` object. We then send that object to your application and pass the result back to the Lambda handler which expects a simple object/hash containing the `statusCode`, `body`, and `headers`. It is that simple.

Thanks to the projects and people below which inspired our code and implementation strategies.

* [AWS Sinatra Example](https://github.com/aws-samples/serverless-sinatra-sample)
* [Rack Lambda Handler Pull Request](https://github.com/rack/rack/pull/1337)
* [Serverless Rack Plugin](https://github.com/logandk/serverless-rack)
* [Jets' Rack Implementation](https://github.com/tongueroo/jets/blob/master/lib/jets/controller/rack/env.rb)

Other small details which Lamby helps with.

* Ensure all `Logger` objects use `STDOUT`.
* Sets the `RAILS_LOG_TO_STDOUT` environment variable.
* Provides a debug response in development (or when `LAMBY_DEBUG` env set) using `?debug=1` query param.


## Getting Started

ℹ️ Some of these steps may be automated once we learn they are worth automating.

#### New Basic Rails Application Example

Assuming you have a basic Rails application, or maybe you want to make a new one from scratch.

```shell
$ gem install rails
$ rails new my_app \
  --skip-active-record \
  --skip-action-mailer \
  --skip-active-storage \
  --skip-action-cable \
  --skip-spring \
  --skip-coffee \
  --skip-turbolinks \
  --skip-bootsnap
$ cd my_app
$ rbenv local 2.5.3
```

#### Add The Gem

Add the Lamby gem to your Rails project's `Gemfile`.

```ruby
gem 'lamby'
```

#### Create Handler

Create an `app.rb` file that will be the source for the Lambda's handler. Example:

```ruby
ENV['SECRET_KEY_BASE'] = '...' # Temporary hack, see TODO list above.
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

Create an [AWS SAM](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md) `template.yaml` file that expresses your function's resources and how it receives events from API Gateway. Please use this full [doc/template.yml](doc/template.yml) file hosted here as a starting point. The basic template accomplishes the following.

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

To run your Lambda locally or deploy it, please read the following sections:

* [Installing AWS CLI and AWS SAM](#installing-aws-cli-and-aws-sam)
* [Bin Script Conventions](#bin-script-conventions)


## Installing AWS CLI and AWS SAM

You will need both of these tools to run SAM locally and/or deploy your Lambda application to AWS. SAM also requires the usage of Docker.

* [Install SAM CLI](https://aws.amazon.com/serverless/sam/)
* [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [Install Docker](https://docs.docker.com/install/)


## Bin Script Conventions

Below is a list of bin scripts we recommend creating for your AWS SAM & Rails projects. Each section contains a short description on what the script does. Remember, think of these scripts as starting points! You should add to or adjust each to meet your needs while following [Strap](https://github.com/MikeMcQuaid/strap) and [Scripts to Rule Them All](https://githubengineering.com/scripts-to-rule-them-all/) conventions.

#### bin/bootstrap

Provisions required dependencies for local development, including:
  * The proper ruby version via [rbenv](https://github.com/rbenv/rbenv) & [ruby-build](https://github.com/rbenv/ruby-build)
  * The proper python version via [pyenv](https://github.com/pyenv/pyenv) & [pipenv](https://pipenv.readthedocs.io/en/latest/)

_Note: This is currently scoped to macOS._

```shell
./bin/bootstrap
```


#### bin/setup

Nothing fancy here, just calling build where most of the work is done.

```shell
#!/bin/bash
set -e

./bin/build
```

#### bin/build

This makes use of the [sam build](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-build.html) command along with the `--use-container` option to ensure gems with native extensions are built for both the AWS' Linux platform and your native host platform. It also:

* Sets up a pristine build environment.
* Removes unnecessary project files copied over during the build.
* Cleans build directory's vendor gems of unwanted cache files. Saves ~40% [package size](https://docs.aws.amazon.com/lambda/latest/dg/limits.html).
* Builds local platform gems on top of copied Linux platform gems.

```shell
#!/bin/bash
set -e

# Clean any previous bundle dir.
rm -rf ./.bundle \
  ./vendor/bundle \
  ./.aws-sam/build \
  node_modules

# Clean up Rails
./bin/rails log:clear tmp:clear

# Ensure native extensions built for platform.
sam build --use-container

# Clean build dir of unneeded artifacts.
pushd ./.aws-sam/build/RailsFunction/
rm -rf .aws-sam \
  .git \
  node_modules \
  test \
  template.yaml \
  package.json \
  yarn.lock \
  tmp
rm -rf vendor/bundle/ruby/2.5.0/cache
popd

# Avoid doing local bundle work if building for deploy.
if [ -z ${SKIP_LOCAL_BUNDLE+x} ]; then
  # Copy the build bundle to allow server native extensions to work.
  cp -R ./.aws-sam/build/RailsFunction/vendor/bundle ./vendor/bundle
  # Make a comingled bundle dir for build and this platform.
  rm -rf ./.bundle
  bundle install --path vendor/bundle
fi
```

#### bin/deploy

Uses both the [sam package](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-package.html) and [sam deploy](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-deploy.html) commands to ship your Lambda stack to AWS. It also:

* Uses or sets the `RAILS_ENV` variable. Defaults to `development`.
* Uses or sets the `CF_BUCKET_NAME` variable. This is the name of the S3 bucket that holds your deploy artifacts.
* Sets the `SKIP_LOCAL_BUNDLE` environment variable used by build.

```shell
#!/bin/bash
set -e

export RAILS_ENV=${RAILS_ENV:="development"}
export CF_BUCKET_NAME=${CF_BUCKET_NAME:="mycloudformationbucket.example.org"}
export SKIP_LOCAL_BUNDLE="1"

./bin/build

sam package \
    --template-file ./.aws-sam/build/template.yaml \
    --output-template-file ./.aws-sam/build/packaged.yaml \
    --s3-bucket $CF_BUCKET_NAME \
    --s3-prefix "my-app-${RAILS_ENV}"

sam deploy \
    --template-file ./.aws-sam/build/packaged.yaml \
    --stack-name "my-app-${RAILS_ENV}" \
    --capabilities "CAPABILITY_IAM" \
    --parameter-overrides \
      RailsEnv=${RAILS_ENV}
```

So an example `bin/deploy-production` script would look like this.

```shell
#!/bin/bash
set -e

export RAILS_ENV="production"

./bin/deploy
```

#### bin/server

Start the normal Rails development server. Make sure to run setup/build prior.

```shell
#!/bin/bash
set -e

./bin/rails server
```

#### bin/server-sam

Uses the [sam local start-api](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-start-api.html) command to

```shell
#!/bin/bash
set -e

# Delete the static build to avoid local server using it.
rm -rf ./.aws-sam/build
sam local start-api
```


## SAM Bugs and Patches

Unfortunately, the SAM CLI project has a few needed enhancements and if you decide to do any local development via the [sam local start-api](#binserver-sam) command, it will need to be patched on your local machine. I used the commands below to find the two files needing patching.

```shell
$ which sam # Use directory info below in find command.
$ find /usr/local -name container.py | grep samcli
$ find /usr/local -name local_apigw_service.py | grep samcli
```

Here are the issues we have created on the SAM CLI project. Details on the patches below.

* [Add Docker Delegated Consistency to Volume](https://github.com/awslabs/aws-sam-cli/pull/1046)
* [Missing Authentication Token for root path '/'](https://github.com/awslabs/aws-sam-cli/issues/437)

#### Docker Volume Mount Performance on Mac

If you are on a Mac, Docker has a [known performance issue](https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076) when sharing volumes due to the overhead of keeping files in sync. This performance issue means your Rails application could take ~60 seconds to load in development. Thankfully, Docker has [tooling in place](https://docs.docker.com/docker-for-mac/osxfs-caching/) to help.

Once you found the correct `container.py` file, make this change below to tell the Docker SDK to mount the volume with both the `ro` (read-only) option and `delegated` consistency mode.

```diff
@@ -95,7 +95,7 @@
                     # https://docs.docker.com/storage/bind-mounts
                     # Mount the host directory as "read only" inside container
                     "bind": self._working_dir,
-                    "mode": "ro"
+                    "mode": "ro,delegated"
                 }
             },
             # We are not running an interactive shell here.
```

#### Fixing Root SAM Local Proxy Paths

We need our API Gateway to use both a root path and a greedy proxy path to forward to Rails in development. SAM has a feature compatibility bug where it forces static file hosting on the root path. Once you found the correct `local_apigw_service.py` file, make the change below to disable static `public` directory assets on the root path. Don't worry, Rails & Rack will serve your static files automatically instead.

```diff
@@ -71,7 +71,7 @@
         """

         self._app = Flask(__name__,
-                          static_url_path="",  # Mount static files at root '/'
+                          static_url_path=None,  # Mount static files at root '/'
                           static_folder=self.static_dir  # Serve static files from this directory
                           )
```


## About AWS SAM and CloudFormation

AWS SAM is shorthand for the [Serverless Application Model](https://github.com/awslabs/serverless-application-model) and it is a superset of CloudFormation - a language that describes and provisions your infrastructure using code. As your application grows and requires additional AWS resources, learning how to express this in your `template.yml` is critical. We recommend the following links when needing to learn both SAM and CloudFormation.

* [AWS Serverless Application Model (SAM)](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md)
* [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)


## Performance

Because your Rails app is initialized outside the `handler` it should be loaded into memory and respond to requests in a very timely manner. Make sure to set the `MemorySize` as needed in your `template.yml` and you should get comparable performance to EC2. Initial tests show that basic view rendering only takes a few milliseconds. Please do share your performance results if you have any!


## Database Connections

If you want to use a database with Rails and Lambda, I would highly suggest using DynamoDB with the excellent [AWS Record](https://github.com/aws/aws-sdk-ruby-record) gem. However, if you want to explore and share how you might use Lamby with PG or MySQL, I'd love to hear about it.


## Basic Ruby and Lambda

Curious about using AWS SAM with Ruby and no Rails? Please see this 757rb (Norfolk Ruby User's Group) repository for an overview on how to kick-start your next Ruby project.

* [Using Ruby with AWS Lambda & SAM](https://github.com/757rb/hello-757rb-lambda)


## Contributing

After checking out the repo, run `./bin/setup` to install dependencies. Then, run `./bin/test` to run the tests. **NOTE: There are no tests now but adding them is on our TODO list.**

Bug reports and pull requests are welcome on GitHub at https://github.com/metaskills/lamby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## Code of Conduct

Everyone interacting in the Lamby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/metaskills/lamby/blob/master/CODE_OF_CONDUCT.md).
