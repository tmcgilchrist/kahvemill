# -*- coding: utf-8 -*-
require 'spec_helper'

module KahveMill
  describe Parser do

    before do
      @parser = KahveMill::Parser.new
    end

    describe "strings" do
      it 'empty strings' do
        strings = ["''", "\"\""]
        strings.each do |str|
          @parser.parse(str)[:string].to_s.should eql(str)
        end
      end

      it 'normal strings' do
        strings = ["'sonnet'", "'föö'", "\"öö\"", "'foo'", "'\u1234'", "'\u0041'", "'\b'"]
        strings.each do |str|
          @parser.parse(str)[:string].to_s.should eql(str)
        end
      end
    end

    describe "numbers" do
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

    describe "names" do
      it 'accepts a name' do
        ['a_name', 'z____123', 'a123'].each do |name|
          @parser.parse(name)[:name].to_s.should eql(name)
        end
      end

      it 'should not accept malformed names' do
        ['r$sh', '1_abc', '1eet'].each do |not_names|
          lambda do
            @parser.parse(not_names)[:name]
          end.should raise_error
        end
      end

      it 'accepts in_or' do
        ['in_or', 'a_while'].each do |word|
          @parser.parse(word)[:name].to_s.should eql(word)
        end
      end
    end
    describe "keywords" do
      it 'accepts a reserved word' do
        ["break", "case", "catch", "const", "continue", "default", "delete", "do", "else",
          "false", "finally", "for", "function", "if", "in", "instanceof", "new", "null",
          "return", "switch", "this", "throw", "true", "try", "typeof",  "void", "while",
          "with"].each do |word|
          @parser.parse(word)[:keyword].to_s.should eql(word)
        end
      end
    end

    describe "statements" do
      it "accept a simple var statement" do
        @parser.parse("var name = 0;").should have_tokens([:keyword, :name, :assign, :number])
      end

      it "accepts commas between statements" do
        puts @parser.parse("var other = 1, another = 13, other = 1;")
        @parser.parse("var other = 1, another = 13, other = 1;").map {|i|i.should have_tokens([:var_statement, :keyword, :name, :assign, :number])}
        # TODO Not happy with the shape of the returned object, what can we do to make it closer to Rubinius output.
#         {:keyword=>"var"@0, :var_statement=>{:name=>"other"@4, :assign=>"="@10, :integer=>"1"@12}}
# {:var_statement=>{:name=>"another"@15, :assign=>"="@23, :integer=>"13"@25}}
# {:var_statement=>{:name=>"other"@29, :assign=>"="@35, :integer=>"1"@37}}
      end

    end
  end
end

RSpec::Matchers.define :have_tokens do |expected|
  match do |actual|
    expected.collect {|i| actual.keys.include? i}
  end
end
