{ ... }:
let
  version = "135.0";
in
fetchTarball {
  url = "https://archive.mozilla.org/pub/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
  sha256 = "16ik90im6dqa7pfyx75ryfc403fl45djja8z6si3rxvr9dx3498w";
}
