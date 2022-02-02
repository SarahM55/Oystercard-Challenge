class Oystercard
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  MINIMUM_BALANCE = 1

  attr_reader :balance

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @in_journey = false
  end

  def top_up(amount)
    fail 'You have reached the maximum possible balance of 90' if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    fail "Insufficient funds for travel - balance below #{MINIMUM_BALANCE}" if insufficient_funds?
    @in_journey = true
  end

  def touch_out
    deduct_fare(MINIMUM_FARE)
    @in_journey = false
  end

  def insufficient_funds?
    @balance < MINIMUM_BALANCE
  end

  private

  def deduct_fare(fare)
    @balance -= fare
  end

end
