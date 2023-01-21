#!/usr/bin/perl

use strict;
use warnings;
no warnings "experimental";
use feature "switch";
use Getopt::Long;
use Term::ANSIColor;
use Term::ANSIColor qw(:constants);

$Term::ANSIColor::AUTORESET = 1;


sub throw_err {
    my $err_msg = shift;
    print STDERR BOLD "$0: ", RED "Error: ";
    print STDERR "$_[0]\n";
    die "$0 terminated\n";
}


throw_err "Must be run as root" if $> != 0;

my $prog;
my $path, $dest;
my $help;

GetOptions(
    "path|p=s"        => \$path,
    "destination|d=s" => \$dest,
    "help|h"          => \$help
);

if ($help) {
    print "Usage: $0 <program> [OPTIONS]\n";
    print "  -p, --path             Path to a custom installation file/executable/archive. (optional)\n";
    print "  -d, --destination      Destination where the program will be installed. (optional)\n";
    print "  -h, --help             Show this help message.\n";
    exit;
}

$prog = shift @ARGV;

if (!$prog) {
    print "Usage: $0 <program> [-p /path] [-d /destination]\n";
    print "Try '$0 --help' for more information.\n";
    exit 1;
}

print "\n";

given (lc $prog) {

    when ('discord') {
        print UNDERLINE MAGENTA "Updating Discord\n\n";

        # Download archive
        if (not defined $path) {
            $path = "/tmp/discord.tar.gz";
            system "wget -O $path 'https://discord.com/api/download?platform=linux&format=tar.gz'" or throw_err "Failed to download archive: $!";
            print YELLOW "Downloaded archive to $path\n";
        }
        $dest = "/usr/share/discord" if not defined $dest;

        # Extract archive
        system "mkdir -p $dest && tar -xzf $path -C $dest --strip-components=1" or throw_err "Failed to extract archive: $!";
        print YELLOW "Extracted archive to $dest\n";

        # Create a symbolic link
        system "ln -sf $dest/Discord /usr/bin/Discord" or throw_err "Failed to create a symbolic link: $!";
        print YELLOW "Created a symbolic link in /usr/bin\n";

        # Make a shortcut
        open(my $IN, '<', "$dest/discord.desktop") or throw_err "Failed to open discord.desktop: $!";
        open(my $OUT, '>', "/usr/share/applications/discord.desktop") or throw_err "Failed to create a shortcut: $!";
        
        while(<$in>) { 
            s/Icon=discord/Icon=$dest\/discord.png/g;
            print $out $_;
        }

        close $in;
        close $out;

        print YELLOW "Created a shortcut in /usr/share/applications\n";

        # Complete
        print BRIGHT_GREEN "\nCompleted updating Discord!\n";
    }

}
