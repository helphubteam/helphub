# frozen_string_literal: true

module Admin
  module UserHelper
    def sex_field(field)
      field.sex.zero? ? I18n.t('female') : I18n.t('male')
    end
  end
end
