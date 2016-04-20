class User::UpdateUsersStaffsService
  def self.process
    User.find_each do |user|
      user.update_attributes(staffs: [User.staffs[user.staff]])
    end
  end
end
