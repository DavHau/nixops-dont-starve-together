## NixOps deployment for a dedicated Don't Starve Together server
based on https://github.com/mathielo/dst-dedicated-server

### Setup
1. Check readme on [dst-dedicated-server](https://github.com/mathielo/dst-dedicated-server) to see how to get your cluster token and put it under `keys/cluster-token.txt`
1. Modify files in `config` to configure server settings and mods
1. Use shell.nix to make nixops reproducible
