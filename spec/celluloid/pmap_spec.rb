require 'spec_helper'

describe Celluloid::Pmap do

  it 'should have a version number' do
    Celluloid::Pmap::VERSION.should_not be_nil
  end

  it 'should still map correctly' do
    [4,5,6,7].map{|x| x + 1}.should eq([5,6,7,8])
  end

  it 'should have same results when pmap' do
    [4,5,6,7].pmap{|x| x + 1}.should eq([5,6,7,8])
  end

  it 'should sleep in sequence for map' do
    expect {
      [1,2,3].map{|x| x; sleep(1) }
    }.to take_approximately(3).seconds
  end

  it 'should sleep in parallel for pmap' do
    expect {
      [1,2,3].pmap{|x| x; sleep(1) }
    }.to take_approximately(1).seconds
  end

  it 'should default to 5 threads at once'
  it 'can be set to many threads at once'

  it 'should be included in enumerable' do
    Enumerable.ancestors.should include(Celluloid::Pmap)
  end

end
