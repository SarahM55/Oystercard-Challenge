require_relative '../lib/station'

describe Station do
  let(:station){ Station.new( "Baker St", 5) }

  it "initializes the station name" do
    expect(station.name).to eq "Baker St"
  end

  it "initializes a zone" do
    expect(station.zone).to eq 5
  end

end
