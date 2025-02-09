{
  pkgs,
  patcher,
  mozilla-centeral,
  source,
  system,
  ...
}:
derivation {
  name = "patched";
  system = system;
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    "${pkgs.coreutils}/bin/mkdir -p $out && cd $out && MOZILLA_CENTERAL=${mozilla-centeral} SOURCE=${source} PATCH_CMD=${pkgs.patch}/bin/patch ${pkgs.nodejs}/bin/node ${patcher}"
  ];
}
