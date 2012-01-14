require 'parslet'

class KahveMill::Parser < Parslet::Parser
  rule(:number) do
    integer.as(:integer) | fraction.as(:fraction) | exponent.as(:exponent)
  end

  rule(:integer) { match('[1-9]') >> match('[0-9]').repeat | match('0') }
  rule(:fraction) { match('\.') >> match('[0-9]').repeat }
  rule(:exponent) { match('[eE]') >> match('[-+]').maybe >> match('[0-9]').repeat }
  root(:number)
end
