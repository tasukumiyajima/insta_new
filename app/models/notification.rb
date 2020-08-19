class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true
  belongs_to :micropost, optional: true
  belongs_to :comment, optional: true

  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  ACTION_VALUES = ["follow", "comment", "bookmark"]
  validates :action,  presence: true, inclusion: {in:ACTION_VALUES}
  validates :checked, inclusion: {in: [true,false]}

end

