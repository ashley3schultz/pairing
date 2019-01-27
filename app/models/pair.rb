class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    def self.reset
        Pair.delete_all
        Member.update_all(m_num: -1, p_num: -1)
    end

    def self.create_pairs
        i = 0
        mems = Member.get_active
        mems.each { |m| i = m.pairs.size if i < m.pairs.size }
        self.reset if mems.last.m_num <= i

        mems.each do |a|
            if a.m_num != 0 && a.p_num >= 0
                b = a.get_next
                self.create(member_a_id: a.id, member_b_id: b.id)
                a.p_num = b.m_num
                b.p_num = a.m_num
            end
        end
    end

end