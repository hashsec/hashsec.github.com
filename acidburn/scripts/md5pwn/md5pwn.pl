#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;

##################################################
#   _______ _____  ______                        #
#  |   |   |     \|    __|                       #
#  |       |  --  |__    |.-----.--.--.--.-----. #
#  |__|_|__|_____/|______||  _  |  |  |  |     | #
#                         |   __|________|__|__| #
#                         |__|  > by Acidburn    #
##################################################
#                                                #
#           [1]  milw0rm.com                     #
#           [2]  gdataonline.com                 #
#           [3]  passcracking.com                #
#           [4]  hashcracking.com                #
#           [5]  md5decryption.com               #
#           [6]  hashchecker.com                 #
#           [7]  victorov.su                     #
#           [8]  md5decrypter.com                #
#           [9]  blacklight.gotdns.org           #
#           [10] bigtrapeze.com                  #
#           [11] hashkiller.com                  #
#           [12] md5hood.com                     #
#           [13] md5crack.com                    #
#           [14] plain-text.info                 #
#                                                #
##################################################

print '##################################################' . "\n".
      '#   _______ _____  ______                        #' . "\n".
      '#  |   |   |     \|    __|                       #' . "\n".
      '#  |       |  --  |__    |.-----.--.--.--.-----. #' . "\n".
      '#  |__|_|__|_____/|______||  _  |  |  |  |     | #' . "\n".
      '#                         |   __|________|__|__| #' . "\n".
      '#                         |__|  > by Acidburn    #' . "\n".
      '##################################################' . "\n";

# Get md5 hash
my $md5hash = lc shift || die '[!] Error: You must supply an md5 hash' . "\n";

# Check that this is a valid md5 hash
if  ($md5hash !~ /^[0-9a-f]{32,32}$/ ) {
    die '[!] Error: An md5 hash should consist of 32 hexadecimal digits' . "\n";
}

# Setup useragent object
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->agent('Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6) Gecko/20100105 Gentoo Firefox/3.5.6');

# LWP routines
sub get {
    my $url = $_[0];
    $ua->get($url)->content();
}
sub post {
    my ($url, %parameters) = ($_[0], %{$_[1]});
    my $referer = '';
    $referer = $_[2] if ($_[2]);
    $ua->post($url, {%parameters}, Referer => $referer)->content();
}

# milw0rm.com
sub milw0rm
{
    my $url = 'http://milw0rm.com/cracker/search.php';
    my %parameters = ('hash' => $md5hash, 'Submit' => 'Submit');
    my $page = &post($url, \%parameters);
    print '[+] milw0rm.com' . "\n";
    if ($page =~ m!</TD><TD align=\"middle\" nowrap=\"nowrap\" width=90>(.*)</TD><TD align=\"middle\" nowrap=\"nowrap\" width=90>cracked</TD></TR>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# gdataonline.com
sub gdataonline
{
    my $url = 'http://gdataonline.com/qkhash.php?mode=txt&hash=' . $md5hash;
    my $page = &get($url);
    print '[+] gdataonline.com' . "\n";
    if ($page =~ m!<td width=\"35%\"><b>(.*)</b>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# passcracking.com
sub passcracking
{
    my $url = 'http://passcracking.com/';
    my %parameters = ('datafromuser' => $md5hash);
    my $page = &post($url, \%parameters);
    print '[+] passcracking.com' . "\n";
    if ($page =~ m!<td bgcolor=\#FF0000>(.*)</td><td>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# hashcracking.com
sub hashcracking
{
    my $url = 'http://md5.hashcracking.com/search.php?md5=' . $md5hash;
    my $page = &get($url);
    print '[+] hashcracking.com' . "\n";
    if ($page =~ m!Cleartext of $md5hash is (.*)!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# md5decryption.com
sub md5decryption
{
    my $url = 'http://md5decryption.com';
    my %parameters = ('hash' => $md5hash, 'submit' => 'Decrypt It!');
    my $page = &post($url, \%parameters);
    print '[+] md5decryption.com' . "\n";
    if ($page =~ m!<font size='2'>Decrypted Text: </b>(.*)</font>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# hashchecker.com
sub hashchecker
{
    my $url = 'http://www.hashchecker.com/index.php';
    my %parameters = ('search_field' => $md5hash);
    my $page = &post($url, \%parameters);
    print '[+] hashcheker.com' . "\n";
    if ($page =~ m!<li>$md5hash is <b>(.*)</b>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# victorov.su
sub victorov
{
    my $url = 'http://victorov.su/md5/?md5d=' . $md5hash;
    my $page = &get($url);
    print '[+] victorov.su' . "\n";
    if ($page =~ m!<b>(.*)</b>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# md5decrypter.com
sub md5decrypter
{
    my $url = 'http://www.md5decrypter.com';
    my %parameters = ('hash' => $md5hash);
    my $page = &post($url, \%parameters);
    print '[+] md5decrypter.com' . "\n";
    if ($page =~ m!Normal Text: </b>(.*)!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# blacklight.gotdns.org
sub blacklight
{
    my $url = 'http://blacklight.gotdns.org/cracker/crack.php';
    my %parameters = ('hash' => $md5hash, 'algos' => 'MD5', 'crack' => 'Crack');
    my $page = &post($url, \%parameters);
    print '[+] blacklight.gotdns.org' . "\n";
    if ($page =~ m!-> <b>(.*)</b><br><br>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }

}

# bigtrapeze.com
sub bigtrapeze
{
    my $url = 'http://www.bigtrapeze.com/md5/index.php';
    my %parameters = ('query' => $md5hash);
    my $page = &post($url, \%parameters);
    print '[+] bigtrapeze.com' . "\n";
    if ($page =~ m!=> <strong>(.*)</strong>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# hashkiller.com
sub hashkiller
{
    my $url = 'http://opencrack.hashkiller.com/';
    my %parameters = ('oc_check_md5' => $md5hash);
    my $page = &post($url, \%parameters);
    print '[+] hashkiller.com' . "\n";
    if ($page =~ m!<div class=\"result\">$md5hash:(.*)<br/>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# md5hood.com
sub md5hood
{
    my $url = 'http://www.md5hood.com/index.php/cracker/crack';
    my %parameters = ('hash' => $md5hash, 'submit' => 'Go');
    my $page = &post($url, \%parameters);
    print '[+] md5hood.com' . "\n";
    if ($page =~ m!<div class=\"result_true\">(.*)</div>!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# md5crack.com
sub md5crack
{
    my $url = 'http://www.md5crack.com/crackmd5.php';
    my %parameters = ('term' => $md5hash, 'crackbtn' => 'Crack that hash baby!');
    my $page = &post($url, \%parameters);
    print '[+] md5crack.com' . "\n";
    if ($page =~ m!Found: md5\(\"(.*)\"\)!) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

# plaintext.info
sub plaintext
{
    my $url = 'http://plain-text.info/search';
    my %parameters = ('searchhash' => $md5hash, 'searchstatus' => 'cracked', 'searchaction' => 'show');
    my $page = &post($url, \%parameters, $url);
    print '[+] plain-text.info' . "\n";
    if ($page =~ m!<td>$md5hash</td>\r\n<td>(.*)</td>!g) {
        print '[>] Found: [ ' . $1 . ' ]' . "\n";
    } else {
        print '[!] Not found!' . "\n";
    }
}

&milw0rm;
&gdataonline;
&passcracking;
&hashcracking;
&md5decryption;
&hashchecker;
&victorov;
&md5decrypter;
&blacklight;
&bigtrapeze;
&hashkiller;
&md5hood;
&md5crack;
&plaintext;
