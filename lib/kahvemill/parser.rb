# -*- coding: utf-8 -*-
require 'parslet'

class KahveMill::Parser < Parslet::Parser

  rule(:statement) do
    var_statement | expression_statement | disruptive_statement | try_statement | if_statement | while_statement |
      for_statement | number | string | name | keyword
  end

  rule(:for_statement) do
    str("for") >> open_bracket >> expression_statement >> semicolon >> expression_ >> semicolon >> expression_statement >> close_bracket  >> block
  end

  rule(:while_statement) do
    str("while") >> open_bracket >> expression_ >> close_bracket >> block
  end

  rule(:if_statement) do
    str("if") >> open_bracket >> expression_ >> close_bracket >> block >> (str("else") >> block).maybe
  end

  rule(:try_statement) do
    str("try") >> block >> str("catch") >> open_bracket >> name >> close_bracket
  end

  rule(:var_statement) do
    str("var") >> var_statement_2 >> var_statement_1.repeat >> semicolon
  end

  rule(:var_statement_1) do
    str(",") >> var_statement_2
  end

  rule(:var_statement_2) do
    space >> name.as(:key) >> space >> str("=") >> space? >> name.as(:value) >> space? |
      space >> name.as(:key) >> space >> str("=") >> space? >> literal.as(:value) >> space?
  end

  rule(:disruptive_statement) do
    str("break") >> space? >> name >> semicolon |
      str("return") >> space? >> statement >> semicolon |
      str("throw") >> space? >> statement >> semicolon
  end

  rule(:expression_) do
    literal | name >> (infix_operator >> (literal|name)).maybe |
      open_bracket >> expression_ >> close_bracket |
      prefix_operator >> expression_
  end

  rule(:prefix_operator) do
    space? >> (str("typeof") | str("+") | str("-") | str("!")) >> space?
  end

  rule(:expression_statement) do
    name >> space? >> str("=") >> space? >> expression_ |
      name >> space? >> str("+=") >> space? >> expression_
  end

  rule(:infix_operator) do
    space? >> (str("*") | str("/") | str("%") | str("+") | str("-") | str(">=") | str("<=") | str(">") | str("<") | str("===") | str("!==") | str("||") | str("&&")) >> space?
  end

  rule(:block) do
    space? >> str("{") >> space? >> statement.repeat(1) >> space? >> str("}") >> space?
  end

  rule(:literal) do
    number | string | boolean
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

  rule(:string) do
    (
     str("'")  >> characters.maybe.as(:string) >> str("'") |
     str("\"") >> characters.maybe.as(:string) >> str("\"")
     )
  end

  rule(:number) do
    (float | integer).as(:number)
  end

  rule(:float) do
      integer >> fraction |
      integer >> exponent |
      integer >> fraction >> exponent
  end

  rule(:integer) { digit >> digit.repeat | match('0') }
  rule(:fraction) { match('\.') >> digit.repeat }
  rule(:exponent) { match('[eE]') >> match('[-+]').maybe >> digit.repeat }

  rule(:boolean) do
    str("true") | str("false")
  end

  rule(:open_bracket) do
    space? >> str("(") >> space?
  end

  rule(:close_bracket) do
    space? >> str(")") >> space?
  end

  rule(:semicolon) do
    space? >> str(";") >> space?
  end

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

  rule(:semicolon) do
    space? >> str(";") >> space?
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
