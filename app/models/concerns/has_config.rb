require 'active_support/concern'

module HasConfig
  extend ActiveSupport::Concern

  included do

    def self.has_config(*arguments)
      @config_fields = arguments

      @config_fields.each do |field|
        field_name = field[:name].to_s
        default_value = field[:value]
        input = field[:input]

        define_method(field_name) do
          self.config ||= {}
          self.config[field_name] ||= { 'value' => default_value, 'input' => input }
          self.config[field_name]['value']
        end

        define_method("#{field_name}=") do |value|
          self.config ||= {}
          self.config[field_name] ||= { 'value' => default_value, 'input' => input }
          self.config[field_name]['value'] = value
        end

        define_method("#{field_name}_label") do
          I18n.t("activerecord.attributes.#{self.class.name.underscore}.configs.#{field_name}")
        end

        define_method("#{field_name}_input") do
          self.config ||= {}
          self.config[field_name] ||= { 'value' => default_value, 'input' => input }
          self.config[field_name]['input']
        end
      end
    end
  end
end
