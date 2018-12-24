class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    def self.create_pairs
        self.check
        members = Member.where(active: true).shuffle

        pairs = []
        spoken_for = []

        members.each do |ma|
            ma.pairable
            mb = ma.pairable.detect{|m| !spoken_for.include?(member) || !spoken_for.include?(ma) }
            if mb
                pairs << self.new(member_a_id: ma.id, member_b_id: mb.id, current: true)
                spoken_for << ma
                spoken_for << mb
            else 
                pairs.detect do |p| 
                    bp = p.member_b.pairable.include?(members.select{|mem| !spoken_for.include?(mem)}
                    ap = p.member_a.pairable.include?(members.select{|mem| !spoken_for.include?(mem)}
                    if ma.pairable.include?(p.member_a) && bp
                        mb = bp.first
                        p.member_b = ma.id
                        spoken_for << ma
                        pairs << self.new(member_a_id: mb.id, member_b_id: p.member_b.id, current: true)
                    elsif ma.pairable.include?(p.member_b) && ap
                            mb = ap.first
                            p.member_a = ma.id
                            spoken_for << ma
                            pairs << self.new(member_a_id: mb.id, member_b_id: p.member_b.id, current: true)
                    else 
                        
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
