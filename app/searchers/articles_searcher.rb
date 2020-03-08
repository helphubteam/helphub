# frozen_string_literal: true

class ArticlesSearcher < BaseSearcher
  SEARCH_PARAMS = %i[query limit sort group].freeze
  GROUP_PARAM = :group
  AVAILABLE_GROUP_VALUES = %i[name content kind created_at updated_at].freeze
  QUERY_FIELDS = %i[name content].freeze

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

  def apply_query(scope, value)
    query = QUERY_FIELDS.map do |field|
      "#{field} ILIKE concat('%', ?, '%')"
    end
    bind_values = (0...QUERY_FIELDS.size).map { value }
    scope.where(query.join(' OR '), *bind_values)
  end

  def apply_group(scope, field)
    raise 'wrong group field' if AVAILABLE_GROUP_VALUES.exclude?(field.to_sym)

    article_groups = scope.group_by do |item|
      item.send(field)
    end

    article_groups.map do |value, group|
      {
        field: field,
        value: value,
        articles: group
      }
    end
  end
end
