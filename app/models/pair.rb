class Pair < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member

    def self.create_pairs
        if Member.all.first.pairs.size >= Member.where(active: true).size
            self.delete_all
        end
        members = Member.where(active: true).shuffle
        spoken_for = []
        @pairs = []
        binding.pry
        members.each do |m|
            i = 0
            a = m != members[i]
            b = m.pairs.include?(!members[i])
            c = spoken_for.include?(!members[i])
            until (a && b && c) do
                i+= 1
            end
            @pairs << self.new(member_a_id: m.id, member_b_id: member[i].id)
            spoken_for << members[i]
            spoken_for << m
        end
    end
end
