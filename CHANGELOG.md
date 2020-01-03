# Keep A Changelog!

See this http://keepachangelog.com link for information on how we want this documented formatted.

## v1.0.3

#### Changed

* Change shebangs to `#!/usr/bin/env bash`


## v1.0.2

#### Changed

* Adds an optional 'overwrite' parameter to #to_env.

## v1.0.1

#### Changed

* Links in bin/build templates to point to lamby.custominktech.com site.


## v1.0.0

#### Fixed

* ALB query params & binary responses. Fixes #38.


## v0.6.0

#### Added

* APPLICATION LOAD BALANACER SUPPORT!!! The new default. Use `rack: :api` option to handler for API Gateway support.

#### Changed

* Rake task `lamby:install` now defaults to `application_load_balancer`


## v0.5.1

#### Fixed

* The .gitignore file template. Fix .aws-sam dir.


## v0.5.0

#### Added

* Template generators for first install. Ex: `./bin/rake -r lamby lamby:install:api_gateway`.
* New `Lamby::SsmParameterStore.get!` helper.


## v0.4.1

#### Fixed

* Fix type in v0.4.0 fix below.


## v0.4.0

#### Fixed

* File uploads in #33 using `CONTENT_TYPE` and `CONTENT_LENGTH`.


## v0.3.2

#### Added

* Pass Request ID for CloudWatch logs. Fixes #30.


## v0.3.1

#### Changed

* Docs and SAM template tweaks.


## v0.3.0

#### Added

* Secure configs rake task.
* Project bin setup and tests.

#### Changed

* SAM template tweaks.


## v0.2.0

#### Changed

* Simple docs and project re-organization.


## v0.1.0

#### Added

* New gem and placeholder in rubygems.
