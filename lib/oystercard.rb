class Oystercard
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  MINIMUM_BALANCE = 1

  attr_reader :balance, :entry_station

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
  end

  def top_up(amount)
    fail 'You have reached the maximum possible balance of 90' if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(entry_station)
    fail "Insufficient funds for travel - balance below #{MINIMUM_BALANCE}" if balance < MINIMUM_BALANCE
    @entry_station = entry_station
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  #def insufficient_funds?
  #  @balance < MINIMUM_BALANCE
  #end

  private

  def deduct(amount)
    @balance -= amount
  end

end
