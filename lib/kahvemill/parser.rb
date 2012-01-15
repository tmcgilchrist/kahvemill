require 'parslet'

class KahveMill::Parser < Parslet::Parser
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

  root(:number)
end
