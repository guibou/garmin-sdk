with (import ./.);
pkgs.mkShell { buildInputs = [sdk.connect-iq]; }
