{ lib, pkgs, ... }:
{
  home.stateVersion = "22.11";
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding="<Super>t";
      command="kgx";
      name="Open Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding="<Super>e";
      command="emacsclient -c -a 'emacs'";
      name="Open emacs client";
    };
  };
  programs = {
    # emacs = {
    #   enable = true;
    # };
    git = {
      enable = true;
      aliases = {
        apply-gitignore = "!git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached";
        lg1 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n'' %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        lg = "lg1";
      };
      extraConfig = {
        core = {
          autocrlf = "input";
        };
        init.defaultBranch = "main";
        safe.directory = "/etc/nixos";
      };
      userEmail = "alissonfpmorais@gmail.com";
      userName = "Alisson Morais";
    };
  };
  # services = {
  #   emacs = {
  #     client.arguments = [
  #       "-c"
  #       "-a 'emacs'"
  #     ];
  #     client.enable = true;
  #     enable = true;
  #     socketActivation.enable = true;
  #   };
  # };
}