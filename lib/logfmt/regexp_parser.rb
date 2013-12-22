module Logfmt
  class RegexpParser
    GARBAGE       = /[\s"=]+/
    IDENT         = /[^\s"=]+/
    QUOTED_STRING = /(?:\\.|[^"])*/

    RE = /
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
          # FIXME - Unescape doesn't work with escaped chars like \t or \n
          value = str.gsub(/\\(.)/, '\1')
        else
          value = ident || true
        end
        obj[key] = value
      end
      obj
    end
  end
end
