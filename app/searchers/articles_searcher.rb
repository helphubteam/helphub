# frozen_string_literal: true

class ArticlesSearcher < BaseSearcher
  SEARCH_PARAMS = %i[name limit text sort group].freeze
  GROUP_PARAM = :group
  AVAILABLE_GROUP_VALUES = %i[name text type].freeze

  def call
    scope = Article
    SEARCH_PARAMS.each do |key|
      value = search_params[key]
      scope = send("apply_#{key}", scope, value) if value.present?
    end

    scope
  end

  attr_reader :search_params

  private

  def apply_name(scope, value)
    ilike_scope(scope, :name, value)
  end

  def apply_text(scope, value)
    ilike_scope(scope, :content, value)
  end

  def apply_group(scope, field)
    raise 'wrong group field' if AVAILABLE_GROUP_VALUES.exclude?(field.to_sym)

    scope.group_by do |item|
      item.send(field)
    end.to_a.map do |(value, group)|
      {
        field: field,
        value: value,
        articles: group
      }
    end
  end
end
