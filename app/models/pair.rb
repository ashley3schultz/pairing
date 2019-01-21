class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    @@members = []
    @@pairs = []
    @@paired = []

    def self.update_current
        pairs = Pair.order(pair_index:)
        index = self.get_pair_index
        if index >= pairs.last.pair_index}
            self.reset
            self.create_new_pair_sets
        else
            Pair.where(pair_index: index).update(current: false)
            Pair.where(pair_index: index + 1).update(current: true)
        end
    end

    def self.get_pair_index
        Pair.where(current: true).limit(1).pair_index
    end

    def self.create_new_pair_sets
        self.get_active_members
        len @@members.length
        index = 1
        while index < @@members.length
            @@paired.clear
            if index.odd?
                (index < len / 2) ? @@member.order(s_num:) : @@member.order(s_num: :desc)
            end
            @@members.each do |a|
                if !@@paired.include?(a)
                    mems = (index < len / 2) ? a.pairable.order(m_num: :desc) : a.pairable.order(m_num:)
                    b = mems.detect{|m| !@@paired.include?(m) }
                    self.add_pair(a, b, index)
                end
            end
            self.save_pairs
            index += 1
        end
        Pair.where(pair_index: 1).update(current: true)
    end

    def self.add_pair(a, b, i)
        @@pairs << self.new(member_a_id: a.id, member_b_id: b.id, current: false, pair_index: i)
        @@paired << a
        @@paired << b
    end

    def self.remove_me
        #self.remove_me if mems.length % 2 == 0
    end

    def self.get_active_members
        mems = Member.where(active: true).shuffle
        mems.each_with_index do |mem, i|
            mem.m_num = i + 1
            mem.s_num = i + 1
            @@members << mem
        end
    end

    def self.save_pairs
        @@pairs.each {|p| p.save}
    end

    def self.reset
        Pair.delete_all
        Member.update_all(m_num: 0, s_num: 0)
    end

end
