# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :analytics, type: :text
end
