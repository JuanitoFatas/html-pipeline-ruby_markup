# frozen_string_literal: true

module HTML
  class Pipeline
    module RubyMarkup
      class Element
        def initialize(word, reading, uri)
          @word = word
          @reading = reading
          @uri = uri
        end

        def original
          if uri
            %([#{word}(#{reading})](#{uri}))
          else
            %([#{word}(#{reading})])
          end
        end

        def to_html
          if uri
            %(<ruby><a href="#{uri}" target="_blank" rel="noopener noreferrer" itemprop="url" aria-label="search #{word} on jisho.org">#{word}</a><rt>#{reading}</rt></ruby>)
          else
            "<ruby>#{word}<rp>(</rp><rt>#{reading}</rt><rp>)</rp></ruby>"
          end
        end

        private
        attr_reader :word, :reading, :uri
      end
    end
  end
end
