# -*- coding: utf-8 -*-
require 'spec_helper'
require 'parslet/rig/rspec'

describe KahveMill::Parser do

  let(:parser) { KahveMill::Parser.new }

  context "literal parsing" do
    let(:expr_parser) { parser.expression }

    context "strings" do
      it 'parses empty strings' do
        expect(expr_parser).to parse("''")
        expect(expr_parser).to parse("\"\"")
      end

      it 'normal strings' do
        expect(expr_parser).to parse("'sonnet'")
        expect(expr_parser).to parse("'föö'")
        expect(expr_parser).to parse("\"öö\"")
        expect(expr_parser).to parse("'foo'")
        expect(expr_parser).to parse("'\u1234'")
        expect(expr_parser).to parse("'\u0041'")
        expect(expr_parser).to parse("'\b'")
      end
    end

    context "numbers" do
      it 'accepts integers' do
        expect(expr_parser).to parse('0')
        expect(expr_parser).to parse('13')
        expect(expr_parser).to parse('9')
      end

      it 'accepts fractions' do
        expect(expr_parser).to parse('1.1')
        expect(expr_parser).to parse('13.33333')
      end

      it 'accepts an exponents' do
        expect(expr_parser).to parse("1e10")
        expect(expr_parser).to parse("1E10")
        expect(expr_parser).to parse("12e+123")
        expect(expr_parser).to parse("12E+444")
        expect(expr_parser).to parse("0e-1")
      end
    end

    describe "names" do
      it 'accepts a name' do
        expect(expr_parser).to parse('a_name')
        expect(expr_parser).to parse('z____123')
        expect(expr_parser).to parse('a123')
      end

      it 'should not accept malformed names' do
        expect(expr_parser).to_not parse('r$sh')
        expect(expr_parser).to_not parse('1_abc')
        expect(expr_parser).to_not parse('1eet')
      end
    end

    describe "keywords" do
      it 'accepts a reserved word' do
        ["break", "case", "catch", "const", "continue", "default", "delete", "do", "else",
          "false", "finally", "for", "function", "if", "in", "instanceof", "new", "null",
          "return", "switch", "this", "throw", "true", "try", "typeof",  "void", "while",
          "with"].map {|keyword| expect(expr_parser).to parse(keyword) }
      end
    end
  end

  context "statement parsing" do
    let(:expr_parser) { parser.expression }

    describe "var statements" do
      it "accept a simple var statement" do
        expect(expr_parser).to parse("var name = 0;")
        expect(expr_parser).to parse("var name = 'string';")
      end

      it "accepts commas between statements" do
        expect(expr_parser).to parse("var other = 1, another = 13, other = 1;")
      end
    end

    describe "disruptive statements" do
      it "accepts break statement" do
        expect(expr_parser).to parse("break some_name;")
        expect(expr_parser).to_not parse("break some_name")
      end

      it "accepts return statement" do
        expect(expr_parser).to parse("return some_name;")
        expect(expr_parser).to_not parse("return some_name")
      end

      it "accepts throws statement" do
        expect(expr_parser).to parse("throw some_name;")
        expect(expr_parser).to_not parse("throw some_name")
      end
    end
  end
end
