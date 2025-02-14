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
    vulcan-loader

    # Xorg
    libX11
    libXxf86dga
    libXxf86vm
    libXext
    libXt
    alsa-lib
    zlib

    # GL
    libGL
  ];
  name = "quark-runtime";
in
stdenv.mkDerivation {
  name = name;
  system = sys;
  builder = "${pkgs.bash}/bin/bash";
  buildInputs = [ unwrapped.gtk3 ];
  lib = lib.makeLibararyPath libs + ":" + lib.mkSearchPathOutput "lib" "lib64" libs;
  args = [
    "-c"
    "${pkgs.coreutils}/bin/mkdir -p $out/bin && ${pkgs.coreutils}/bin/ln -s ${unwrapped}/bin/${name} $out/bin/${name}"
  ];
}
