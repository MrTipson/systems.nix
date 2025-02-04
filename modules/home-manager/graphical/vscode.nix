{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      golang.go
      jnoortheen.nix-ide
      bradlc.vscode-tailwindcss
      ms-vscode.live-server
      llvm-vs-code-extensions.vscode-clangd
      # manually: https://open-vsx.org/extension/jeanp413/open-remote-ssh
    ];
    userSettings = {
      "remote.SSH.connectTimeout" = 120;
      "remote.SSH.useLocalServer" = false;
      "terminal.integrated.inheritEnv" = false;
    };
  };
}
