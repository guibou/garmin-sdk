let
  # nixpkgs-unstable of 25-06-2020
  sha256 = "0ir3rk776wldyjz6l6y5c5fs8lqk95gsik6w45wxgk6zdpsvhrn5";
  rev = "2cd2e7267e5b9a960c2997756cb30e86f0958a6b";
in
import (fetchTarball {
  inherit sha256;
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
})
