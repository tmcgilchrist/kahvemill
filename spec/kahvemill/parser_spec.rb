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

    it 'accepts a name' do
      ['a_name', 'z____123', 'a123'].each do |name|
        @parser.parse(name)[:name].to_s.should eql(name)
      end
    end

    it 'should not accept malformed names' do
      ['r$sh', '1_abc', '1eet'].each do |not_names|
        lambda do
          @parser.parse(not_names)[:name]
        end.should raise_error Parslet::UnconsumedInput
      end
    end

    it 'accepts a reserved word' do
      ["break", "case", "catch", "const", "continue", "default", "delete", "do", "else",
       "false", "finally", "for", "function", "if", "in", "instanceof", "new", "null",
       "return", "switch", "this", "throw", "true", "try", "typeof", "var", "void", "while",
       "with"].each do |word|
        @parser.parse(word)[:keyword].to_s.should eql(word)
      end
    end

    it 'accepts in_or' do
      ['in_or', 'a_while'].each do |word|
          @parser.parse(word)[:name].to_s.should eql(word)
      end
    end
  end
end
