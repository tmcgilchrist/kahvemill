require 'spec_helper'

module KahveMill
  describe Parser do

    before do
      @parser = KahveMill::Parser.new
    end

    describe 'hello' do
      it 'accepts integer zero' do
        @parser.parse("0")[:integer].should eql("0")
      end

      it 'accepts mulit-digit integer'

      it 'accepts single-digit integer'
    end
  end
end
