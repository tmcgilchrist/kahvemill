require 'parslet'

class KahveMill::Parser < Parslet::Parser
  rule(:number) do
    integer.as(:integer) | fraction.as(:fraction) | exponent.as(:exponent)
  end

  rule(:integer) { digit >> digit.repeat | match('0') }
  rule(:fraction) { match('\.') >> digit.repeat }
  rule(:exponent) { match('[eE]') >> match('[-+]').maybe >> digit.repeat }

  rule(:digit) do
    match('[0-9]')
  end

  root(:number)
end
