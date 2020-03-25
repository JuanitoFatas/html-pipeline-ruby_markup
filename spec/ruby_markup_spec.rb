# frozen_string_literal: true

require "html/pipeline"
require "html/pipeline/ruby_markup"

RubyMarkup = HTML::Pipeline::RubyMarkup

RSpec.describe RubyMarkup::Filter do
  it "works with content has no ruby markups" do
    input = "markdown"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq input
  end

  it "translate [text(reading)] into ruby markup" do
    input = "[漢字(かんじ)]"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq "<ruby>漢字<rp>(</rp><rt>かんじ</rt><rp>)</rp></ruby>"
  end

  it "works with markdown link syntax" do
    input = "[漢字(かんじ)](https://jisho.org/search/漢字)"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq %(<ruby><a href="https://jisho.org/search/漢字" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search 漢字 on jisho.org">漢字</a><rt>かんじ</rt></ruby>)
  end

  it "works when annotates two characters separately" do
    input = "[漢(かん)][字(じ)]"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq "<ruby>漢<rp>(</rp><rt>かん</rt><rp>)</rp></ruby><ruby>字<rp>(</rp><rt>じ</rt><rp>)</rp></ruby>"
  end

  it "works when annotates and links separately" do
    input = "[漢(かん)](https://jisho.org/search/漢)[字(じ)](https://jisho.org/search/字)"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq %(<ruby><a href="https://jisho.org/search/漢" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search 漢 on jisho.org">漢</a><rt>かん</rt></ruby><ruby><a href="https://jisho.org/search/字" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search 字 on jisho.org">字</a><rt>じ</rt></ruby>)
  end

  it "works when annotates two characters separately but links together" do
    input = "[[漢(かん)][字(じ)]](https://jisho.org/search/漢字)"

    result = RubyMarkup::Filter.new(input).call

    # MarkdownFilter comes after will convert [...](...) into link
    expect(result).to eq "[<ruby>漢<rp>(</rp><rt>かん</rt><rp>)</rp></ruby><ruby>字<rp>(</rp><rt>じ</rt><rp>)</rp></ruby>](https://jisho.org/search/漢字)"
  end

  it "does not translate wrong ruby markup syntax (no space before left paren)" do
    input = "[漢字  (かんじ)]"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq input
  end

  it "works with markdown link" do
    input = "[漢字(かんじ)](https://jisho.org/search/漢字)"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq %(<ruby><a href="https://jisho.org/search/漢字" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search 漢字 on jisho.org">漢字</a><rt>かんじ</rt></ruby>)
  end

  it "works for two ruby markups close by" do
    input = "[歯肉(しにく)](https://jisho.org/search/歯肉)を[磨く(みがく)]"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq %(<ruby><a href="https://jisho.org/search/歯肉" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search 歯肉 on jisho.org">歯肉</a><rt>しにく</rt></ruby>を<ruby>磨く<rp>(</rp><rt>みがく</rt><rp>)</rp></ruby>)
  end

  it "does mistake treat image inside link as ruby markup" do
    input = "[![github.com image](https://github.com/example.png)](https://github.com)"

    result = RubyMarkup::Filter.new(input).call

    expect(result).not_to include "<ruby>"
  end

  it "does not translate ruby markup inside code" do
    input = "`[漢字(かんじ)]`"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq input
  end

  it "does not translate ruby markup inside code with arbitrary spaces" do
    input = "`  [漢字(かんじ)]     `"

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq input
  end

  it "does not translate ruby markup inside code block" do
    input = <<~Markdown
      ```
      [漢字(かんじ)]
      ```
    Markdown

    result = RubyMarkup::Filter.new(input).call

    expect(result).to eq input
  end

  it "translate ruby markup outside the code block" do
    input = <<~Markdown
      This will be translated: [漢字(かんじ)]

      ```
      [漢字(かんじ)]
      ```
    Markdown

    result = RubyMarkup::Filter.new(input).call

    expect(result).to include %(This will be translated: <ruby>漢字<rp>(</rp><rt>かんじ</rt><rp>)</rp></ruby>)
  end

  it "does not translate ruby markup inside code block with arbitrary text around" do
    input = <<~Markdown
      ```markdown
      This is
      [漢字(かんじ)]
      (Kanji)
      ```
    Markdown

    result = RubyMarkup::Filter.new(input).call

    expect(result).not_to include "<ruby>"
  end

  it "correctly translates a document uses ruby heavily" do
    input = fixture("ruby.md")

    result = RubyMarkup::Filter.new(input).call

    expect(result.scan("<ruby>").size).to eq 4
  end

  def fixture(name)
    path = File.expand_path("../fixtures/#{name}", __FILE__)
    IO.read(path)
  end
end
