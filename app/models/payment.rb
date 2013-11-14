class Payment < ActiveRecord::Base
  belongs_to :user

  def payment_date
    datetime = self.created_at
    datetime.strftime("%m/%d/%Y")
  end

  def service_duration
    datetime = self.created_at.strftime("%m/%d/%Y")
    month_later = (self.created_at + 1.month).strftime("%m/%d/%Y")
    "#{datetime} - #{month_later}"
  end
end