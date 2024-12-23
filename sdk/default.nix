{runCommand, steamPackages, stdenv, fetchurl, unzip, makeWrapper,
autoPatchelfHook, zlib, expat, pango, libjpeg, libsoup_2_4, gtk2, libpng,
systemd, steam-run-native, lib, temurin-bin, writeScript, webkitgtk2, libpng12, libjpeg8, libusb1, writeScriptBin}:
rec {
  connectiq = stdenv.mkDerivation {
    name = "connectiq";

    src = fetchurl {
      url = "https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-3.1.9-2020-06-24-1cc9d3a70.zip";
      sha256 = "02e976511e069df4ded1ca1f1a0a7c57c0c35de04d8c5af319073df9f0aaf620";
    };

    nativeBuildInputs = [ unzip makeWrapper autoPatchelfHook ];
    buildInputs = [ zlib expat pango libjpeg libsoup_2_4 gtk2 libpng libpng12 libjpeg8 webkitgtk2 systemd libusb1 ];

    runtimeDependencies = [ ];

    sourceRoot = ".";

    installPhase = ''
      mkdir $out
      mv * $out

      for i in $(find $out/bin -maxdepth 1 -executable -type f)
      do
        wrapProgram $i \
         --prefix PATH : ${lib.makeBinPath [temurin-bin]}:$out/bin
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
       buildInputs = [connectiq];

       passthru = {
         # Runs a simulator
         simulator = writeScriptBin "simulator" ''
           #!/usr/bin/env sh
           ${connectiq}/bin/connectiq_nix&
           ${connectiq}/bin/monkeydo ${prg}/program.prg fr645
         '';
         };
       } ''
       mkdir $out
       monkeyc --warn -y ${developer_key} -o $out/program.prg -f ${path}/*.jungle
  ''; in prg;
}
