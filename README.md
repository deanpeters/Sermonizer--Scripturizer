Sermonizer::Scripturizer - a Perl Package to hyperlink Scripture references in plain text 
=========================================================================================

## SYNOPSIS ##

use Sermonizer::Scripturizer;
foreach (scripturizeArray()) { print $_; };

## DESCRIPTION ##

Sermonizer::Scripturizer searches a text stream and replaces any
instances of a Scripture reference with a hyperlink to the to the
Bible Gateway online Bible.

## IMPROVEMENTS ##
* Added ability to allow user to define which online Bible to use
* Added code soas not to link up Scripture already linked
* Created instance variables global to the scope of the module to contain the book volumes, etc.
* Added abbreviations and pluralization typos to regex evaluation (e.g. Rev. or Revalations).
* Changed regex mode modifiers from /gcex to /gex
* Added ESV Bible hyperlink for those who identify 'ESV' as their version
* Changed ampersands in hyperlinks to unicode (e.g. &amp; becomes &amp;)
* Eliminated extra space before non-white space characters (J.Markey fix)


## BUGS ##
* add XML::RPC capabilities to retrieve snippets from ESV Library
* add ability to mop-up typos -- such as 'Revalations'
  
## EXAMPLE ##

BEGIN { push(@INC, "C:/Inetpub/wwwroot/perl/lib/"); }
use Sermonizer::Scripturizer;

my $filename = "sermon01.txt";
open(FILE, $filename ) or die "Couldn't open the file '$filename'. \n$!";

foreach (scripturizeArray()) {
	print  $_;
}
close FILE;


## COPYRIGHT and LICENSE ##

Copyright (c) 2002-2012
  Dean Peters   

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

