I got an error while reordering my "optimizations" directory, and basically I was trying to have the
top-level flake.nix file import system options, and then system options would import steam and the optimizations
directory. The optimizations directory imported other system configurations, but it gave me an error.

"value is a function while a set was expected"

Distilled, I accidentally added a function instead of a set.
Function looks like this: `{...}:`, and set looks like this: `{}`.
Inside the "system" directory, optimizations/default.nix was a function instead of a set. This was wrong.
Why?

You can basically forward files to the top-level to be evaluated (Like actually imported into config).

An example:
```nix
# Filename: flake.nix
# Other stuff here

# Evaluates packages via import.
# That basically means it adds whatever code was in there into this file to be compiled
VariableNameHere = import ./modules/system; 
```



```nix
# Filename: modules/system/default.nix

# No function here!
{
  # Note that we don't "import" it. We only specify a path to a variable,
  # as the top-level flake.nix will evaluate it.
  nvidiaDriverPath = ./nvidia; 
}
```

```nix
# Filename: modules/system/nvidia/default.nix
# We do want a function here because the function gives us variables (lib, config, whatever)
# so that we can mess around with it
{...}:{
  # ... Pretend code here

  # Note that we DO use an import statement, as the import statement basically adds that
  # file's code to ours.
  otherNvidiaFile = import ./option.nix; 
}
```

## Why does this matter?

I thought I should jot it down before I forget.
