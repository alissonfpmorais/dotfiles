{ self, ... }:
(final: prev: {
  # Swap fcitx-engines to fcitx5 (error while upgrading from 22.11 to 23.05)
  fcitx-engines = self.pkgs.fcitx5;
})