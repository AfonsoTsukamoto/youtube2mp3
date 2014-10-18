class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string :youtube_id, default: 0
      t.timestamps
    end
  end
end
