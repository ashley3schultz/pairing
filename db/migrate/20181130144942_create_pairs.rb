class CreatePairs < ActiveRecord::Migration[5.2]
  def change
    create_table :pairs, :id => false do |t|
      t.integer :member_a_id
      t.integer :member_b_id
      t.boolean :current
      t.integer :pair_index
      t.timestamps
    end
  end
end
