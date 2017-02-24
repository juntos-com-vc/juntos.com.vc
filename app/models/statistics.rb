class Statistics < ActiveRecord::Base

  def total_contributed
    read_attribute(:total_contributed).to_i + 6319
  end

end
