{
  pkgs,
  unwrapped,
  sys,
  ...
}:
derivation rec {
  name = "quark-runtime";
  system = sys;
  builder = "${pkgs.bash}/bin/bash";
  buildInputs = [ unwrapped.gtk3 ];
  args = [
    "-c"
    "${pkgs.coreutils}/bin/mkdir -p $out/bin && ${pkgs.coreutils}/bin/ln -s ${unwrapped}/bin/${name} $out/bin/${name}"
  ];
}
