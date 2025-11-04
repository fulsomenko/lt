{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
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
}
