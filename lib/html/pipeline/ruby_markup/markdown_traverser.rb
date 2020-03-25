# frozen_string_literal: true

module HTML
  class Pipeline
    module RubyMarkup
      # To go through a markdown document. Mainly used to decide if we are in
      # code blocks to decide if we should escape underscored usernames.
      class MarkdownTraverser
        def initialize(markdown)
          @lines = markdown.dup.lines
          init_position
        end

        def each
          lines.each do |line|
            update_position(line.include?(CODEBLOCK_MARKER))
            yield(line)
          end
        end

        def in_codeblock?
          prev == true && current == false
        end

        private

        CODEBLOCK_MARKER = "```".freeze
        private_constant :CODEBLOCK_MARKER

        attr_reader :lines
        attr_accessor :prev, :current

        def init_position
          self.prev = false
          self.current = lines.first.include?(CODEBLOCK_MARKER)
        end

        def update_position(current)
          self.current = current
          self.prev = current ? !prev : prev
        end
      end
    end
  end
end
