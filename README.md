# axr

Arch Xehos Repository — a self-hosted pacman repository serving prebuilt
packages for my personal machines.

## Using the repository

Trust the signing key and install the keyring:

```sh
sudo pacman-key --recv-key 50348DB24B2AE82D6B46D9D555F27928838BC19E --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 50348DB24B2AE82D6B46D9D555F27928838BC19E
sudo pacman -U https://axr.frigon.app/axr-keyring.pkg.tar.zst
```

Add the repository to `/etc/pacman.conf`:

```ini
[axr]
Server = https://axr.frigon.app/$arch
```

## Repository layout

The `packages/` directory is the registry: one subdirectory per package,
each containing a PKGBUILD. Packaged software lives in its own repository
with tagged releases; this repository holds only packaging metadata and
CI. Pull requests build, lint, and install-test every package whose
directory they touch.
