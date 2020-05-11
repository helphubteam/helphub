# frozen_string_literal: true

class BasePresenter
  def initialize(target)
    @target = target
  end

  attr_reader :target

  def call
    {
      id: target.id,
      # created_at: I18n.l(target.created_at, format: :short), ToDO: Add time::formats::short regex to locale file
      # updated_at: I18n.l(target.updated_at, format: :short),
      type: target.class.name.underscore
    }
  end
end
