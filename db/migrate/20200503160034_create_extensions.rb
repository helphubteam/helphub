# frozen_string_literal: true

class CreateExtensions < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE extension IF NOT EXISTS postgis;
      CREATE extension IF NOT EXISTS hstore;
    SQL
  end
end
