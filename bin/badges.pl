#!/usr/bin/env perl

use warnings;
use strict;
use File::Basename;
use POSIX qw(strftime);
use Term::ANSIColor;
use File::Path qw(remove_tree);
use File::Path qw(make_path);
use Getopt::Long;
$| = 1;  # autoflush

my $partials = "";
my $images   = "";
my $debug;

GetOptions(
    "partials=s"  => \$partials,
    "images=s"    => \$images,
    "debug"       => \$debug,
) or die "Invalid flags. Use -h for help\n";

# icon list {{{
my %icons = (
    nix => {
      icon  => "󱄅",
      color => "#5277c3",
    },
    tmux => {
      icon  => "",
      color => "#1bb91f",
    },
    neovim => {
      icon  => "",
      color => "#57a143",
    },
    terraform => {
      icon  => "",
      color => "#7b42bc",
    },
    prometheus => {
      icon  => "",
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
      icon  => "",
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
    ubuntu => {
      icon  => "",
      color => "#e95420",
    },
    arch => {
      icon  => "",
      color => "#1793d1",
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
    python => {
      icon  => "",
      color => "#3776ab",
    },
    rhel => {
      icon  => "󱄛",
      color => "#cc0000",
    },
    debian => {
      icon  => "",
      color => "#a80030",
    },
    suse => {
      icon  => "",
      color => "#73ba25",
    },

);
# }}}

my $cmd = shift;

my $ui_root = '{{{uiRootPath}}}';
my $ui_img  = "img/badges";
my $img_dir = "$ui_root/$ui_img";
my $width   = 30;
my $height  = 96;
my $size    = 90;
my $font    = "FiraCode-Nerd-Font-Mono-Reg";
my $prompt  = basename($0);

# helpers {{{

# usage {{{
sub print_usage {

my $main = <<"EOF";
Create badges

usage: $prompt COMMAND OPTIONS

   • COMMAND
       generate     generate badges
       print        print html <img> tag

   • OPTION
       --partials   src/partial direcotry path
       --images     src/img direcotry path
EOF
}
# }}}

# clean {{{
sub clean {
    print "\r\n";
}
# }}}

# exit code {{{
sub check_exit_code {
    my ($package, $filename, $line) = caller();
    my $exit_code = $_[0];
    my $fail = 'fail';  # ×
    my $done = "done";  # ✓
    my $side = "fg";
    $fail = "$fail" if $side eq "fg";
    $done = "$done" if $side eq "fg";
    $fail = " $fail " if $side eq "bg";
    $done = " $done " if $side eq "bg";
    my %color = (
        bg => {
            fail => "on_red",
            done => "on_green",
        },
        fg => {
            fail => "bold red",
            done => "bold green",
        },
    );
    my $msg = "";
    if ($exit_code) {
        $msg = color($color{$side}{fail}).$fail.color("reset");
        print("\n");
        exit $line;
    } else {
        $msg = color($color{$side}{done}).$done.color("reset");
    }
    return $msg;
}
# }}}

# command {{{
sub command {
    my $program = $_[0];
    my $path = $ENV{"PATH"};
    my @directories = split(":", $path);
    my $found = '';
    foreach my $dir (@directories) {
        my $full_path = "$dir/$program";
        if (-x $full_path) {
            $found = $full_path;
            last;
        }
    }
    return $found;
}

my $runner;
my $composite;
my $highlighter;
my $import;
my $identify;
my $found_im = command("convert");
my $found_mk = command("magick");

if ($found_mk) {
    $runner = $found_mk;
} elsif ($found_im) {
    $runner = $found_im;
} else {
    print(STDERR "ImageMagick is not installed\n");
    exit 1;
}
# }}}

# logger {{{
sub logger {
    return 0 unless $debug;

    my ($name, $msg, $level) = @_;
    $name =~ s,^im,,;
    $level //= 1;
    my ($package, $filename, $line) = caller();


    my $message = "] ${package}::${name}   >>> ${line} | $msg";

    return if $level == 0;
    print($message) if $level == 1;
    print(STDERR "\r") if $level != 1;
    print(STDERR $message) if $level != 1;
    print(STDERR "\n") if $level gt 3;
    exit $line if $level ge 3;
}
# }}}

# prettry {{{
sub pretty {
    my ($name, $msg, $level) = @_;
    $name =~ s,^im,,;
    $level //= 5;
    my ($package, $filename, $line) = caller();

    my $logcolor;
    $logcolor = "black" if $level == 0;
    $logcolor = "red" if $level == 1;
    $logcolor = "green" if $level == 2;
    $logcolor = "yellow" if $level == 3;
    $logcolor = "blue" if $level == 4;
    $logcolor = "magenta" if $level == 5;
    $logcolor = "cyan" if $level == 6;
    $logcolor = "white" if $level == 7;

    my $message = "";

    # $message = "$prompt ".color("bold $logcolor")."${package}::$name".color('reset')." $msg";
    # $message = "$prompt ".color("bold $logcolor")."$name".color('reset').$msg;

    $message = "$prompt ".color("bold $logcolor")."$name".color('reset');

    print(STDERR "\r  $message ");

    # print(STDERR "\033[K");  # clear the line
    # print(STDERR "\r");
    # print(STDERR "\033[F");  # move up
    # print(STDERR "\033[2J");  # clear the screen
    # print(STDERR "\033[H");   # move cursor to the top left
}
# }}}

# }}}

# imagemagick functions {{{

# image string {{{
sub imstring {
    my $subname = (split(":", (caller(0))[3]))[-1];

    # params {{{
    my ($opts) = @_; # hashref
    $opts ||= {};
    my $inputs = $opts->{input}   // 'null';
    my $output = $opts->{output}  // '';
    my $text   = $opts->{text}    // '';
    my $scale  = $opts->{scale}   // 1;
    my $width  = $opts->{width}   // 800;
    my $height = $opts->{height}  // 600;
    my $ltr    = $opts->{ltr}     // 'caption';  # pango
    my %font = (
        name => $opts->{font}     // $font,
        size => $opts->{size}     // 0,
    );
    my %gap = (
        i => $opts->{gap_i}    // 1,
        x => $opts->{gap_x}    // 0,
        y => $opts->{gap_y}    // 0,
    );
    my %color  = (
        foreground => $opts->{foreground}  // 'black',
        background => $opts->{background}  // 'white',
    );
    # }}}

    logger($subname, "text is not specified\n", 3) unless $text;
    logger($subname, "output image is not specified\n", 3) unless $output;

    my @input;
    my $merge = 0;
    my $generate = 0;

    if ($inputs && $inputs ne 'null') {
        @input = split(",", $inputs);
        $merge = 1;
    } else {
        logger($subname, "input is not specified\n", 2);
        $generate = 1;
    }

    my $timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime);
    my $tmpdir = "/tmp/imagemagick/$timestamp-$subname";
    my $tmpfile_text = "$tmpdir/imagemagick-tmp-text.png";
    my $tmpfile_image = "$tmpdir/imagemagick-tmp-image.png";

    if ($merge) {
        make_path($tmpdir);
        $generate = 0;
    }
    if ($generate) {
        logger($subname, "missing input file, an empty image will be generated\n", 2);
        $tmpfile_text = $output;
        $input[0] = $output;
        $merge = 0;
    }

    if ($merge) {
        my %resolution = (
            a => `$identify -format '%wx%h' $input[0]`,
            x => `$identify -format '%w' $input[0]`,
            y => `$identify -format '%h' $input[0]`,
        );
        $width = $resolution{x} / $scale;
        $height = $resolution{y} / $scale;
    }

    my $resolution = "${width}x$height";
    my $inner_gap;
    my $inner_width;
    my $inner_height;
    my $inner_resolution = $resolution;
    if ($gap{i}) {
        $inner_gap        = $gap{i} * 100;
        $inner_width      = $width - $inner_gap;
        $inner_height     = $height - $inner_gap;
        $inner_resolution = "${inner_width}x$inner_height";
    }

    pretty("$subname", "$input[0] > $output ");
    if ($merge) {
        $color{background} = 'none';
    }
    my @exe = (
        $runner,
            "-gravity", "West",
            "-background", $color{background},
            "-fill", $color{foreground},
            "-size", $inner_resolution,
            "-font", $font{name},
    );
    push(@exe, ("-pointsize", $font{size})) if $font{size};
    push(@exe, (
        "${ltr}:$text",
        "-background", $color{background},
        "-fill", $color{foreground},
        "-gravity", "Center",
        "-extent", $resolution,
        $tmpfile_text
    ));
    my $_exit_code = system(@exe);

    if ($merge) {
        # imtrim({input => $tmpfile_text, output => $tmpfile_text});
        # clean();

        imresize({input => $tmpfile_text, output => $tmpfile_text, resolution_a => $resolution});
        clean();

        immerge({input => "$tmpfile_text,$input[0]", output => $output});
        clean();
    }

    pretty($subname, "remove $tmpdir ");
    remove_tree($tmpdir, {error => \my $err});
    if (@$err) {
        foreach my $diag (@$err) {
            print(STDERR check_exit_code($?));
            logger($subname, "Failed to remove $diag->[0]: $diag->[1]\n", 2);
        }
    } else {
        print(STDERR check_exit_code($?));
    }

    pretty("$subname", "$input[0] > $output ");
    my $exit_code = $_exit_code >> 8;
    print(STDERR check_exit_code($exit_code));
}
# }}}

# image trim {{{
sub imtrim {
    my $subname = (split(":", (caller(0))[3]))[-1];

    # params {{{
    my ($opts) = @_; # hashref
    $opts ||= {};
    my $inputs = $opts->{input}        // '';
    my $output = $opts->{output}       // '';
    # }}}

    my @input = split(",", $inputs);

    my $timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime);

    logger($subname, "missing file: input: $input[0]: No such file or directory\n", 3) unless -f $input[0];
    logger($subname, "No input image is specified\n", 3) unless $input[0];
    logger($subname, "No output image is specified\n", 3) unless $output;

    pretty("$subname", "$input[0] > $output ");
    my @exe = (
        $runner,
        $input[0],
        "-trim",
        $output,
    );

    my $_exit_code = system(@exe);
    my $exit_code = $_exit_code >> 8;
    print(STDERR check_exit_code($exit_code));
}
# }}}

# image shadow {{{
sub imshadow {
    my $subname = (split(":", (caller(0))[3]))[-1];

    # params {{{
    my ($opts) = @_; # hashref
    $opts ||= {};
    my $inputs = $opts->{input}        // '';
    my $output = $opts->{output}       // '';
    my %border = (
        color => $opts->{border_color} // "none",
        width => $opts->{border_width} // 0,
    );
    my %shadow = (
        width => $opts->{shadow_width} // 110,
        color => $opts->{shadow_color} // "black",
        rate  => $opts->{shadow_rate}  // 10,
        x     => $opts->{shadow_x}     // 1,
        y     => $opts->{shadow_y}     // 1,
    );
    my $background_color = $opts->{background_color} // 'none';
    # }}}

    my @input = split(",", $inputs);

    my $timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime);

    logger($subname, "missing file: input: $input[0]: No such file or directory\n", 3) unless -f $input[0];
    logger($subname, "No input image is specified\n", 3) unless $input[0];
    logger($subname, "No output image is specified\n", 3) unless $output;

    pretty("$subname", "$input[0] > $output ");
    my @exe = (
        $runner,
        $input[0],
        "-bordercolor", $border{color},
        "-border", $border{width}, '(',
            "+clone", "-background",
            $shadow{color}, "-shadow", "$shadow{width}x$shadow{rate}+$shadow{x}+$shadow{y}",
        ')',
        "+swap", "-background", ${background_color},
        "-layers", "merge", "+repage",
        $output,
    );

    my $_exit_code = system(@exe);
    my $exit_code = $_exit_code >> 8;
    print(STDERR check_exit_code($exit_code));
}
# }}}

# }}}

# create html img tag {{{
sub html_print {
    die "No partials directory specified" unless $partials;
    die "No partials directory specified" unless -d $partials;
    print qq{  <p class="badges">\n};
    for my $name (sort keys %icons) {
        my $alt = ucfirst($name) . " Logo";
        print qq{    <img src="$img_dir/badge-$name.png" alt="$alt" width="$width">\n};
    }
    print qq{  </p>\n};
    exit 0;
}
# }}}

# generate images {{{
sub image_generate {
    die "No image directory specified" unless $images;
    die "No image directory specified" unless -d $images;
    foreach my $key (keys %icons) {
      my $name = $key;
      my $output = "badge-$name.png";
      my $icon = $icons{$key}->{icon};
      my $color = $icons{$key}->{color};
      $color = "#f8f8f8",

      imstring({
          input => "null",
          text => $icon,
          height => $height,
          size => $size,
          width => $height,
          font => $font,
          background => "none",
          foreground => $color,
          output => $output,
      });

      imshadow({
          input => $output,
          output => $output,
      });

      imtrim({
          input => $output,
          output => $output,
      });

    }

    exit 0;
}
# }}}

print_usage() unless $cmd;
html_print() if $cmd eq "print";
image_generate() if $cmd eq "generate" || $cmd eq "create";


