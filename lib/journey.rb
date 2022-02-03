require_relative '../lib/oystercard.rb'

class Journey
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  attr_reader :balance, :entry_station, :exit_station, :journeys

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance  
    @journeys = {}
  end

  def top_up(amount)
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end
    
  def touch_in(station)
    fail "Insufficient funds for travel - balance below #{MINIMUM_BALANCE}" if balance < MINIMUM_BALANCE
    @entry_station = station
    @journeys[:entry_station] = station
  end
    
  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @exit_station = exit_station
    @journeys[:exit_station] = exit_station
    @entry_station = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end