# Lamby [![Actions Status](https://github.com/customink/lamby/workflows/CI/CD/badge.svg)](https://github.com/customink/lamby/actions) [![Codespaces](https://img.shields.io/badge/Codespaces-✅-black)](https://github.com/features/codespaces)

<h2>Simple Rails &amp; AWS Lambda Integration using Rack</h2>
<a href="https://lamby.custominktech.com"><img src="https://raw.githubusercontent.com/customink/lamby/master/images/social2.png" alt="Lamby: Simple Rails & AWS Lambda Integration using Rack." align="right" width="450" style="margin-left:1rem;margin-bottom:1rem;" /></a>

Lamby is an [AWS Lambda Web Adapter](https://github.com/awslabs/aws-lambda-web-adapter) for Rack applications.

We support Lambda [Function URLs](https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html), [API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) (HTTP or REST, all payload versions), and even  [Application Load Balancer](https://docs.aws.amazon.com/lambda/latest/dg/services-alb.html) integrations.

## Quick Start

https://lamby.custominktech.com/docs/quick-start

## Full Documentation

https://lamby.custominktech.com/docs/anatomy

## Contributing

This project is built for [GitHub Codespaces](https://github.com/features/codespaces) using the [Development Container](https://containers.dev) specification. Once you have the repo cloned and setup with a dev container using either Codespaces or [VS Code](#using-vs-code), run the following commands. This will install packages and run tests.

```shell
$ ./bin/setup
$ ./bin/test
```

#### Using VS Code

If you have the [Visual Studio Code Dev Container](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed you can easily clone this repo locally, use the "Open Folder in Container..." command. This allows you to use the integrated terminal for the commands above.

## Code of Conduct

Everyone interacting in the Lamby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/customink/lamby/blob/master/CODE_OF_CONDUCT.md).

Bug reports and pull requests are welcome on GitHub at https://github.com/customink/lamby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
