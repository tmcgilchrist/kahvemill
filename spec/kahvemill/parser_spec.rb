require 'spec_helper'

module KahveMill
  describe Parser do

    before do
      @parser = KahveMill::Parser.new
    end

    describe 'integer' do
      it 'accepts integer zero' do
        @parser.parse("0")[:integer].to_s.should eql("0")
      end

      it 'accepts mulit-digit integer' do
        @parser.parse("13")[:integer].to_s.should eql("13")
      end

      it 'accepts single-digit integer' do
        @parser.parse("9")[:integer].to_s.should eql("9")
      end
    end

    describe 'fraction' do
      it 'accepts fraction' do
        @parser.parse(".1")[:fraction].to_s.should eql(".1")
      end
    end

    describe 'exponent' do
      it 'accepts an exponent' do
        exponents = ["e10", "E10", "e+123", "E+444", "e-1"]

        exponents.each do |e|
          @parser.parse(e)[:exponent].to_s.should eql(e)
        end
      end
    end
  end
end
