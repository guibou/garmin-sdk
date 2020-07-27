with import ./nixpkgs.nix {};
rec {
  sdk = callPackage ./sdk {};

  samples = {
    ProgressBar = sdk.garminProgram "${sdk.connect-iq}/samples/ProgressBar" "${key}";
    Sensor = sdk.garminProgram "${sdk.connect-iq}/samples/Sensor" "${key}";
  };

  # becareful, your private key may ends in the nix store
  key = ./developer_key.der;
}
