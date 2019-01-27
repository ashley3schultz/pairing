class Member < ApplicationRecord
    has_and_belongs_to_many(:members,
    :join_table => "pairs",
    :foreign_key => "member_a_id",
    :association_foreign_key => "member_b_id")

    @@members = []

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

    def self.get_active
        mems = Member.where(active: true).shuffle
        mems.each_with_index do |mem, i|
            mem.m_num = i if mem.m_num == nil
            @@members << mem
        end
    end

    def get_next
        i = self.p_num -1
        if i == a.m_num
            @@members.find_by(m_num: 0)
        elsif i == 0
            @@members.find_by(m_num: @@members.last.m_num)
        else 
            @@members.find_by(m_num: i)
        end
    end

end
