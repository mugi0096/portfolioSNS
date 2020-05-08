class Post < ApplicationRecord
    validates :title, {presence: true, length: {maximum: 30}}
    validates :description, {presence: true}

    def user
        return User.find_by(id: self.user_id)
    end
end
