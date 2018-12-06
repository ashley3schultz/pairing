class Member < ApplicationRecord
    has_and_belongs_to_many(:members,
    :join_table => "member_connections",
    :foreign_key => "member_a_id",
    :association_foreign_key => "member_b_id")

    def self.pairs(id)
        pairs = []
        MemberConnection.where(member_a_id: id).each do |m| 
            mem = Member.find(m.member_b_id)
            pairs << mem 
        end
        MemberConnection.where(member_b_id: id).each do |m| 
            mem = Member.find(m.member_a_id)
            pairs << mem
        end 
        pairs
    end 

end
