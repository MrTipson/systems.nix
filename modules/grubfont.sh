#!/bin/env sh
# Helper script to try out fonts in the grubvm
# Expects the mounted nixconfig directory and its copy nixos
grub-mkfont -d 6 -c 18 -o nixos/modules/grub-theme/font.pf2 -v "nixconfig/modules/grub-theme/$1"
nixos-rebuild switch --flake ./nixos || reboot
