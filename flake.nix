{
  description = "lt - TUI client for Linear.app issues";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        craneLib = (crane.mkLib pkgs);

        src = pkgs.lib.cleanSource ./.;

        commonArgs = {
          inherit src;
          # strictDeps disabled: graphql_client proc-macro needs file access at compile time
          strictDeps = false;
          buildInputs = with pkgs; [
            pkg-config
            openssl
          ];
        };

        lt = craneLib.buildPackage commonArgs;

      in
      {
        packages = {
          default = lt;
          lt = lt;
        };

        apps = {
          default = flake-utils.lib.mkApp { drv = lt; };
          lt = flake-utils.lib.mkApp { drv = lt; };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ lt ];
          buildInputs = with pkgs; [
            cargo
            rustc
            rust-analyzer
            rustfmt
            clippy
            pkg-config
            openssl
          ];

          shellHook = ''
            export RUST_BACKTRACE=1
            export RUST_LOG=debug
          '';
        };

        checks = {
          inherit lt;

          lt-clippy = craneLib.cargoClippy commonArgs;

          lt-fmt = craneLib.cargoFmt { inherit src; };

          lt-tests = craneLib.cargoNextest commonArgs;
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );
}
