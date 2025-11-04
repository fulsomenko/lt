{ pkgs ? import <nixpkgs> { } }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "lt";
  version = "0.0.10";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = with pkgs; [
    pkg-config
    openssl
  ];

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  postInstall = ''
    mkdir -p $out/share/doc/lt
  '';

  meta = with pkgs.lib; {
    description = "An unofficial TUI client for Linear.app issues";
    homepage = "https://github.com/markmarkoh/lt";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
