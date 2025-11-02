{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.multiseat-nix.packages.${pkgs.system})
    cage
    drm-lease-manager
    ;
in
{
  environment.etc.seat = {
    target = "udev/rules.d/72-multiseat.rules";
    # ls /sys/class/drm/
    # udevadm info -a -p (udevadm info -q path -n /dev/input/by-id/<your-device>)
    text = ''
      TAG+="seat", TAG+="master-of-seat", SUBSYSTEM=="drm", KERNEL=="card1-DP-2", ENV{ID_SEAT}="seat1"
      TAG+="seat", SUBSYSTEM=="usb", ATTRS{manufacturer}=="8BitDo", ENV{ID_SEAT}="seat1"
    '';
  };

  users.users.steamsitter = {
    isNormalUser = true;
    extraGroups = [ "pipewire" ];
    shell = "${pkgs.shadow}/bin/nologin";
  };

  services.pipewire.systemWide = true;
  systemd.services."cage" = {
    enable = true;
    restartIfChanged = false;
    serviceConfig = {
      ExecStart = ''${cage}/bin/cage -- capsh --caps="" -- -c "steam -bigpicture"'';
      User = "steamsitter";
      StandardOutput = "journal";
      StandardError = "journal";
      # Set up a full (custom) user session for the user, required by Cage.
      PAMName = "cage";
    };
    environment = {
      XDG_VTNR = "1";
      XDG_SEAT = "seat1";
      DRM_LEASE = "card1-DP-2";
      WLR_DRM_DEVICES = "/dev/dri/card1";
      #WLR_LIBINPUT_NO_DEVICES = "1";
      XCURSOR_THEME = "";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  security.polkit.enable = true;

  security.pam.services.cage.text = ''
    auth    required pam_unix.so nullok
    account required pam_unix.so
    session required pam_unix.so
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required ${config.systemd.package}/lib/security/pam_systemd.so
  '';

  # DLM_RUNTIME_PATH env ?
  systemd.services."multiseat-dlm" = {
    enable = true;
    after = [ "systemd-user-sessions.service" ];
    wantedBy = [ "multi-user.target" ];
    description = "DRM Lease Manager";
    serviceConfig = {
      Type = "exec";
      Group = "users";
      UMask = "002";
      ExecStartPre = "${pkgs.coreutils}/bin/install -dm755 /run/drm-lease-manager";
      ExecStart = "${drm-lease-manager}/bin/drm-lease-manager -v /dev/dri/card1";
    };
  };
}
