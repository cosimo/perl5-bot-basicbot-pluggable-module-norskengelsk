use strict;
use warnings;
use Test::Bot::BasicBot::Pluggable;
use Test::More tests => 2;

ok ( my $bot = Test::Bot::BasicBot::Pluggable->new(), 'creating bot' );
ok ( $bot->load('Eval'), 'loading eval' );
# is ( $bot->tell_public('print 1 + 1') , '', 'adding one to one');

0;
