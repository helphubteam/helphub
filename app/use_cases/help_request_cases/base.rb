module HelpRequestCases
  class UseCaseError < StandardError; end
  class Base
    def initialize(options)
      @options = options
      @help_request = options[:help_request]
      @volunteer = options[:volunteer]
    end

    protected

    attr_reader :options, :help_request, :volunteer

    def success_response
      HelpRequestPresenter.new(@help_request.reload).call
    end

    def error_response(error_message)
      { errors: [ { message: error_message } ] }
    end

    def within_error_handler
      yield
    rescue UseCaseError => e
      raise_error(e.message)
    end

    def raise_error(name)
      raise UseCaseError, I18n.t("help_request_cases.errors.#{name}")
    end
  end
end