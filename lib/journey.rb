require_relative '../lib/oystercard.rb'

class Journey
  DEFAULT_BALANCE = 0
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :balance, :entry_station, :exit_station, :journeys

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance  
    @journeys = {}
    @complete = false
  end

  def top_up(amount)
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end
    
  def touch_in(station)
    fail "Insufficient funds for travel - balance below #{MINIMUM_BALANCE}" if balance < MINIMUM_BALANCE
    @journeys[:entry_station] = station
    fare(@entry_station, @exit_station) if in_journey?
    @entry_station = station
  end
    
  def touch_out(exit_station)
    @exit_station = exit_station
    @journeys[:exit_station] = exit_station
    fare(@entry_station, @exit_station)
    @entry_station = nil
  end

  def fare(entry, exit)
    entry == nil || exit == nil ? deduct(PENALTY_FARE) : deduct(MINIMUM_FARE)
  end

  def complete?
    @complete
  end

  def finish(station)
    self
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end