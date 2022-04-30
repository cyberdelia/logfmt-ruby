# Logfmt

Parse log lines in the logfmt style:

```ruby
require "logfmt/parser"

Logfmt::Parser.parse('foo=bar a=14 baz="hello kitty" cool%story=bro f %^asdf')
  #=> {"foo"=>"bar", "a"=>14, "baz"=>"hello kitty", "cool%story"=>"bro", "f"=>true, "%^asdf"=>true}
```
