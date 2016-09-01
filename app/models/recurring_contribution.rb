class RecurringContribution < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :contributions

  validates_presence_of :project, :user
  validates_presence_of :credit_card, on: :update
  validates_numericality_of :value, greater_than_or_equal_to: 5.0

  scope :active, -> { where(cancelled_at: nil) }
  scope :cancelled, -> { where.not(cancelled_at: nil) }

  def self.on_day(day)
    where('extract(day from created_at) = ?', day)
  end

  def cancel
    update_attribute(:cancelled_at, Time.current)
  end
end
