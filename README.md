
# Parliament.uk-utilities
[Parliament.uk-utilities][parliament.uk-utilities] is a [Rails][rails] application designed to hold the utility parts of the new [parliament.uk][parliament.uk] website made by the [Parliamentary Digital Service][parliamentary-digital-service].

### Contents
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [utilities Rails Application](#parliament-rails-application)
  - [Running the application](#running-the-application)
  - [Running the tests](#running-the-tests)
- [Contributing](#contributing)
- [License](#license)

## Requirements
[Parliament.uk-utilities][parliament.uk-utilities] requires the following:
* [Ruby][ruby]
* [Bundler][bundler]


## Getting Started
Clone the repository:
```bash
git clone https://github.com/ukparliament/Parliament.uk-utilities.git
cd Parliament.uk-utilities
```

#### Utilities Rails Application
The [Parliament.uk-utilities][parliament.uk-utilities] application holds the routes, controllers and views that make up all the utility elements of the new [parliament.uk][parliament.uk] website. Utilities include the areas of the website which are not individual items or lists but are standalone endpoints eg. search, postcodes, resources.

### Running the application
To run the application locally, run:
```bash
bundle install

bundle exec rails s
```

### Running the tests
We use [RSpec][rspec] as our testing framework and tests can be run using:
```bash
bundle exec rspec
```

## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Ensure your changes are tested using [Rspec][rspec]
6. Create a new Pull Request

## License
[Parliament.uk-utilities][parliament.uk-utilities] is available as open source under the terms of the [Open Parliament Licence][info-license].

[parliament.uk-utilities]:          https://github.com/ukparliament/parliament.uk-utilities
[parliamentary-digital-service]: https://github.com/ukparliament
[ruby]:                          https://www.ruby-lang.org/en/
[bundler]:                       http://bundler.io/
[rspec]:                         http://rspec.info
[rails]:                         http://rubyonrails.org
[parliament.uk]:                 http://www.parliament.uk/

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
