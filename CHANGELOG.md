# Keep A Changelog!

See this http://keepachangelog.com link for information on how we want this documented formatted.

## v4.0.0 (unreleased)

### Added

- New `Lamby.config.rack_app` with default Rack builder.
- The `Lamby.command` to simplify `CMD` with the new config.app from above.

#### Removed

- All lamby installer templates.
- Remove SAM env checks used during debug mode.
- Removed showing environment variables in debug mode.
- Need to `require: false` when adding the Lamby gem to your `Gemfile`. 
- Dotenv integration. Use [Crypteia](https://github.com/customink/crypteia) now.

#### Changed

- Tested Rack 3.x.

## v3.1.3

#### Fixed

- The ::Rack::Utils namespace. Fixes #123.

## v3.1.2

#### Fixed

- Lambdakiq Handler Integration. Fixes #120.

## v3.1.1

#### Fixed

- X-Request-Start header value for New Relic with API Gateway.

## v3.1.0

#### Added

- Add X-Request-Start header for New Relic with API Gateway.

## v3.0.3

#### Fixed

- Ruby 2.7 Warnings | Logger. Thanks @jessedoyle

## v3.0.2

#### Added

- Runner now returns STDOUT/STDERR as body.

## v3.0.1

#### Fixed

- Fix Lambdakiq integration. Thanks #97.

## v3.0.0

#### Added

- Automatically handle `Lambdakiq.jobs?(event)`.
- New event for tasks like DB migrations. #80 #93

#### Changed

- Updated template files to latest lambda container standards.

## v2.8.0

#### Fixed

- Perform rack body closing hooks on request #85

## v2.7.1

#### Removed

- Bootsnap setup convenience require.

## v2.7.0

#### Added

- Support EventBridge events in handler with default proc to log.

## v2.6.3

#### Added

- Bootsnap setup convenience require.

## v2.6.2

- Fixed Rack::Deflate usage with an ALB.

## v2.6.1

#### Fixed

- Support redirects with empty response body.

#### Added

- Tests for enabling Rack::Deflate middleware by passing RACK_DEFLATE_ENABLED env variable.

## v2.6.0

#### Fixed

- Support multiple Set-Cookie headers for all rest types.

## v2.5.3

#### Fixed

- Base64 encode response body if the rack response is gzip or brotli compressed.

## v2.5.2

- SSM file always overwrites. Fixes #65.

## v2.5.1

#### Fixed

- Quoting in describe-subnets #62 Thanks @atwoodjw

## v2.5.0

#### Changed

- Install files to favor containers.

## v2.2.2

#### Changed

- More ActiveSupport removal. Better ENV.to_h.

## v2.2.1

#### Changed

- More ActiveSupport removal from SsmParameterStore.

## v2.2.0

#### Changed

- Remove dependency on `activesupport` for rack-only applications.
- Remove ActiveSupport artifacts:
  - Replace `strip_heredoc` with `<<~HEREDOC`.
  - Remove instances of `Object#try`, replace with `&.`.
  - Use `Rack::Utils.build_nested_query` in place of `Object#to_query`.
  - Replace `Object#present?` with `to_s.empty?`.
  - Replace `Array.wrap` with `Array[obj].compact.flatten`.
- Add a check against the `RAILS_ENV` AND `RACK_ENV` environment
  variables prior to enabling debug mode.

## v2.1.0

#### Changed

- Only load the railtie if `Rails` is defined.

## v2.0.1

#### Changed

- Remove Rails runtime dep. Only rack is needed.

## v2.0.0

Support for new API Gateway HTTP APIs!!!

#### Changed

- The `Lamby.handler` must have a `:rack` option. One of `:http`, `:rest`, `:alb`.
- Renamed template generators to match options above.
- The `lamby:install` task now defaults to HTTP API.
- Changed the name of `:api` rack option to `:rest`.
- Removed `export` from Dotenv files. Better Docker compatability.

#### Added

- New rack handler for HTTP API v1 and v2.
- Lots of backfill tests for, ALBs & REST APIs.

## v1.0.3

#### Changed

- Change shebangs to `#!/usr/bin/env bash`

## v1.0.2

#### Changed

- Adds an optional 'overwrite' parameter to #to_env.

## v1.0.1

#### Changed

- Links in bin/build templates to point to lamby.custominktech.com site.

## v1.0.0

#### Fixed

- ALB query params & binary responses. Fixes #38.

## v0.6.0

#### Added

- APPLICATION LOAD BALANACER SUPPORT!!! The new default. Use `rack: :api` option to handler for API Gateway support.

#### Changed

- Rake task `lamby:install` now defaults to `application_load_balancer`

## v0.5.1

#### Fixed

- The .gitignore file template. Fix .aws-sam dir.

## v0.5.0

#### Added

- Template generators for first install. Ex: `./bin/rake -r lamby lamby:install:api_gateway`.
- New `Lamby::SsmParameterStore.get!` helper.

## v0.4.1

#### Fixed

- Fix type in v0.4.0 fix below.

## v0.4.0

#### Fixed

- File uploads in #33 using `CONTENT_TYPE` and `CONTENT_LENGTH`.

## v0.3.2

#### Added

- Pass Request ID for CloudWatch logs. Fixes #30.

## v0.3.1

#### Changed

- Docs and SAM template tweaks.

## v0.3.0

#### Added

- Secure configs rake task.
- Project bin setup and tests.

#### Changed

- SAM template tweaks.

## v0.2.0

#### Changed

- Simple docs and project re-organization.

## v0.1.0

#### Added

- New gem and placeholder in rubygems.
