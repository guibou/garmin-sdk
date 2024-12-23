This is nix code in order to start / run / build garmin application using the sdk.

Everything here is a bit rusty. Have a look at `flake.nix` for examples of how
to build a few samples from the sdk as well as building a skydiving pool draw
application and a raytracer (because why not), but I think the raytracer is actually only showing a fractal.


# Build a garmin program

There is a macro `sdk.garminProgram ${path_to_your_project_directory} ${key}`.
See in `flake.nix` how to use it.

Then `nix build .#YourProgram`. You'll find the file which need to be copied to your device in `./result`.

You can also directly run the simulator on your program using `nix run .#YourProgram.simulator`.

# Key

You must set `developer_key.der` with your developer key. Be careful, it will
end in your nix store.

# Run the simulator

`nix develop` then `connectiq`.
