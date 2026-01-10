# stealing stuff from https://github.com/iynaix/dotfiles/blob/main/modules/impermanence.nix again
{
  sources,
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.custom.persist;
  assertNoHomeDirs =
    paths:
    assert lib.assertMsg (!lib.any (lib.hasPrefix "/home") paths) "/home used in a root persist!";
    paths;
  mkPersistOption =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.listOf lib.types.str;
      default = [ ];
      apply = paths: assertNoHomeDirs (lib.unique paths);
    };
  normalUsers = lib.filterAttrs (_: lib.getAttr "isNormalUser") config.custom.users;
  persistUserDirs = directories: builtins.mapAttrs (user: _: { inherit directories; }) normalUsers;
in
{
  imports = [ "${sources.impermanence}/nixos.nix" ];

  options.custom = {
    persist = {
      directories = mkPersistOption "Directories to persist in root filesystem";
      files = mkPersistOption "Files to persist in root filesystem";
      cache = {
        directories = mkPersistOption "Directories to persist, but not to snapshot";
        files = mkPersistOption "Files to persist, but not to snapshot";
      };
    };
  };

  config = {
    boot.tmp.cleanOnBoot = true; # clear /tmp on boot, since it's a zfs dataset

    # root and home on tmpfs
    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        # whatever size feels comfortable, smaller is better
        # a good default is to start with 1G, having a small tmpfs acts as a tripwire hinting that there is something
	# you should probably persist, but haven't done so
        # you can always increase size with e.g. 'mount -o remount,size=1G /'
	"size=1G"
        #"size=256M"
        "mode=755"
      ];
    };

    security.sudo.extraConfig = "Defaults lecture=never"; # sudo acknowledgment flag gets deleted

    # setup persistence
    environment.persistence = {
      "/persist" = {
        files = lib.unique cfg.files;
        hideMounts = true; # don't show up in file manager
        directories = lib.unique (
          [
            "/var/log" # systemd journal is stored in /var/log/journal
            "/var/lib/nixos" # for persisting user uids and gids
          ]
          ++ cfg.directories
        );

        # user persisted dirs are not configured here
        # users should move any additional files into 'Extra'
        # and symlink them using something like hm
        users = persistUserDirs [
          "Desktop"
          "Documents"
          "Pictures"
          "Videos"
          "Extra"
        ];
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        inherit (cfg.cache) files;
        hideMounts = true; # don't show up in file manager
        directories = lib.unique ([
	  "/var/lib/systemd/coredump"
	  "/root/.cache/nix"
	] ++ cfg.cache.directories);

        # user persisted cache dirs are not configured here
        # users should move any additional files into 'Cache'
        # and symlink them using something like hm
        users = persistUserDirs [
          "Cache"
          "Repos"
        ];
      };
    };
  };

  # this creates a stub for users to prevent infinite recursion
  options.custom.users = options.users.users;
  config.users = {
    mutableUsers = false;
    users = builtins.mapAttrs (
      name: value:
      value
      // {
        initialPassword = "password";
        hashedPasswordFile = "/persist/etc/shadow/${name}";
      }
    ) (normalUsers // { root = config.custom.users.root or {}; });
  };
}
