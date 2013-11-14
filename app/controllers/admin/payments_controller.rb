class Admin::PaymentsController < AdminController
  def index
    @payments = Payment.last(10)
  end
end