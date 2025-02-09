{
  pkgs,
  patched,
  system,
  ...
}:
(pkgs.buildMozillaMach rec {
  pname = "quark-runtime";
  binaryName = pname;
  applicationName = "Runtime";
  version = "135.0";

  application = pname;

  # We unpack the source files
  src = derivation {
    name = "unpacked-patches";
    system = system;
    builder = "${pkgs.bash}/bin/bash";
    args = [
      "-c"
      "${pkgs.coreutils}/bin/mkdir -p $out && ${pkgs.coreutils}/bin/cp -rL ${patched}/* ${patched}/.* $out"
    ];
  };

  extraConfigureFlags = [
    "--with-app-name=${pname}"
    "--with-app-basename=${applicationName}"
  ];

  meta = { };
}).override
  {
    enableOfficialBranding = false;
    pgoSupport = false;
    crashreporterSupport = false;
    ltoSupport = false;
  }
