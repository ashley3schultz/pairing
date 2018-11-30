class MemberConnection < ApplicationRecord
    belongs_to :member_a, :class_name => :Member
    belongs_to :member_b, :class_name => :Member
end
