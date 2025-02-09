{
  description = "a gecko runtime";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        mozilla-centeral = import ./nix/mozilla-centeral.nix pkgs;
      in
      {
        packages = rec {
          mozilla-centeral-pkg = mozilla-centeral;
          patched = import ./nix/patched.nix {
            inherit pkgs;
            mozilla-centeral = mozilla-centeral-pkg;
            patcher = ./scripts/patch.js;
            source = ./src;
            system = system;
          };
          unwrapped = import ./nix/unwrapped.nix {
            inherit pkgs;
            patched = patched;
            system = system;
          };
          default = import ./nix/build.nix {
            inherit pkgs;
            unwrapped = unwrapped;
            sys = system;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
          ];

          shellHook = ''
            export MOZILLA_CENTERAL=${mozilla-centeral}
          '';
        };
      }
    );
}
