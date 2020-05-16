# frozen_string_literal: true

class HelpRequestsSearcher < BaseSearcher
  def call
    HelpRequest.reorder([:state, "updated_at DESC"])
  end
end
