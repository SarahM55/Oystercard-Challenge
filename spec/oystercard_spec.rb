require_relative '../lib/oystercard.rb' 

describe Oystercard do
  it 'should have an opening balance of 0' do
    expect(subject.balance).to eq Oystercard::DEFAULT_BALANCE
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect { subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it 'raises an error if the maximum balance is reached' do 
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up maximum_balance
      expect { subject.top_up 1 }.to raise_error "You have reached the maximum possible balance of #{maximum_balance}"
    end 
  end

  describe '#journey' do
    let(:journeys){ {:entry_station => 'station', :exit_station => 'exit_station'} }
    it 'expects that a user is not initially in a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'stores the entry and exits stations upon touching out' do
      subject.top_up(5)
      subject.touch_in('station')
      subject.touch_out('exit_station')
      expect(subject.journeys).to include journeys
    end

    it 'checks that the card has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end
  end

  describe '#touch_in' do
    it 'allows a user to touch in' do
      expect(subject).to respond_to(:touch_in)
   end

    it 'should change the active status of the card' do
      subject.top_up(5)
      subject.touch_in('station')
      expect(subject.in_journey?).to eq (true)
    end

    it 'raises an error if a user touches in without minimum balance' do
      minimum_balance = Oystercard::MINIMUM_BALANCE
      expect{ subject.touch_in('station') }.to raise_error "Insufficient funds for travel - balance below #{minimum_balance}"
    end
  end

  describe '#touch_out' do
    it 'allows a user to touch out' do
      expect(subject).to respond_to(:touch_out)
    end

    it 'should change the active status of the card' do
      subject.touch_out('exit_station')
      expect(subject.in_journey?).to eq false 
    end

    it 'charges the user for the journey upon touch out' do
      subject.top_up(5)
      subject.touch_in('station')
      subject.touch_out('exit_station')
      expect { subject.touch_out('exit_station') }.to change{ subject.balance }.by(-Oystercard::MINIMUM_FARE) 
    end
  end

  describe '#entry_station' do
    let(:station){ double :station }
    it 'should record which station the user has entered from' do
      subject.top_up(5)
      subject.touch_in(station)
      expect(subject.entry_station).to eq station
    end
  end
end
