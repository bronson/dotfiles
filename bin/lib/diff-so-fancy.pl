my $columns_to_remove = 0;
my ($file_1,$file_2);
my $last_file_seen = "";
my $i = 0;

while (my $line = <>) {

	######################################################
	# Pre-process the line before we do any other markup
	######################################################

	# If the first line of the input is a blank line, skip that
	if ($i == 0 && $line =~ /^\s*$/) {
		next;
	}

	# Mark empty line with a red/green box indicating addition/removal
	if ($mark_empty_lines) {
		$line = mark_empty_line($line);
	}

	# Remove the correct number of leading " " or "+" or "-"
	if ($strip_leading_indicators) {
		$line = strip_leading_indicators($line,$columns_to_remove);
	}

	######################
	# End pre-processing
	######################

	#######################################################################
	} elsif ($line =~ /^$ansi_color_regex---* (\w\/)?(.+?)(\e|\t|$)/) {
		my $next = <>;
		$next    =~ /^$ansi_color_regex\+\+\+* (\w\/)?(.+?)(\e|\t|$)/;
		if ($file_2 ne "/dev/null") {
			$last_file_seen = $file_2;
		}
		my $hunk_header    = $4;
		my $remain         = bleach_text($5);
		$columns_to_remove = (char_count(",",$hunk_header)) - 1;
		print "@ $last_file_seen:$start_line \@${bold}${dim_magenta}${remain}${reset_color}\n";
		my $next = <>;

	$i++;
######################################################################################################
# End regular code, begin functions
######################################################################################################

sub mark_empty_line {
	my $line = shift();
	$line =~ s/^($ansi_color_regex)[+-]$reset_color\s*$/$invert_color$1 $reset_escape\n/;
	return $line;
	my $line              = shift(); # Array passed in by reference
	my $columns_to_remove = shift(); # Don't remove any lines by default
	if ($columns_to_remove == 0) {
		return $line; # Nothing to do
	$line =~ s/^(${ansi_color_regex})[ +-]{${columns_to_remove}}/$1/;

	return $line;