{ ... }:
let
  version = "134.0.2";
in
fetchTarball {
  url = "https://archive.mozilla.org/pub/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
  sha256 = "08n22w1vipb4g9nampvd91xnj149w921p6iwdh61znckafln6m6y";
}
