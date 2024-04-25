{ pkgs, lib, config, inputs, ... }:

let
  pkgs-unstable =
    import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [ ];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
    iex --version
    psql --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    iex --version | grep "1.15"
    psql --version | grep "15.6"
  '';

  # https://devenv.sh/services/
  process-managers.process-compose.package = pkgs-unstable.process-compose;
  services.postgres = {
    enable = true;
    package = pkgs-unstable.postgresql_15;
    initialScript = ''
      CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;
    '';
  };

  # https://devenv.sh/languages/
  languages.elixir.enable = true;
  languages.elixir.package = pkgs-unstable.beam.packages.erlang_26.elixir_1_15;

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
