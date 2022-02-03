require_relative '../lib/journey.rb'
require_relative '../lib/oystercard.rb'

describe Journey do
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
      minimum_balance = Journey::MINIMUM_BALANCE
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
      expect { subject.touch_out('exit_station') }.to change{ subject.balance }.by(-Journey::MINIMUM_FARE) 
    end
  end
end
