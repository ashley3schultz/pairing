class Member < ApplicationRecord
    has_and_belongs_to_many(:members,
    :join_table => "pairs",
    :foreign_key => "member_a_id",
    :association_foreign_key => "member_b_id")

    def pairs
        pairs = []
        connections = Pair.where("member_a_id = #{self.id}").or(Pair.where("member_b_id = #{self.id}"))
        connections.each do |c| 
            if c.member_a_id == self.id
                pairs << Member.find(c.member_b_id)
            else 
                pairs << Member.find(c.member_a_id)
            end
        end 
        pairs
    end 

    def pairable
        members = Member.all.where.not(id: self.id)
        pairable = members.select{|member| !self.pairs.include?(member) && self != member}
    end

end
