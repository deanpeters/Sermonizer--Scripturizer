package Sermonizer::Scripturizer;
#############################################################
# Sermonizer::Scripturizer                                  #
# Copyright 2002-2004                                       #
#      Dean Peters     http://www.healyourchurchwebsite.com #
#                                                           #
# Additional Credits:                                       #
#      Jonathan Fox                                         #
#      Jason Rust                                           #
#      Joseph Markey                                        #
#                                                           #
# MovableType Scripturizer Plug-In Tutorial                 #
#      Rob Hulson                                           #
#                                                           #
#                                                           #
#############################################################
#   This package hyperlinks Scripture references in text    #
#############################################################
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(addLinks encodePassage scripturize scripturizeArray parseText);

use vars qw($volumes $books $versions);
$volumes = qr/I+|1st|2nd|3rd|First|Second|Third|1|2|3/;

# # abbrevations inspired by http://www.gnpcb.org/esv/share/about/#book-queries
$books  = "Genesis|Gen\.|Exodus|Exod*\.|Leviticus|Lev\.|Levit*\.|Numbers|Nmb\.|Numb*\.|Deuteronomy|Deut*\.|Joshua|Josh*\.|Judges|Jdg\.|Judg*\.|Ruth|Ru\.|Samuel|Sam\.|Sml\.|Kings|Kngs*\.|Kin*\.|Chronicles|Chr\.|Chron\.|Ezra|Ez\.|Nehemiah|Nehem*\.|Esther|Esth*\.";
$books .= "|Job|Jb\.|Psalms*|Psa*\.|Proverbs*|Prov*\.|Ecclesiastes|Eccl*\.|Songs* of Solomon|Song*\.|Songs\.|Isaiah|Isa\.|Jeremiah|Jer\.|Jerem\.|Lamentations|Lam\.|Lament*\.|Ezekiel|Ezek*\.|Daniel|Dan\.|Hosea|Hos\.|Joel|Jo\.|Amos|Am\.|Obadiah|Obad*\.|Jonah|Jon\.|Micah|Mic\.|Nahum|Nah\.|Habakkuk|Hab\.|Habak\.|Zephaniah|Zeph\.|Haggai|Hag\.|Hagg\.|Zechariah|Zech*\.|Malachi|Malac*\.|Mal\.";
$books  = qr/$books|Mat+hew|Mat*\.|Mark|Mrk\.|Luke|Lu*k\.|John|Jhn\.|Jo\.|Acts*|Ac\.|Romans|Rom\.|Corinthians|Cor\.|Corin\.|Galatians|Gal\.|Galat\.|Ephesians|Eph\.|Ephes\.|Phil+ippians|Phili*\.|Colossians|Col\.|Colos\.|Thessalonians|Thes*\.|Timothy|Tim\.|Titus|Tts\.|Tit\.|Philemon|Phil*\.|Hebrews|Hebr*\.|James|Jam\.|Jms\.|Peter|Pete*\.|Jude|Ju\.|Revelations*|Rev\.|Revel\./;

$versions = qr/NIV|NASB|AMP|NLT|KJV|ESV|CEV|NKJV|KJ21|ASV|WE|YLT|DARBY|WYC|NIV-UK/;

# scripturize a single string of text
sub scripturize {
  my ($text,$bible) = @_;
  return $text if $bible eq "0"; # Don't do anything if a zero is passed

  my @text = parseText($text);
  my $newtext = "";
  foreach my $chunk (@text) {
    unless($chunk =~ //) {	# Only add links to chunks that are not HTML tags
      $chunk = addLinks($chunk,$bible);
    }
    $newtext = join("",$newtext,$chunk); # Join the chunks of text back together
  }
  return $newtext;
}

# scripturize an array of strings
sub scripturizeArray {
  my (@data, $bible) = @_;
  my @output;
  return @data if $bible eq "0"; # Don't do anything if a zero is passed

  foreach my $oldtext (@data) {
      my $newtext = scripturize($oldtext, $bible);
      push (@output, $newtext);
  }
  return @output;
}

sub addLinks {
  my ($text,$bible) = @_;
	my $passage;

	# include instances of James 2:1-13, 14 - 16, 17 &amp; 18
  my $verses = qr{ \d+ (: \d+)* \s* (?: [-&amp;] \s* \d+)*    }x;

  # because Stephen Smith is cool
  my $link =  ($bible =~ m/esv/i ? "http://www.gnpcb.org/esv/search/?go=Go&amp;q=" :
                                   "http://biblegateway.com/cgi-bin/bible?language=english&amp;version=$bible&amp;passage=");
  my $title = ($bible =~ m/esv/i ? "English Standard Version Bible" : "Bible Gateway");

	# don't just match, replace
  # http://thegreatlands.com/archives/000032.html
	$text =~ s/
		(?:($volumes)\s*)*         # any number of vols.
		(\s*)                      # see thegreatlands.com hyperlink above
		($books)                   # the book
		\s*
		( $verses (?: \s* , \s* $verses)* )
    /$passage = ($1 ? "$1 ": "") . ($3 ? $3 : "") . ($4 ? " $4" : "");
		"$2<a>$passage"
		/gex;

 	 return $text;
}

sub encodePassage {
   my ($vol, $bk, $ver) = @_;
   $ver =~ s/:/%3A/gi;          # convert to encoded colon
   $ver =~ s/[,&amp;;]/%2C/gi;       # convert to encoded comma
   $ver =~ s/\s*//gi;
   my $passage = ($vol ? "$vol+":"").($bk ? "$bk+":"").($ver ? "$ver":"");
   return $passage;
}


# This parses the text for hyperlinks etc and returns an array.
sub parseText {
	my $text = shift;

	# Split the text into chunks around tags, hyperlinks, and pre and code blocks.
	my @text = split(/(<a>|<code>|<pre>|)/,$text);
	return @text;
}



1;
__END__


=head1 NAME

Sermonizer::Scripturizer - hyperlink Scripture references in text

=head1 SYNOPSIS

use Sermonizer::Scripturizer;
foreach (scripturizeArray()) { print $_; };

=head1 DESCRIPTION

Sermonizer::Scripturizer searches a text stream and replaces any
instances of a Scripture reference with a hyperlink to the to the
Bible Gateway online Bible.

=head1 IMPROVEMENTS
* Added ability to allow user to define which online Bible to use
* Added code soas not to link up Scripture already linked
* Created instance variables global to the scope of the module to contain the book volumes, etc.
* Added abbreviations and pluralization typos to regex evaluation (e.g. Rev. or Revalations).
* Changed regex mode modifiers from /gcex to /gex
* Added ESV Bible hyperlink for those who identify 'ESV' as their version
* Changed ampersands in hyperlinks to unicode (e.g. &amp; becomes &amp;)
* Eliminated extra space before non-white space characters (J.Markey fix)


=head1 BUGS
* add XML::RPC capabilities to retrieve snippets from ESV Library
* add ability to mop-up typos -- such as 'Revalations'

=head1 AUTHOR

Copyright 2002-2004
  Dean Peters   
  
Additional Credits:
  Jonathan Fox  
  Jason Rust 
  Joseph Markey 

MovableType Scripturizer Plug-In Tutorial
  Rob Hulson    

=head1 EXAMPLE

BEGIN { push(@INC, "C:/Inetpub/wwwroot/perl/lib/"); }
use Sermonizer::Scripturizer;

my $filename = "sermon01.txt";
open(FILE, $filename ) or die "Couldn't open the file '$filename'. \n$!";

foreach (scripturizeArray()) {
	print  $_;
}
close FILE;


=head1 COPYRIGHT and LICENSE

Copyright (c) 2002-2004
  Dean Peters   

Additional Credits:
  Jonathan Fox  
  Jason Rust 
  Joseph Markey 

MovableType Scripturizer Plug-In Tutorial
  Rob Hulson    

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

The Software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall
the authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising
from, out of or in connection with the Software or the use or other
dealings in the Software.

=cut