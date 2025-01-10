{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    functions = {
      print-time = {
        body = ''printf "Took %.3fs\n" (math $CMD_DURATION/1000)'';
        onEvent = "fish_postexec";
      };
    };
    plugins = [
      {
        name = "clearance";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-clearance";
          rev = "10683bae6e8481b1ca4196b2079881ab1862fa97";
          sha256 = "sha256-r8/wT8PgJcE05UcxJR8ZRf9xBnDajmwKDOiD12TRWyk=";
        };
      }
    ];
    interactiveShellInit = "set -U fish_greeting\n";
    # Workaround:
    shellInit = "source ~/.config/fish/functions/print-time.fish\n";
  };
}
