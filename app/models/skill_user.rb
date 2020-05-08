class SkillUser < ApplicationRecord
    def skill 
        return Skill.find_by(id: self.skill_id)
    end

    def user
        return User.find_by(id: self.user_id)
    end
end
