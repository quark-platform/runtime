{
  pkgs,
  lib,
  unwrapped,
  sys,
  stdenv,
  ...
}:
let
  libs = with pkgs; [
    # linuix host
    udev
    libva
    mesa
    libnotify
    xorg.libXScrnSaver
    cups
    pciutils
    vulkan-loader

    # Xorg
    xorg.libX11
    xorg.libXxf86dga
    xorg.libXxf86vm
    xorg.libXext
    xorg.libXt
    alsa-lib
    zlib

    # GL
    libGL
  ];
  name = "quark-runtime";

  link-modules = ''
    # When run in the root of your quark-runtime application, it will link 
    # all of the omni modules into your modules/ directory.
    #
    # This script (should) skip existing files

    set -euo pipefail
    IFS=$'\n\t'

    target=$(pwd)/modules
    mkdir -p $target

    (
      cd $quark/lib/omni/modules
      find -type d -exec mkdir -p $target/{} \; 
      find -type f -exec ln -s $(pwd)/{} $target/{} \; 
      echo $target
    )
  '';
in
stdenv.mkDerivation {
  name = name;
  system = sys;
  builder = "${pkgs.bash}/bin/bash";
  buildInputs = [ unwrapped.gtk3 ];
  lib = lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;
  outputs = [
    "out"
  ];
  args = [
    "-c"
    ''
      set -euo pipefail
      IFS=$'\n\t'

      ${pkgs.coreutils}/bin/mkdir -p $out/bin
      ${pkgs.coreutils}/bin/mkdir -p $out/lib/omni

      # Add the binary
      ${pkgs.coreutils}/bin/ln -s ${unwrapped}/bin/${name} $out/bin/${name}

      # Add development helpers 
      ${pkgs.coreutils}/bin/cat >> link-modules << 'END'
      ${link-modules}
      END
      echo -e "#! /usr/bin/env nix-shell\n#! nix-shell -i bash -p bash coreutils findutils\nquark='$out'" | ${pkgs.coreutils}/bin/cat - link-modules > $out/bin/link-modules
      ${pkgs.coreutils}/bin/chmod a+x $out/bin/link-modules

      # Extract omni into lib
      (
        cd $out/lib/omni
        ${pkgs.coreutils}/bin/cp ${unwrapped}/lib/quark-runtime/omni.ja .
        ${pkgs.unzip}/bin/unzip ./omni.ja
      )
    ''
  ];
}
