# frozen_string_literal: true

require_relative "element"
require_relative "markdown_traverser"

module HTML
  class Pipeline
    module RubyMarkup
      class Transformer
        def self.run(content)
          new(content).run
        end

        def initialize(content)
          @content = content
        end

        def run
          transform_ruby_markups!
        end

        private

        # Matching [漢字(かんじ)] or [漢字(かんじ)](url)
        RubyTagPattern = %r(
          (?<!!)
          \[
            (?<word>[^\[\(\)]+(?=\())(?<!\s)
            \((?<reading>[^\[\]]+(?=\)))\)
          \]
          (\((?<uri>[^\(\)]+(?=\)))\))*
        )x
        RubyMarkupInsideCodePattern = /`.*#{RubyTagPattern}.*`/

        attr_reader :content

        def traverser
          @traverser ||= MarkdownTraverser.new(content)
        end

        def transform_ruby_markups!
          traverser.each do |line|
            next if traverser.in_codeblock?
            next if line.match?(RubyMarkupInsideCodePattern)

            matches = line.scan(RubyTagPattern)

            if !matches.empty?
              matches.each do |word, reading, uri|
                ruby_element = Element.new(word, reading, uri)
                line.sub!(ruby_element.original, ruby_element.to_html)
              end
            end
          end.join
        end
      end
    end
  end
end
