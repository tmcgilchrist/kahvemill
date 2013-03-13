# -*- coding: utf-8 -*-
require 'parslet'

class KahveMill::Parser < Parslet::Parser

  rule(:string) do
    (
     str("'")  >> characters.maybe >> str("'") |
     str("\"") >> characters.maybe >> str("\"")
     ).as(:string)
  end

  rule(:statement) do
    var_statement |
      number | string | name | keyword
  end

  rule(:var_statement) do
      str("var").as(:keyword) >> var_statement_2.as(:var_statement) >> var_statement_1.repeat >> str(";")
  end

  rule(:var_statement_1) do
    str(",") >> var_statement_2.as(:var_statement)
  end

  rule(:var_statement_2) do
    space >> name >> space >> str("=").as(:assign) >> space? >> expression >> space?
  end

  rule(:expression) do
    name | literal
  end

  rule(:literal) do
    number
  end

  rule(:name) do
    (keyword.as(:keyword) >> match['A-Za-z0-9_$'].absnt?) |
      (match('[A-Za-z]') >> match('[A-Za-z0-9_]').repeat).as(:name)
  end

  RESERVED_WORDS = ["break", "case", "catch", "const", "continue", "default", "delete",
                    "do", "else", "false", "finally", "for", "function", "if",
                    "instanceof", "in", "new", "null", "return", "switch", "this",
                    "throw", "true", "try", "typeof", "var", "void", "while", "with"]

  rule(:keyword) do
     RESERVED_WORDS.map {|w| str(w)  }.inject {|l,r| l  | r }
  end

  rule(:number) do
     float.as(:float) | integer.as(:integer)
  end

  rule(:float) do
      integer >> fraction |
      integer >> exponent |
      integer >> fraction >> exponent
  end

  rule(:integer) { digit >> digit.repeat | match('0') }
  rule(:fraction) { match('\.') >> digit.repeat }
  rule(:exponent) { match('[eE]') >> match('[-+]').maybe >> digit.repeat }

  rule(:digit) do
    match('[0-9]')
  end

  rule(:characters) do
    (match(/\p{Word}/) | escaped_char).repeat
  end

  rule(:escaped_char) do
    match(/[\n\b\f\r\t]/) |
    match(/\\u[0-9a-fA-F]{4}/)
  end

  rule(:space) do
    match('[\s]').repeat(1)
  end

  rule(:space?) do
    space.maybe
  end

  rule(:expression) do
    statement
  end

  root(:expression)
end
