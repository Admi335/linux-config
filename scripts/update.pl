#!/usr/bin/perl

use strict;
use warnings;
no warnings "experimental";
use feature "switch";
use Term::ANSIColor;
use Term::ANSIColor qw(:constants);

$Term::ANSIColor::AUTORESET = 1;


sub throw_err {
    print BOLD "update: ", RED "fatal error: ";
    print "$_[0]\n";
    die "update terminated\n";
}


throw_err "must be run as root" if $> != 0;
throw_err "no arguments" if not defined $ARGV[0];

my $prog = $ARGV[0];
my $path = $ARGV[1];
my $dest = $ARGV[2];

print "\n";

given (lc $prog) {

    when ('discord') {
        print UNDERLINE MAGENTA "Updating Discord\n\n";

        if (not defined $path) {
            print "Enter the path to the archive containing new Discord version: ";
            $path = <STDIN>; print "\n";
            chomp $path;
        }
        $dest = "/usr/share/discord" if not defined $dest;

        # Extract archive
        system "mkdir -p $dest && tar -xzf $path -C $dest --strip-components=1";
        print YELLOW "Extracted archive to $dest\n";

        # Create a symbolic link
        system "ln -sf $dest/Discord /usr/bin/Discord";
        print YELLOW "Created a symbolic link in /usr/bin\n";

        # Make a shortcut
        open(IN, '<', "$dest/discord.desktop") or die $!;
        open(OUT, '>', "/usr/share/applications/discord.desktop") or die $!;
        
        while(<IN>) { 
            s/Icon=discord/Icon=$dest\/discord.png/g;
            print OUT $_;
        }

        close IN;
        close OUT;

        print YELLOW "Created a shortcut in /usr/share/applications\n";

        # Complete
        print BRIGHT_GREEN "\nCompleted updating Discord!\n";
    }

}
