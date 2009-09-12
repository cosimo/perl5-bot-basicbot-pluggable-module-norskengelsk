use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Bot::BasicBot::Pluggable::Module::NorskEngelsk',
    VERSION_FROM      => 'lib/Bot/BasicBot/Pluggable/Module/NorskEngelsk.pm',
    PREREQ_PM         => {
		'Bot::BasicBot::Pluggable' => 0,
		'CGI' => 0,
		'HTML::Entities' => 0,
		'LWP::Simple' => 0,
		'LWP::UserAgent' => 0,
		'Test::More' => 0,
		'WebService::Google::Language' => 0,
	},
    ABSTRACT_FROM  => 'lib/Bot/BasicBot/Pluggable/Module/NorskEngelsk.pm',
    AUTHOR         => 'Cosimo Streppone <cosimo@cpan.org>'
);

