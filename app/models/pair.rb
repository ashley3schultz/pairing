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

    def self.steal_pair(a)
        np = @@members.select{|mem| !@@paired.include?(mem)}
        @@pairs.detect do |p|
            bp = p.member_b.pairable.detect{ |mem| np.include?(mem)}
            ap = p.member_a.pairable.detect{ |mem| np.include?(mem)}
            if (a.pairable.include?(p.member_a) && bp) || (a.pairable.include?(p.member_b) && ap)
                if a.pairable.include?(p.member_a) && bp
                    self.add_pair(bp, p.member_b)
                    p.member_b = a.id
                    @@paired << a
                else
                    self.add_pair(ap, p.member_a)
                    p.member_a = a.id
                    @@paired << a
                end
            else 
                @@pairs.each do |p| 
                    new_set = []
                    if p.member_a.pairable.include?(p.member_a) && p.pairable.include?()
                        new_set << self.new(member_a_id: a.id, member_b_id: p.member_a.id, current: true)
                    else 
                        new_set << p
                    end
                    @@pairs = new_set
                end
            end
        end
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
