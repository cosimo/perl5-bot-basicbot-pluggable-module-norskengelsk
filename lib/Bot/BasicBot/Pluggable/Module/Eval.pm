package Bot::BasicBot::Pluggable::Module::Eval;

use warnings;
use strict;
use Safe;
use parent 'Bot::BasicBot::Pluggable::Module';

our $VERSION = '0.02';

sub init {
    my $self = shift;
    $self->config( { permit => [':default'] } );
}

sub told {
    my ( $self, $message ) = @_;
    my $body = $message->{body};
    my ( $command, $rest ) = split( ' ', $body, 2 );

    if ( $command eq 'perl' ) {
        my ( $subcommand, $args ) = split( ' ', $rest, 2 );
        if ( $subcommand eq 'eval' ) {
            $self->bot->forkit(
                run       => \&evaluate,
                arguments => [ $args, @{ $self->get('permit') } ],
                channel => $message->{channel},
                who => $message->{who},
                address => $message->{address},
            );
            return 1;

        }
     }
     return;
}

sub evaluate {
    my ( $body, $code, @op_codes ) = @_;
    my $cpt = Safe->new();
    $cpt->permit(@op_codes);
    $cpt->reval($code) or print "$@";
    print "\n";
}

sub help {
	return "Evaluate perl code. Usage: perl eval <code>."
}
	
1;
__END__

=head1 NAME

Bot::BasicBot::Pluggable::Module::Eval - Evaluate perl code in your channel

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

This module evaluate any perl code and returns the output to the
questioner. The code is run in a forked process, so the bot is still
active while running the code. This module uses Safe to sandbox the
running code, so please refer to its documentation for any security
implications.

This module does not print the return code of the executed code back to
the channel, so you have to handle this yourself.

    !load Eval
    perl eval print "foo"
    perl eval foreach (qw(foo bar)) { print }

=head1 AUTHOR

Mario Domgoergen, C<< <dom at math.uni-bonn.de> >>

=head1 BUGS

Please report any bugs or feature requests
to C<bug-bot-basicbot-pluggable-module-eval
at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Bot-BasicBot-Pluggable-Module-Eval>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 TODO

=over 4

=item

Long running compartments

=item

More tests, but i need to patch Test::Bot::BasicBot::Pluggable
fist as it is not able to emulate forkit in the moment.

=back


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Bot::BasicBot::Pluggable::Module::Eval


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Bot-BasicBot-Pluggable-Module-Eval>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Bot-BasicBot-Pluggable-Module-Eval>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Bot-BasicBot-Pluggable-Module-Eval>

=item * Search CPAN

L<http://search.cpan.org/dist/Bot-BasicBot-Pluggable-Module-Eval>

=back


=head1 SEE ALSO

L<Bot::BasicBot::Pluggable>, L<Safe>


=head1 COPYRIGHT & LICENSE

Copyright 2009 Mario Domgoergen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Bot::BasicBot::Pluggable::Module::Eval
