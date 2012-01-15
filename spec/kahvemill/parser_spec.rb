require 'spec_helper'

module KahveMill
  describe Parser do

    before do
      @parser = KahveMill::Parser.new
    end

    it 'accepts integers' do
      integers = ['0', '13', '9']

      integers.each do |i|
        @parser.parse(i)[:integer].to_s.should eql(i)
      end
    end

    it 'accepts fractions' do
      floats = ["1.1", "13.33333"]

      floats.each do |f|
        @parser.parse(f)[:float].to_s.should eql(f)
      end
    end

    it 'accepts an exponents' do
      exponents = ["1e10", "1E10", "12e+123", "12E+444", "0e-1"]

      exponents.each do |e|
        @parser.parse(e)[:float].to_s.should eql(e)
      end
    end
  end
end
