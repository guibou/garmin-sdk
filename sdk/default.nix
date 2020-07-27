{runCommand, steamPackages, stdenv, fetchurl, unzip, makeWrapper,
autoPatchelfHook, zlib, expat, pango, libjpeg, libsoup, gtk2, libpng,
systemd, steam-run-native, lib, adoptopenjdk-bin, writeScript}:

let
  # The simulator needs a version of webkitgtk-1.0, which I only found in nixos-16.03.
  # This part is hence:
  # - non reproducible (because the channel can change)
  # - tied to this old channel
  old_webkit = (import (fetchTarball channel:nixos-16.03) {}).webkitgtk2;

  steam-runtime2 = runCommand "make-steam-runtime2" {}
  ''
  mkdir -p $out/lib
  cp -R ${steamPackages.steam-runtime}/usr/lib/x86_64-linux-gnu/* $out/lib
  cp -R ${steamPackages.steam-runtime}/lib/x86_64-linux-gnu/* $out/lib
  '';
in
rec {
  connect-iq = stdenv.mkDerivation {
    name = "connect-iq";

    src = fetchurl {
      url = "https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.1.9-2020-06-24-1cc9d3a70.zip";
      sha256 = "02e976511e069df4ded1ca1f1a0a7c57c0c35de04d8c5af319073df9f0aaf620";
    };

    nativeBuildInputs = [ unzip makeWrapper autoPatchelfHook ];
    buildInputs = [ zlib expat pango libjpeg libsoup gtk2 libpng steam-runtime2 old_webkit systemd ];

    runtimeDependencies = [ steam-runtime2 ];

    sourceRoot = ".";

    installPhase = ''
      mkdir $out
      mv * $out

      for i in $(find $out/bin -maxdepth 1 -executable -type f)
      do
        wrapProgram $i \
         --prefix PATH : ${lib.makeBinPath [adoptopenjdk-bin]}:$out/bin
         # --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [steam-runtime2]}:$out/bin
      done

      cat <<MULTILINE > $out/bin/connectiq_nix
      #!/usr/bin/env sh
      ${steam-run-native}/bin/steam-run $out/bin/connectiq "$@"
      MULTILINE

      chmod +x $out/bin/connectiq_nix

      rm $out/bin/monkeygraph.bat
    '';
  };

  garminProgram = path: developer_key: let
    prg = runCommand "build-program" {
       buildInputs = [connect-iq];

       passthru = {
         # Runs a simulator
         sim = writeScript "sim" ''
           #!/usr/bin/env sh
           ${connect-iq}/bin/connectiq_nix&
           ${connect-iq}/bin/monkeydo ${prg}/program.prg fr645
         '';
         };
       } ''
       mkdir $out
       monkeyc -y ${developer_key} -o $out/program.prg -f ${path}/*.jungle
  ''; in prg;
}

/*
Notes and TODOs

Stuff that can be improved.

- steam-runtime2 exists because I needed the library of steam-runtime
  in an $out/lib so autoPatchelfHook works.
- it may be possible to split the simulator from the rest of the
  toolchain. The simulator part is the only one which uses the webkit
  runtime. Doing this split will improve the quality by making a fully
  reproducible and lighter build toolchain (that's important)
- don't use `connectiq` to run the simulator, use `simulator_nix`.
*/
