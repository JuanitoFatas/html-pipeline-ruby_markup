# frozen_string_literal: true

require "html/pipeline"
require_relative "ruby_markup/transformer"

module HTML
  class Pipeline
    module RubyMarkup
      class Filter < HTML::Pipeline::TextFilter
        def call
          Transformer.run(text.dup.to_s)
        end
      end
    end
  end
end
