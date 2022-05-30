# lager_folsom

[![Hex pm](http://img.shields.io/hexpm/v/lager_folsom.svg?style=flat)](https://hex.pm/packages/lager_folsom)

## Configuration

Add `lager_folsom` to your `rebar.config` deps:

``` erlang
{deps,
 [
   {lager_folsom, "1.0.0"},
   ...
 ]}.
```

And finally, configure `lager` app with something like this:

``` erlang
[
 {lager,
  [
   {handlers,
    [
     {lager_folsom_backend,
      [
       {level, info}
      ]}
    ]}
  ]}
].
```
