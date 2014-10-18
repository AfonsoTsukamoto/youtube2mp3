class AddStatusToMedia < ActiveRecord::Migration
  def change
    add_column :media_contents, :processed, :boolean, default: false
  end
end
