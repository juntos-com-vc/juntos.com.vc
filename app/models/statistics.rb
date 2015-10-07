class Statistics < ActiveRecord::Base

  def total_contributed
    read_attribute(:total_contributed) + 6319
  end

end
