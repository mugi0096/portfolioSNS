class Skill < ApplicationRecord
    def self.all_names
        skills = self.all
        all_names = []
        skills.each do |skill|
            all_names << skill.name
        end
        return all_names
    end
end
