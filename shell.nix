with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "hello-gleam";

  buildInputs = [
    gleam
    erlang
    rebar3
  ];
}
