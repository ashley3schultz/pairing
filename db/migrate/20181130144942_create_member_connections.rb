class CreateMemberConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :member_connections, :id => false do |t|
      t.integer :member_a_id
      t.integer :member_b_id
      t.timestamps
    end
  end
end
