class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    @@members = []
    @@pairs = []
    @@paired = []

    def self.add_pair(a, b)
        @@pairs << self.new(member_a_id: a.id, member_b_id: b.id, current: true)
        @@paired << a
        @@paired << b
    end 

    def self.create_pairs
        self.check
        members = Member.where(active: true).shuffle
        members.each do |a|
            a.pairable
            if !@@paired.include?(a)
                b = a.pairable.detect{|p| !@@paired.include?(p) }
                if b
                    self.add_pair(a, b)
                else
                    self.steal_pair(a)
                end
            end
        end
    end

    def self.check
        num = 0
        Member.all.each do |mem| 
            num = mem.pairs.size if num < mem.pairs.size 
        end
        if num >= Member.where(active: true).size - 1
            Pair.delete_all
        else 
            update_all(current: false)
        end
    end

end
