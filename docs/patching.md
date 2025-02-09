# Patching

Runtime is built as an immutable set of patches on top of mozilla-central. For the most part, these patches are backed by the nix store, and built by the nix package manager. However, you can likely run the same scripts without the backing of nix.

## Patch sources

The source for patches is stored within `src/`. The following are applied recursivly.

1. If any folder exists in `src/` but not in centeral, symlink it
2. If a folder exists in centeral, but not in `src/`, symlink it
3. If a folder exists in both:
   1. Symlink any files in mozilla-centeral in
   2. Symlink any files in `src/` in, replacing centeral ones
   3. Apply patches to files with the same name
   4. Recurse into any folders
