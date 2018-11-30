class Member < ApplicationRecord
    has_and_belongs_to_many(:members,
    :join_table => "member_connections",
    :foreign_key => "member_a_id",
    :association_foreign_key => "member_b_id")
end
