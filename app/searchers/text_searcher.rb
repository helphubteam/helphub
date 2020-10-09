# frozen_string_literal: true

class TextSearcher
  protected

  def search_fields
    raise NotImplementedError
  end

  def apply_search(scope)
    str = search_params[:search]
    return scope if str.blank?

    base_scope = scope.dup
    search_fields.each_with_index do |field, index|
      str.split(' ').compact.each_with_index do |word, word_index|
        query = "CAST(#{field} AS TEXT) ILIKE concat('%', ?, '%')"
        scope = if index.zero? && word_index.zero?
                  scope.where(query, word)
                else
                  scope.or(base_scope.where(query, word))
                end
      end
    end
    scope
  end
end
