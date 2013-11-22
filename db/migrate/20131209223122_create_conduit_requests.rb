class CreateConduitRequests < ActiveRecord::Migration
  def change
    create_table :conduit_requests do |t|
      t.string  :driver
      t.string  :action
      t.text    :options
      t.string  :file
      t.string  :requestable_type
      t.integer :requestable_id

      t.timestamps
    end
  end
end
