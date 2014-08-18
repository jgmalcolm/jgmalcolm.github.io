#!perl

print "Processing Progress\n";

$i = 0;				# counter for arrays
$Progress = 0;			# counter for terms' progress
open (TERMS, "<terms.txt");	# get handle for terms.txt file
@terms = <TERMS>;		# get each term as array element
chop (@terms);			# get rid of newline characters at end of elements
@terms = sort (@terms);		# sort in alphabetical order
close (TERMS);			# release handle for terms.txt
open (TERMS, ">terms.txt");	# create blank terms.txt
foreach $line (@terms)
	{ print TERMS "$line\n"; }
close (TERMS);			# release handle for terms.txt

# start error proofing the querry info
for ($i = 0; $i < @terms; $i++)
	{
	$terms[$i] =~ s/-/_1/gi;
	$terms[$i] =~ s/ /_2/gi;
	$terms[$i] =~ s/^[0-9]/_3$&/gi;
	$terms[$i] =~ s/'/_4/gi;
	$terms[$i] = "_$terms[$i]";	# add underscore to front
	}

$caption;			# define caption
chdir ("..");			# move up one directory
open (TERMS, ">misc/terms.js");


$generated = localtime;	# get time info
print TERMS "//jimi malcolm - malcolmj1\@juno.com - http://guide.ticalc.org\n";

# print array of strings with name of each array following
print TERMS "var allTerms=new Array(";
$i = 0;				# reset counter
foreach $term (@terms)
	{
	print TERMS "," unless ($i++ == 0);
	print TERMS "\"$term\"";
	}
print TERMS ")\;";

opendir (FILE_DIR, ".");	# open directory with name FILE_DIR
@temp = readdir (FILE_DIR);	# get directory's contents
closedir (FILE_DIR);		# release directory FILE_DIR

# get rid of everything besides folder names which don't have an extension
foreach $item (@temp)
	{
	# push items to start of new array if they're valid folders
	unshift (@folders, $item) unless ($item =~ /^\.+$/ || $item =~ /\./)
	}
@folders = sort (@folders);	# sort alphabetical order

# sets boundaries for crude progress indicator
$TempProg = @terms;		# number of folders

foreach $querry (@terms)
{
$tempquerry = $querry;		# save away querry because we're going to parse it
$querry =~ s/_//;		# get rid of underscore at beginning
$querry =~ s/_1/-/gi;
$querry =~ s/_2/ /gi;
$querry =~ s/_3//gi;
$querry =~ s/_4/'/gi;
$i = 0;				# reset counter
print TERMS "var $tempquerry=new Array(";

foreach $folder (@folders)
	{
	@files = ();			# clear files list
	chdir ($folder);		# change to that directory
	opendir (CUR_DIR, ".");		# open current directory
	@temp = readdir (CUR_DIR);	# read contents
	closedir (CUR_DIR);		# release directory

	foreach $item (@temp)
		{
		# push items to start of new array if they're valid folders
		unshift (@files, $item) unless ($item =~ /^\.+$/ || $item =~ /(js|css|pl)$/)
		}
	foreach $file (@files)
		{
		open (CUR_FILE, "$file");
		@file_data = <CUR_FILE>;
		close (CUR_FILE);

		$caption = "$folder/$file";	# defaults to file name
		NEW_FILE: foreach $line (@file_data)
			{ # search each line of text
			if ($line =~ /top\(".*"\)/)
				{
				$caption = $&;
				# strip off everything around article/page title
				$caption =~ s/top\(\".*\", ?\"//g;
				$caption =~ s/\"\)//g;
				}
			$caption = "$folder/$file" unless ($file =~ /\.html?$/);
			if ($line =~ /$querry/i)
				{
				last NEW_FILE if ($line =~ /<$querry/i);
				print TERMS "," unless ($i++ == 0);
				print TERMS "\"$folder/$file?$caption\"";
				last;
				}
			}
		}
	chdir ("..");			# move back up one directory
	}
print TERMS ")\;";
$i = 0;
$temp1 = sprintf("%5d", ++$Progress);
$temp2 = sprintf("%5d", $TempProg);
$temp3 = sprintf("%3d", 100 * $temp1/$temp2);
$temp =  "$temp1 terms of $temp2 completed [ $temp3% ]";
# print where we are now
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b\b\b";
print "\b\b\b$temp";
}

close (TERMS);			# release terms.js file