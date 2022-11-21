# Lamby [![Actions Status](https://github.com/customink/lamby/workflows/CI/CD/badge.svg)](https://github.com/customink/lamby/actions) [![Codespaces](https://img.shields.io/badge/Codespaces-✅-black)](https://github.com/features/codespaces)

<h2>Simple Rails &amp; AWS Lambda Integration using Rack</h2>

Lamby is an [AWS Lambda Web Adapter](https://github.com/awslabs/aws-lambda-web-adapter) for Rack applications.

<img src="https://raw.githubusercontent.com/customink/lamby_site/master/app/assets/images/lamby-arch-hero.png" alt="Lamby: Simple Rails & AWS Lambda Integration"/>

The goal of this project is to provide minimal code to allow your Rails application to respond to incoming [AWS Lambda Function Handler in Ruby](https://docs.aws.amazon.com/lambda/latest/dg/ruby-handler.html) `event` and `context` objects in the Lambda handler. We support Application Load Balancer integration or API Gateway.

```ruby
def handler(event:, context:)
  Lamby.handler $app, event, context
end
```

## Quick Start

https://lamby.custominktech.com/docs/quick_start

## Full Documentation

https://lamby.custominktech.com/docs/installing_aws_sam

## Contributing

This project is built for [GitHub Codespcaes](https://github.com/features/codespaces) using the [Development Container](https://containers.dev) specification. Even though Codespaces may not be available to everyone, this project's containers are easy to work for anyone with any editor.

Once you have the repo cloned and setup with a dev container using Codespaces, [VS Code](#using-vs-code), or the [Dev Container CLI](#dev-container-cli), run the following commands. This will install packages, build your project, and run tests without needing to connect to SSM.

```shell
$ ./bin/setup
$ ./bin/test
```

#### Using VS Code

If you have the [Visual Studio Code Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed you can easily clone this repo locally, use the "Open Folder in Container..." command, and use the integrated terminal for your setup and test commands. Example shown below:

Bug reports and pull requests are welcome on GitHub at https://github.com/customink/lamby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Lamby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/customink/lamby/blob/master/CODE_OF_CONDUCT.md).
