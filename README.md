# Logfmt

Parse log lines on the logfmt style:

    >> require "logfmt"
    >> Logfmt.parse('foo=bar a=14 baz="hello kitty" cool%story=bro f %^asdf')
    => {"foo"=>"bar", "a"=>14, "baz"=>"hello kitty", "cool%story"=>"bro", "f"=>true, "%^asdf"=>true}
