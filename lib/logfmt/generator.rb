module Logfmt
  module Generator; extend self
    QUOTE           = '"'
    CUT             = '...'
    GARBAGE_MATCH   = /[\s"=]/
    SEPARATOR       = ' '

    # Must never raise an exception
    #
    # Options:
    # * limit: maximum size of the string, defaults to nil
    def generate(obj, opts={})
      limit = opts[:limit] || opts['limit']

      obj = ensure_hash(obj)
      
      # FIXME: avoid converting k,v if they are going to be discarded
      #        by using the Enumerable#lazy introduced in ruby 2.0.0
      res = obj.map do |(k, v)|
        "#{encode_string k}=#{encode_string v}"
      end

      if limit
        limit = CUT.size if limit < CUT.size
        size = 0
        res.each_with_index do |str, i|
          size += SEPARATOR.size if i > 0
          size += str.size
          if size > limit
            res = res[0..i]
            res[-1] = CUT
            break
          end
        end
      end

      res.join(SEPARATOR)
    end

    protected

    def ensure_hash(obj)
      if (obj.respond_to?(:to_hash) rescue false)
        obj.to_hash
      elsif (obj.respond_to?(:to_h) rescue false)
        obj.to_h
      else
        obj = {msg: obj}
      end
    end

    def encode_string(obj)
      case obj
      when Symbol
        str = obj.to_s
      else
        str = (obj.inspect rescue '...')
      end
      quoted = false
      s2 = str
      if str[0] == QUOTE && str[-1] == QUOTE
        quoted = true
        s2 = str[1..-2]
      end
      if s2.size == 0 || s2.index(GARBAGE_MATCH)
        if quoted
          s2 = str
        else
          s2 = str.inspect
        end
      end
      s2
    end
  end

  def self.generate(obj)
    Generator.generate(obj)
  end
end
