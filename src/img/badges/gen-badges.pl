#!/usr/bin/env perl

use warnings;
use strict;

my %icons = (
    python => {
      icon  => "",
      color => "#3776ab",
    },
    nix => {
      icon  => "󱄅",
      color => "#5277c3",
    },
    nixos => {
      icon  => "󱄅",
      color => "#7ebae4",
    },
    tmux => {
      icon  => "",
      color => "#1bb91f",
    },
    neovim => {
      icon  => "",
      color => "#57a143",
    },
    qemu => {
      icon  => "",
      color => "#ff6600",
    },
    kvm => {
      icon  => "󰍹",
      color => "#cc0000",
    },
    terraform => {
      icon  => "",
      color => "#7b42bc",
    },
    helm => {
      icon  => "󱃾",
      color => "#0f1689",
    },
    prometheus => {
      icon  => "󰋩",
      color => "#e6522c",
    },
    mysql => {
      icon  => "",
      color => "#00758f",
    },
    postgresql => {
      icon  => "",
      color => "#336791",
    },
    redis => {
      icon  => "",
      color => "#d82c20",
    },
    nginx => {
      icon  => "",
      color => "#009639",
    },
    apache => {
      icon  => "",
      color => "#d22128",
    },
    github => {
      icon  => "",
      color => "#f8f8f8",
    },
    gitlab => {
      icon  => "",
      color => "#fc6d26",
    },
    aws => {
      icon  => "",
      color => "#ff9900",
    },
    gcp => {
      icon  => "󰊭",
      color => "#4285f4",
    },
    nodejs => {
      icon  => "",
      color => "#3c873a",
    },
    ruby => {
      icon  => "",
      color => "#cc342d",
    },
    c => {
      icon  => "",
      color => "#00599c",
    },
    cpp => {
      icon  => "",
      color => "#004482",
    },
    zsh => {
      icon  => "",
      color => "#f15a24",
    },
    fish => {
      icon  => "󰈺",
      color => "#4aa3c1",
    },
    ubuntu => {
      icon  => "",
      color => "#e95420",
    },
    arch => {
      icon  => "",
      color => "#1793d1",
    },
    mint => {
      icon  => "",
      color => "#87cf3e",
    },
    void => {
      icon  => "",
      color => "#478061",
    },
    bash => {
      icon => "",
      color => '#fbfbfb',
    },
    freebsd => {
      icon => "",
      color => "#f8f8f8",
    },
    ansible => {
      icon => "",
      color => "#f8f8f8",
    },
    linux => {
      icon => "",
      color => "#f8f8f8",
    },
    docker => {
      icon => "",
      color => '#1662ed',
    },
    elixir => {
      icon => "",
      color => '#8d71a1',
    },
    git => {
      icon => "",
      color => '#fe7600',
    },
    golang => {
      icon => "󰟓",
      color => '#00acd7',
    },
    grafana => {
      icon => "",
      color => '#f7ac21',
    },
    k8s => {
      icon => "",
      color => '#2d6be5',
    },
    lua => {
      icon => "",
      color => '#000080',
    },
    makefile => {
      icon => "",
      color => '#fbfbfb',
    },
    perl => {
      icon => "",
      color => '#4c5c85',
    },
    vim => {
      icon => "",
      color => '#00982f',
    },
);

my %size = (
  pix => 100,
  txt => 120,
);

foreach my $key (keys %icons) {
  my $name = $key;
  my $output = "badge-$name.png";
  my $icon = $icons{$key}->{icon};
  my $color = $icons{$key}->{color};
  $color = "#f8f8f8",

  my @cmd_string = (

    # "imagemagick", "string",
    # "--text", "$icon",
    # "--height", $size{pix},
    # "--size", $size{txt},

    "imagemagick-string",
    "--input", "$icon",
    "--length", $size{pix},
    "--point", $size{txt},

    "--width", $size{pix},
    "--font", "FiraCode-Nerd-Font-Mono-Reg",
    "--background", "none",
    "--foreground", "$color",
    "--output", $output,
  );

  my @cmd_shadow = (
    "imagemagick", "shadow",
    "--input", $output,
    "--output", $output,
  );

  my @cmd_extend = (
    "convert", $output,
    "-resize", "",
    "-extend", "",
    $output,
  );

  my @cmd_trim = (
    "imagemagick", "trim",
    "--input", $output,
    "--output", $output,
  );

  system @cmd_string;
  system @cmd_trim;
  system @cmd_shadow;
}

