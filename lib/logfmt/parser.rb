require "parslet"

module Logfmt
  class Parser < Parslet::Parser
    rule(:ident_byte) { match("[^ \t\r\n\f\"=]") }
    rule(:string_byte) { match("[^\"\\\\]") }
    rule(:garbage) { match("[ \t\r\n\f\"=]").repeat }
    rule(:ident) { ident_byte >> ident_byte.repeat }
    rule(:key) { ident }
    rule(:value) {
      (ident.as(:value) | (str('"') >> (string_byte | str('\\') >> str('"')).repeat.as(:value) >> str('"')))
    }
    rule(:pair) {
      (key.as(:key) >> str('=') >> value) |
      (key.as(:key) >> str('=')) | key.as(:key)
    }
    rule(:message) { (garbage >> pair.as(:pair)).repeat.as(:message) >> garbage }
    root(:message)
  end

  class Transformer < Parslet::Transform
    class Pair < Struct.new(:key, :val); end

    rule(:message => subtree(:ob)) {
      (ob.is_a?(Array) ? ob : [ ob ]).inject({}) { |h, p| h[p.key] = p.val; h }
    }
    rule(:pair => { :key => simple(:key), :value => simple(:val) }) {
      Pair.new(key.to_sym, val.to_s)
    }
    rule(:pair => { :key => simple(:key), :value => sequence(:val) }) {
      Pair.new(key.to_sym, "")
    }
    rule(:pair => { :key => simple(:key) }) {
      Pair.new(key.to_sym, true)
    }
  end

  def self.parse(logs)
    parser = Parser.new
    transformer = Transformer.new

    tree = parser.parse(logs)
    transformer.apply(tree)
  end
end