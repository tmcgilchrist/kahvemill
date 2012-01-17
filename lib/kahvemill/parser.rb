require 'parslet'

class KahveMill::Parser < Parslet::Parser

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

  rule(:space) do
    match('[\s]').repeat(1)
  end

  rule(:space?) do
    space.maybe
  end

  rule(:literal) do
    number | name
  end

  root(:literal)
end
