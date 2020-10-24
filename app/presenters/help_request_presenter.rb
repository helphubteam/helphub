# frozen_string_literal: true

class HelpRequestPresenter
  delegate :id,
           :title,
           :phone,
           :address,
           :state,
           :comment,
           :number,
           :person,
           :mediated,
           :meds_preciption_required,
           :volunteer_id,
           :created_at,
           :period,
           :date_begin,
           :date_end,
           :updated_at,
           :volunteer,
           :recurring_in, to: :target

  def initialize(target)
    @target = target
  end

  def address
    [target.city, target.district, target.street, target.house, target.apartment].compact.join(' ')
  end

    private

  attr_reader :target
end
