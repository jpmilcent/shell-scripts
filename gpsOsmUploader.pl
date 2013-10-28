#!/usr/bin/perl -w
#
# Script d'upload de fichier GPX
# Récupération de la description et des tags depuis la description du GPX
# Inspiration : http://wiki.openstreetmap.org/wiki/Batch_Upload
# Pour l'utiliser ajouter votre login et mot de passe ci-dessous
use utf8;
no utf8; 
use HTTP::Request::Common;
use LWP::UserAgent;
 
$yourusername='';	# put your OSM username between the quotes
$yourpassword='';	# put your OSM password between the quotes

open(LOG, '>gpxOsmUpload.log') || die ("Erreur d'ouverture de gpxOsmUpload.log");
foreach $filename (@ARGV) {
	$desc = '';
	open(FILE, $filename) || die ("Erreur d'ouverture de ".$filename);
	while (<FILE>) {
		if ($_ =~ m/^\s*<desc>([^<]+)<\/desc>/) {
			$desc = $1;
			$desc =~ s/&apos;/'/g;
		}
	}
	close(FILE);
	$tags = $description = $desc;
	
	$ua = LWP::UserAgent->new;
	$ua->credentials('www.openstreetmap.org:80', 'Web Password', $yourusername, $yourpassword);
 
	$uploadingMsg = "Uploading $filename\n";
	for my $fh (STDOUT, LOG) { print $fh $uploadingMsg; }
 
	$response = $ua->request(POST 'http://www.openstreetmap.org/api/0.6/gpx/create',
		Content_Type => 'form-data',
		Content => [file  => [$filename],
			description => $description,
			tags => $tags,
			visibility => "identifiable" ]);
 
	if ($response->code == 200) {
		# yay, success
		$successMsg = "uploaded successfully with tags : $tags\n";
		for my $fh (STDOUT, LOG) { print $fh $successMsg; }
	} else {
		# boo, failure
		$errorMsg = "couldn't upload $filename\n";
		for my $fh (STDOUT, LOG) { print $fh $errorMsg; }
	}
}
close(LOG);
