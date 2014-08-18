#!Perl
#########################################################
# replace.pl by Jimi Malcolm (malcolmj1@juno.com)	#
# Created: 1:29 PM 6/11/00				#
# Last Modified: 12:54 PM 6/24/00			#
#########################################################
# Configuration						#
$Replace=	'';
$With =		'';
# Done							#
#########################################################
# Variables						#
$Found = 0;
# Done							#
#########################################################

if ($Replace =~ /^$/)
	{
	print <<"(End of Code)";

===================== Warning! =====================

Configure the \$Replace and \$With scalars and run
again. All changes made by this script are
permanent, so watch yourself!

====================================================

(End of Code)
	exit;	#break program execution
	}

opendir (DIR, "..");
@Directories = grep { !/^\.+$|\.|images|download/ } readdir (DIR);
closedir (DIR);

opendir (DIR, "..");
@Files = grep { !/^\.+$/ && /\./} readdir (DIR);
closedir (DIR);

push @Files, "download\\download.htm";

foreach $File (@Files)
	{
	open (FILEi, "<..\\$File");
	@Contents = <FILEi>;
	close (FILEi);

	open (FILEo, ">..\\$File");
	foreach $Line (@Contents)
		{
		if ($Line =~ m/$Replace/)
			{
			$Found++;
			$Line =~ s/$Replace/$With/gi;
			}
		print FILEo $Line;
		}
	close (FILEo);
	}

foreach $Directory (@Directories)
	{
	opendir (DIR, "..\\$Directory");
	@Files = sort grep { /\./ and !/^\.+$|\.(zip|pl)$/ } readdir (DIR);
	closedir (DIR);

	foreach $File (@Files)
		{
		open (FILEi, "<..\\$Directory\\$File");
		@Contents = <FILEi>;
		close (FILEi);

		open (FILEo, ">..\\$Directory\\$File");

		foreach $Line (@Contents)
			{
			if ($Line =~ m/$Replace/)
				{
				$Found++;
				$Line =~ s/$Replace/$With/gi;
				}
			print FILEo $Line;
			}
		close (FILEo);
		}
	}

print "\n  Replace Engine found $Found occurrences of '$Replace'.\n" if $Found > 1;
print "\n  Replace Engine found 1 occurrence of '$Replace'.\n" if $Found == 1;
print "\n  Replace Engine did not find '$Replace'.\n" if $Found == 0;