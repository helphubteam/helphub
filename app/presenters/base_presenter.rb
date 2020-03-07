# frozen_string_literal: true

class BasePresenter
  def initialize(target)
    @target = target
  end

  attr_reader :target

  def call
    {
      id: target.id,
      created_at: I18n.l(target.created_at),
      updated_at: I18n.l(target.updated_at),
      type: target.class.name.underscore
    }
  end
end
