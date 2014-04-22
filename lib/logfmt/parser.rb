module Logfmt
  GARBAGE = 0
  KEY = 1
  EQUAL = 2
  IVALUE = 3
  QVALUE = 4

  def self.parse(line)
    output = {}
    key, value = "", ""
    escaped = false
    state = GARBAGE
    i = 0
    line.each_char do |c|
      i += 1
      if state == GARBAGE
        if c > ' ' && c != '"' && c != '='
          key = c
          state = KEY
        end
        next
      end
      if state == KEY
        if c > ' ' && c != '"' && c != '='
          state = KEY
          key << c
        elsif c == '='
          output[key.strip()] = true
          state = EQUAL
        else
          output[key.strip()] = true
          state = GARBAGE
        end
        if i >= line.length
          output[key.strip()] = true
        end
        next
      end
      if state == EQUAL
        if c > ' ' && c != '"' && c != '='
          value = c
          state = IVALUE
        elsif c == '"'
          value = ""
          escaped = false
          state = QVALUE
        else
          state = GARBAGE
        end
        if i >= line.length
          output[key.strip()] = true
        end
        next
      end
      if state == IVALUE
        if not (c > ' ' && c != '"' && c != '=')
          output[key.strip()] = value
          state = GARBAGE
        else
          value << c
        end
        if i >= line.length
          output[key.strip()] = value
        end
        next
      end
      if state == QVALUE
        if c == '\\'
          escaped = true
          value << "\\"
        elsif c == '"'
          if escaped
            escaped = false
            value << c
            next
          end
          output[key.strip()] = value
          state = GARBAGE
        else
          escaped = false
          value << c
        end
        next
      end
    end
    output
  end
end
