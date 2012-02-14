# VegetableGlue

Easy way to start/stop/restart a dependent Rails API app in a consumer's acceptance tests.
Uses `database_cleaner`'s `:truncation` mode to clean out your databases after each run.

## Installation & Usage

In both apps' Gemfiles:

``` ruby
gem 'vegetable_glue'
```

In the provider (API):

* Create or use a Rails environment that has a database that you don't mind nuking (say `test`, `acceptance`, or `cucumber`)
* Modify `config/routes.rb`:

``` ruby
require 'vegetable_glue/routes'

MyApp::Application.routes.draw do
  # ... your other routes ...

  acceptance_helper_routes #=> for the :acceptance env, or
  acceptance_helper_routes_for :cucumber #=> for the :cucumber env
end
```

The two additional routes are only added in that environment.

In the consumer (Frontend):

* For Cucumber, add the following to `features/support/env.rb`:

``` ruby
require 'vegetable_glue/cucumber'
```

* Then add this to the `config/environments/<environment>.rb` file that Cucumbers runs under:

``` ruby
require 'vegetable_glue'

VegetableGlue.url = 'http://localhost:6161/' #=> include the port in here, too, that's where the app will run
VegetableGlue.path = '../path/to/the/app'
```

The app will clean its database on each scenario. To restart the app, pass in the environment variable `REGLUE`:

    REGLUE=true bundle exec cucumber

Or, use one of the Rake tasks: `vegetable:unglue` to shut down and `vegetable:reglue` to shutdown, then clean.

If you're using ActiveResource, a good source of the URL is `ActiveResource::Base.site`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

