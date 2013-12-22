module Logfmt
  module Generator; extend self
    QUOTE           = '"'
    GARBAGE_MATCH   = /[\s"=]/

    def generate(obj)
      obj = ensure_hash(obj)
      obj.map do |(k, v)|
        "#{encode_string k}=#{encode_string v}"
      end.join(' ')
    end

    protected

    def ensure_hash(obj)
      if obj.respond_to?(:to_hash)
        obj.to_hash
      else
        obj = {msg: obj}
      end
    end

    def encode_string(obj)
      case obj
      when Symbol
        str = obj.to_s
      else
        str = obj.inspect
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
