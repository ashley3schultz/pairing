class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.boolean :active, default: true
      t.integer :m_num, default: -1
      t.integer :p_num, default: -1
      t.timestamps
    end
  end
end
