module Api
  module V1
    module HelpRequestCases
      class UseCaseError < StandardError; end
      class Base
        def initialize(options)
          @options = options
          @help_request = options[:help_request]
          @volunteer = options[:volunteer]
          @params = options[:params]
        end

        protected

        attr_reader :options, :help_request, :volunteer, :params

        def success_response
          Api::HelpRequestPresenter.new(@help_request.reload, volunteer).call
        end

        def error_response(error_message)
          { errors: [{ message: error_message }] }
        end

        def within_error_handler
          yield
        rescue UseCaseError => e
          raise_error(e.message)
        end

        def raise_error(name)
          raise UseCaseError, I18n.t("help_request_cases.errors.#{name}")
        end

        def write_log(kind)
          @help_request.logs.create!(
            user: volunteer,
            kind: kind.to_s,
            comment: params[:comment]
          )
        end
      end
    end
  end
end
