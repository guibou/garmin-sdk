let pkgs = import ./nixpkgs.nix {};
in
with pkgs;
rec {
  inherit pkgs;

  sdk = callPackage ./sdk {};

  samples = {
    ProgressBar = sdk.garminProgram "${sdk.connect-iq}/samples/ProgressBar" "${key}";
    Sensor = sdk.garminProgram "${sdk.connect-iq}/samples/Sensor" "${key}";
    Drawable = sdk.garminProgram "${sdk.connect-iq}/samples/Drawable" "${key}";
    Picker = sdk.garminProgram "${sdk.connect-iq}/samples/Picker" "${key}";
    Timer = sdk.garminProgram "${sdk.connect-iq}/samples/Timer" "${key}";
  };

  RayTrace = sdk.garminProgram ./RayTrace key;
  SkydivePool = sdk.garminProgram ./SkydivePool key;

  # becareful, your private key may ends in the nix store
  key = ./developer_key.der;
}
