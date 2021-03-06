require 'oystercard'

describe Oystercard do

  let(:card) {Oystercard.new}
  let(:entry_station) {double :station, :touch_in => 'Oxford Circus'}
  let(:exit_station) {double :station, :touch_out => "St Pauls"}

  it "has a #balance" do
    expect(subject::balance).to eq 0
  end

  it "user can #top_up" do
    expect(subject).to respond_to(:top_up).with(1).argument
  end

  it "#top_up adds money to card" do
    card.top_up(5)
    expect(card::balance).to eq 5
  end

  it "#deduct fair from balance" do
    card.top_up(1)
    card.send(:deduct)
    expect(subject::balance).to eq 0
  end

  describe 'top_up' do
    it "limits the customer to a max of £90" do
    expect{subject.top_up(91)}.to raise_error
  end

  it "checks to see the limit is £90" do
    expect(subject::limit).to eq 90
  end
  end

  it "has a an option for the user to touch in" do 
    expect(subject).to respond_to(:touch_in )
  end 

  it "Determains if the user is currently in a journy" do
    expect(card::in_journey).to eq false
  end

  it "It registers a users card as in journy" do 
    card.top_up(10)
    card.touch_in(entry_station)
    expect(card::in_journey).to eq true
  end

  it "Allows the user to touch out when the journey is over" do
    expect(subject).to respond_to(:touch_out)
  end

  it "It tracks when the user is no longer in a journey" do  
    card.touch_out(exit_station)
    expect(card::in_journey).to eq false  
  end

  it 'fails to #touch_in if @balance bellow £1' do
    expect{subject.touch_in(entry_station)}.to raise_error "Balance too low"
  end

  it 'deducts the fare from the users card when touching out' do
    card.top_up(5)
    card.touch_in('Oxford Circus')
    expect{card.touch_out(exit_station)}.to change{card::balance}.by (-1)
  end

  it 'remebers station after #touch_in' do
    card.top_up(5)
    card.touch_in(entry_station)
    expect(card.get_entry_station).to eq(entry_station)
  end

  it 'resets entry station when #touch_out' do
    card.top_up(5)
    card.touch_in(entry_station)
    card.touch_out(exit_station)
    expect(card::entry_station).to eq nil
  end

  it "check to see if the journy list is empty by default" do
    card = Oystercard.new 
    expect(card::journey_history).to eq []
  end

  it "saves your last journy to list" do
    card.top_up(5)
    card.touch_in(entry_station)
    card.touch_out(exit_station)
    expect(card::journey_history.last).to eq [entry_station, exit_station] 
  end 
end
