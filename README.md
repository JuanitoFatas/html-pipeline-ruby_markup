# HTML::Pipeline::RubyMarkup

`HTML::Pipeline::RubyMarkup` provides a [HTML::Pipeline](https://github.com/jch/html-pipeline)
filter to easily write [ruby markups] in Markdown documents.

## Installation

Add this line to your application‘s `Gemfile`:

```ruby
gem "html-pipeline-ruby_markup"
```

Or install it yourself as:

    $ gem install html-pipeline-ruby_markup

## Usage

`HTML::Pipeline::RubyMarkup` processes Text, so it **must** come before the
markdown filter.

```ruby
require "html/pipeline"
require "html/pipeline/ruby_markup"

pipeline = HTML::Pipeline.new [
  HTML::Pipeline::RubyMarkup::Filter,
  HTML::Pipeline::MarkdownFilter,
]

result = pipeline.call <<-MARKDOWN.strip_heredoc
  [漢字(かんじ)]
MARKDOWN

puts result[:output].to_html
```

prints:

```html
<ruby>
漢字<rp>(</rp><rt>かんじ</rt><rp>)</rp>
</ruby>
```

## Contributing

Please see the [CONTRIBUTING.md](/CONTRIBUTING.md) file.

## License

Please see the [LICENSE.md](/LICENSE.md) file.

[ruby markups]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby
