# Omgcnb

A fun little utility for interacting with cloud native buildpacks

## What

Cloud Native Buildpacks are awesome. You can compose your buildpack into many smaller pieces that can be reused. This utility scans a given project for `buildpack.toml` files and `CHANGELOG.md` to show you how the pieces depend on one another. As a bonus it can also check for sub-buildpacks that are unreleased and resolve the correct buildpack release order.

## Installation

Or install it yourself as:

    $ gem install omgcnb

## Usage

Scan a directory for buildpacks that need to be released:

```
$ omgcnb scan .

## Needs Release

1) heroku/nodejs-function-invoker
  - Update sf-fx-runtime-nodejs to 0.8.0

## All Buildpacks

- heroku/nodejs
  - heroku/nodejs-engine
  - heroku/nodejs-yarn
  - heroku/nodejs-typescript
  - heroku/procfile
  - heroku/nodejs-engine
  - heroku/nodejs-npm
  - heroku/nodejs-typescript
  - heroku/procfile
- heroku/nodejs-function
  - heroku/nodejs-engine
  - heroku/nodejs-npm
  - heroku/nodejs-typescript
  - heroku/nodejs-function-invoker
- heroku/nodejs-typescript
  - (no deps)
- heroku/nodejs-engine
  - (no deps)
- heroku/nodejs-yarn
  - (no deps)
- heroku/nodejs-function-invoker
  - (no deps)
- heroku/nodejs-npm
  - (no deps)
```

Run the command with `--help` for more info.

If you have more than one buildpack that has been modified the command will show the correct order that the buildpacks must be released:

```
$ omgcnb scan .

## Needs Release

1) heroku/nodejs-function-invoker
  - Update sf-fx-runtime-nodejs to 0.8.0
2) heroku/nodejs-function
  - Fix spelling in the readme

## All Buildpacks

# ...
```

In this example the output is indicating that `heroku/nodejs-function-invoker` needs to be deployed first, then after that `heroku/nodejs-function` buildpack needs deploy. The contents under each "needs release" show the changelog contents.

Optional dependant buildpacks are ignored by default, this tool does not yet support depending on buildpacks outside of the repo.

## How

For resolution order: dependencies are derived directly from `buildpack.toml` files. For knowing what needs to be released: The `CHANGELOG.md` files are parsed for contents in the `## Unreleased` section.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omgcnb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/omgcnb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omgcnb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/omgcnb/blob/main/CODE_OF_CONDUCT.md).
