require 'rails_helper'

RSpec.describe TransparencyReport, :type => :model do

  describe "Validations" do
    it{ is_expected.to validate_presence_of :attachment }
  end

end
