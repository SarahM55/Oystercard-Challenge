class Oystercard
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90

  attr_reader :balance

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
  end

  def top_up(amount)
    fail 'You have reached the maximum possible balance of 90' if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end
end
