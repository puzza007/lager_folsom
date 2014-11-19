# lager_folsom

## Configuration

Add `lager_folsom` to your `rebar.config` deps:

``` erlang
{deps,
 [
  {lager_folsom, "",
   {git, "https://github.com/puzza007/lager_folsom.git",
    {tag, "0.1.0"}}}
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
