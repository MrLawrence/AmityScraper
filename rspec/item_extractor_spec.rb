require 'rspec'
require_relative 'spec_helper'

describe ItemExtractor do
  before :each do
    @ex = ItemExtractor.new
  end

  describe "#new" do
    it "takes no parameter and returns an ItemExtractor object" do
      @ex.should be_an_instance_of ItemExtractor
    end
  end
end