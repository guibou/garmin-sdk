{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    # The simulator needs a version of webkitgtk-1.0, which I only found in nixos-16.03.
    old_nixpkgs = {
      url = "github:NixOS/nixpkgs/release-16.03";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, old_nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

      # Be careful, your private key WILL ends in the nix store
      key = ./developer_key.der;
    in
    with pkgs;
    {
      legacyPackages.x86_64-linux = rec {

        sdk = callPackage ./sdk {
          webkitgtk2 = (import "${old_nixpkgs}" { system = "x86_64-linux"; config.allowUnfree = true; }).webkitgtk2;
        };

        samples = {
          ProgressBar = sdk.garminProgram "${sdk.connectiq}/samples/ProgressBar" "${key}";
          Sensor = sdk.garminProgram "${sdk.connectiq}/samples/Sensor" "${key}";
          Drawable = sdk.garminProgram "${sdk.connectiq}/samples/Drawable" "${key}";
          Picker = sdk.garminProgram "${sdk.connectiq}/samples/Picker" "${key}";
          Timer = sdk.garminProgram "${sdk.connectiq}/samples/Timer" "${key}";
        };

        mine = {
          RayTrace = sdk.garminProgram ./RayTrace key;
          SkydivePool = sdk.garminProgram ./SkydivePool key;
        };
      };

      packages.x86_64-linux = with self.legacyPackages.x86_64-linux;
      {
        connectiq = sdk.connectiq;
        default = sdk.connectiq;
      } // samples // mine;

      checks.x86_64-linux = self.packages.x86_64-linux;

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [self.legacyPackages.x86_64-linux.sdk.connectiq];
      };
    };
}
