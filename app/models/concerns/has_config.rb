require 'active_support/concern'

module HasConfig
  extend ActiveSupport::Concern

  included do
    def self.setup_config(*arguments)
      self.config_fields = arguments

      config_fields.each do |field|
        field_name = field[:name].to_s

        define_method(field_name) do
          config_field(field_name)['value']
        end

        define_method("#{field_name}=") do |value|
          config_field(field_name)['value'] = value
        end
      end
    end

    def config_field(name)
      self.config ||= {}
      field = self.config[name.to_s] ||= {}
      field['value'] ||= self.class.config_field(name)[:value]
      field
    end

    def self.config_field(name)
      self.config_fields.find { |cf| cf[:name].to_s == name.to_s }
    end

    private

    cattr_accessor :config_fields
  end
end
