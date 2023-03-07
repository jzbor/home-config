# My Home Configuration

## Rebuild, Switch and Update
Rebuild flake and switch to new config:
```sh
nix run . switch -- --flake .
```

Update flake inputs:
```sh
nix flake update
```

For convenience the two scripts `./update` and `./rebuild` are provided.
