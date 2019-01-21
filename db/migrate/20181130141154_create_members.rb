class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.boolean :active
      t.integer :m_num, default: 0
      t.integer :s_num, default: 0
      t.timestamps
    end
  end
end
