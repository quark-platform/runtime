# Building

In the past building has been a bit of a pain. Nix nicely abstracts all of that away, with a couple of quirks.

Nix applies its own set of patches on top. This means you need the symlinks, at the very least of the patched files, but realistic just for all files. You can do this with `cp -rL`, which is slow but works.
