module Logfmt
  class ParseError < StandardError; end
  class HandParser
    SPACE                 = ' '
    EQUAL                 = "="
    BACKSLASH             = '\\'
    DOUBLE_QUOTE          = '"'

    GARBAGE_MATCH         = /\G[\s"=]+/
    IDENT_MATCH           = /\G[^\s"=]+/
    DOUBLE_QUOTE_MATCH    = /\G"((?:\\.|[^"])*)"/
    ESCAPE_MATCH          = /\\(.)/

    def self.parse(string)
      new.parse(string)
    end

    def parse(string)
      init(string)
      match GARBAGE_MATCH
      return message
    end

    protected

    # def # dbg(*x)                                                               
    #   p [@pos, @c, @string[0..@pos]] + x                                     
    # end 

    def init(string)
      @string = string
      @pos = 0
      @c = @string[0]
    end

    def accept(char)
      if @c == char
        @pos += 1
        @c = @string[@pos]
        return true
      end
      false
    end

    def match(reg)
      md = @string.match(reg, @pos)
      return unless md
      @pos += $&.size
      @c = @string[@pos]
      # dbg(:match, md)
      md
    end

    def message
      message = {}

      while true
        k = ident()
        break unless k
        message[k] = value()
        # dbg(message)
        match GARBAGE_MATCH
      end

      message
    end

    def ident
      md = match IDENT_MATCH
      # dbg(:ident, md)
      md && md[0]
    end

    def value
      return true unless accept(EQUAL)
      # dbg(:c, @c)
      if @c == DOUBLE_QUOTE && (md = match(DOUBLE_QUOTE_MATCH))
        # FIXME - Unescape doesn't work with escaped chars like \t or \n
        md[1].gsub(/\\(.)/, '\1')
      else
        ident || true
      end
    end
  end
end
