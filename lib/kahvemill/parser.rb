require 'parslet'

class KahveMill::Parser < Parslet::Parser
  rule(:number) do
    integer.as(:integer)
  end

  rule(:integer) { match('[1-9]') >> match('[0-9]').repeat | match('0') }
  root(:number)
end
