#!/usr/bin/perl

if ($#ARGV >= $[) {
    $shell = $ARGV[$[];
}

@packagedirs = (
    "/usr/local",
	"/usr/lib/jvm/java-8-oracle",
	"/usr/lib/jvm/java-7-oracle",
#    "/opt/apache-maven-3.2.1",
	"/opt/kde",
	"/opt/ldap",
	"/opt/fax",
	"/opt/cap",
	"/opt/ncd",
	"/opt/mail",
	"/opt/nmh",
	"/opt/spectrum",
	"/opt/www",
	"/opt/noc",
	"/opt/pbm",
	"/opt/krs",
	"/opt/tk",
	"/home/gnats",
	"/opt/openwin",
	"/usr/openwin",
	"/opt/X11",
	"/usr/X11R6",
	"/opt/slate",
	"/opt/gnu",
	"/usr/gnu",
	"/usr/local/gnu",
	"/local/gnu",
	"/opt/games",
	"/news/readers",
	"/opt/local",
    "/home/chk/.krew",
	"/local" );

@pathdirs = (
	# Arch linux perl weirdness
	"/usr/bin/site_perl",
	"/usr/lib/perl5/site_perl/bin",
	"/usr/bin/vendor_perl",
	"/usr/lib/perl5/vendor_perl/bin",
	"/usr/bin/core_perl",
    "/usr/lib/jvm/default/bin",

	"/usr/ucb",
	"/usr/bsd",
	"/usr/bin",
	"/usr/new",
	"/usr/sbin",
	"/sbin",
	"/bin",
	"/usr/games" );

($uid, @rest) = getpwuid($<);
@path=();
@manpath=("/usr/man", "/usr/share/man", "/usr/man/preformat", "/usr/share/man/preformat");
$os = `uname -s`;
chomp($os);

#if ($uid ne "root") {
#    @path=(".");
#}

$realuser=$ENV{'user'};
if ($ENV{'SUDO_USER'}) {
	$realuser = $ENV{'SUDO_USER'};
}

push(@path, glob("~$realuser/bin/[A-Z]*"));

# kubectl plugins
if(-d glob("~${realuser}/.krew/bin")) {
    push(@path, glob("~${realuser}/.krew/bin"));
}

if ($uid ne "root") {
    push(@path, glob("~${realuser}/bin/[a-z]*"));
}

foreach $dir (@packagedirs) {
    if (-d "$dir/sbin") {
	push(@path, "$dir/sbin");
    }
    if (-d "$dir/bin") {
	push(@path, "$dir/bin");
    }
    if (-d "$dir/man") {
	push(@manpath, "$dir/man");
    }
    if (!defined($pager) && -x "$dir/bin/less") {
	$pager = "$dir/bin/less";
    }
    if (!defined($editor) && -x "$dir/bin/jove") {
	$editor = "$dir/bin/jove";
    }
}

foreach $dir (@pathdirs) {
    if (-d $dir && ! -l $dir) {
	push(@path, $dir);
    }
    if (!defined($pager) && -x "$dir/less") {
	$pager = "$dir/less";
    }
    if (!defined($editor) && -x "$dir/jove") {
	$editor = "$dir/jove";
    }
}

push(@manpath, "/home/$realuser/man");

if ($shell eq "sh" || $shell eq "ksh" || $shell eq "bash") {
    print "PATH=". join(":", @path) . "; export PATH;\n";
    if (defined($pager)) {
	print "PAGER=$pager; export PAGER;\n";
	print "MANPAGER=\"$pager -is\"; export MANPAGER;\n";
    }
    if (defined($editor)) {
	print "EDITOR=$editor; export EDITOR;\n";
	print "VISUAL=$editor; export VISUAL;\n";
    }
    print "MANPATH=\"". join(":", @manpath) . "\"; export MANPATH;\n";
}
else {
    print "set path=(", join(" ",@path), ")\n";
    print "setenv MANPATH ". join(":", @manpath) . "\n";
    if (defined($pager)) {
	print "setenv PAGER $pager\n";
	print "setenv MANPAGER \"$pager -is\"\n";
    }
    if (defined($editor)) {
	print "setenv EDITOR $editor\n";
	print "setenv VISUAL $editor\n";
    }
}
