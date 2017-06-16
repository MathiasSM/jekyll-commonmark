module Jekyll
  module Converters
    class Markdown::CommonMark
      def initialize(config)
        Jekyll::External.require_with_graceful_fail "../commonmarker-pygments/commonmarker/pygments.rb"
        begin
          @options = config['commonmark']['options'].collect { |e| e.upcase.to_sym }
        rescue NoMethodError
          @options = [:DEFAULT]
        else
          @options.reject! do |e|
            unless CommonMarker::Config::Parse.keys.include? e.to_sym
              Jekyll.logger.warn "CommonMark:", "#{e} is not a valid option"
              Jekyll.logger.info "Valid options:", CommonMarker::Config::Parse.keys.join(", ")
              true
            end
          end
        end
      end

      def convert(content)
        CommonMarker::Pygments.render_doc(content, @options).to_html
      end
    end
  end
end
