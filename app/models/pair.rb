class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    @@members = []
    @@pairs = []
    @@paired = []
    @@index = 1

    def self.update_current
        pairs = Pair.order(pair_index:)
        i = Pair.where(current: true).limit(1).pair_index
        if i >= pairs.last.pair_index
            self.reset
            self.create_new_pair_sets
        else
            Pair.update(current: false)
            Pair.where(pair_index: i + 1).update(current: true)
        end
    end

    ###_RESET_###

    def self.reset
        Pair.delete_all
        Member.update_all(m_num: 0, s_num: 0)
    end

    ###_CREATE_NEW_###

    def self.create_new_pair_sets
        self.get_active_members
        len @@members.length / 2
        while @@index < len
            self.first_half
        end
        if @@index == len
            self.middle
        end
        while @@index > len && @@index < @@members.length
            self.second_half
        end
        Pair.where(pair_index: 1).update(current: true)
    end

    def self.get_active_members
        mems = Member.where(active: true).shuffle
        mems.each_with_index do |mem, i|
            mem.m_num = i + 1
            mem.s_num = i + 1
            @@members << mem
        end
    end

    def self.first_half
        members = @@members.order(s_num:) if @@index.odd?
        members.each do |a|
            if !@@paired.include?(a)
                mems = a.pairable.order(m_num: :desc)
                b = mems.detect{|m| !@@paired.include?(m) }
                self.add_pair(a, b, @@index)
                a.s_num += b.m_num
                b.s_num += a.m_num
            end
        end
        self.save_pairs
    end

    def self.middle
        num = @@members.length / 3
        members = []
        @@members.each_with_index do |m, i|
            if i > num && i < num * 2
              members << m
            end
        end
        members.each do |a|
            if !@@paired.include?(a)
                mems = a.pairable.order(m_num: :desc)
                b = mems.detect{|m| !@@paired.include?(m) }
                self.add_pair(a, b, @@index)
                a.s_num += b.m_num
                b.s_num += a.m_num
            end
        end
        self.first_half
    end

    def self.second_half
        members = @@members.order(s_num: :desc) if @@index.odd?
        members.each do |a|
            if !@@paired.include?(a)
                mems = a.pairable.order(m_num:)
                b = mems.detect{|m| !@@paired.include?(m) }
                self.add_pair(a, b, @@index)
                a.s_num += b.m_num
                b.s_num += a.m_num
            end
        end
        self.save_pairs
    end

    def self.add_pair(a, b, i)
        @@pairs << self.new(member_a_id: a.id, member_b_id: b.id, current: false, pair_index: i)
        @@paired << a
        @@paired << b
    end

    def self.save_pairs
        @@pairs.each {|p| p.save}
        @@index += 1
        @@paired.clear
    end
        # def self.remove_me
        #     #self.remove_me if mems.length % 2 == 0
        # end
end

# m1 = [12, 11, 2, 6, 3, 4, 9, 10, 7, 8, 5]
# m2 = [11, 12, 1, 5, 4, 3, 10, 9, 8, 7, 6]
# m3 = [10, 9, 4, 8, 1, 2, 5, 6, 11, 12, 7]
# m4 = [9, 10, 3, 7, 2, 1, 6, 5, 12, 11, 8]
# m5 = [8, 7, 6, 2, 11, 12, 3, 4, 9, 10, 1]
# m6 = [7, 8, 5, 1, 12, 11, 4, 3, 10, 9, 2]
# m7 = [6, 5, 8, 4, 9, 10, 11, 12, 1, 2, 3]
# m8 = [5, 6, 7, 3, 10, 9, 12, 11, 2, 1, 4]
# m9 = [4, 3, 10, 12, 7, 8, 1, 2, 5, 6, 11]
# m10 = [3, 4, 9, 11, 8, 7, 2, 1, 6, 5, 12]
# m11 = [2, 1, 12, 10, 5, 6, 7, 8, 3, 4, 9]
# m12 = [1, 2, 11, 9, 6, 5, 8, 7, 4, 3, 10]
# s_s = ['a','','a','','a','','d','','d','','d']
# m_s = [9,9,9,9,9,'mid-9',1,1,1,1,1]
