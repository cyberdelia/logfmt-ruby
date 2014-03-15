module Logfmt
  class RegexpParser
    GARBAGE       = /[\s"=]+/
    IDENT         = /[^\s"=]+/
    QUOTED_STRING = /(?:\\.|[^"])*/
    ESCAPE_CHARS  = {
      '\a'    => "\a",
      '\b'    => "\b",
      '\e'    => "\e",
      '\f'    => "\f",
      '\n'    => "\n",
      '\r'    => "\r",
      '\s'    => "\s",
      '\t'    => "\t",
      '\v'    => "\v",
      '\"'    => '"',
      '\\\\'  => '\\',
    }
    RE            = /
      \G
      (?:
        (#{IDENT})
        (?:
          =
          (?:(#{IDENT})|"(#{QUOTED_STRING})")
        )?
        |
        #{GARBAGE}
      )
    /x # x - free-spacing mode, n - ASCII-8BIT
    def self.parse(string)
      obj = {}
      string.scan(RE) do |key, ident, str|
        next unless key
        if str
          value = unquote(str)
        else
          value = ident || true
        end
        obj[key] = value
      end
      obj
    end

    def self.unquote(string)
      string.gsub(/\\./, ESCAPE_CHARS)
    end
  end
end
