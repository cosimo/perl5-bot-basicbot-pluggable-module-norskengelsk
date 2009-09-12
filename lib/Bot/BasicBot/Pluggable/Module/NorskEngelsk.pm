# $Id$

package Bot::BasicBot::Pluggable::Module::NorskEngelsk;

use base qw(Bot::BasicBot::Pluggable::Module::Base);

use strict;
use CGI ();
use HTML::Entities ();
use LWP::Simple ();
use LWP::UserAgent ();
use WebService::Google::Language ();

our $VERSION = '0.02';

our $GWS;
our $URL = 'http://www.google.com/translate_t?sl=no&dl=en&text=%s';

sub help {
    return "Will try to translate when it finds some norwegian word in the message";
}

sub said {
    my ($self, $mess, $pri) = @_;

    # Changed to pri 2 to allow other modules to be called
    return unless ($pri == 2);

    # Stay silent
    if (! $self->looks_like_norwegian($mess->{body})) {
        return;
    }

    my $translated = $self->t($mess->{body});

    if (! defined $translated || $translated eq '') {
        return;
    }

	# Reply publicly in channel
    $self->tell($mess->{channel}, $translated);

    return 0;
}

sub t {
    my ($self, $text) = @_;

    my $translated;
    my $url = sprintf $URL, CGI->escape($text);

    my $ua = LWP::UserAgent->new();
    $ua->agent('Opera/9.64 (Macintosh; Intel Mac OS X; U; en)');
    my $rsp = $ua->get($url);

    if ($rsp->is_success()) {
        $translated = $rsp->content();
        if ($translated =~ m{<div id=result_box dir="ltr">([^<]*)</div>}ms) {
            $translated = $1;
        }
    }

    if (! $translated || $translated eq $text) {
        return;
    }

    chomp $translated;

    HTML::Entities::decode_entities($translated);

    return $translated;
}

sub looks_like_norwegian {
    my ($self, $text) = @_;

    my $service = $self->service();
    my $result = $service->detect($text);

    if (! $result || $result->error) {
        return;
    }

    # Not norwegian. Sometimes no can be detected as da.
    #warn('$result->language='.$result->language());
    my $lng = $result->language();
    if ($lng ne 'no' && $lng ne 'da') {
        #warn($text .' not norwegian');
        return;
    }

    #warn('$result->translate='.$result->translation());
    return 1;
}

sub service {
    return $GWS ||= WebService::Google::Language->new(
        referer => 'http://search.cpan.org/dist/Bot-BasicBot-Pluggable-Module-NorskEngelsk/',
        src     => 'no',
        dest    => 'en',
    );
}

1;


__END__


=head1 NAME

Bot::BasicBot::Pluggable::Module::NorskEngelsk - Translate Norwegian into English

=head1 SYNOPSIS

Load this plugin into your C<Bot::BasicBot::Pluggable>-based IRC bot, and
magically all the Norwegian text will be automatically translated into
English.

I needed this module since I'm working in Norway, and sometimes people
write Norwegian words or sentences in the IRC channels, and I would
really like to understand, so I just wrote this IRC bot that helped me
a bit.

The translation B<magic> bit comes from the translator web-service by Google.
I named my bot B<blaah>. If you use this module, you can follow the
tradition and name your bot B<blaah> too. :-)

Example:

    person1: I would like to send you to YAPC this year
	person2: oh, du er så flott
	blaah  : oh, you are so great
    person1: thanks!

Yes, C<blaah> should be silent if nobody speaks norwegian in the channel.

=head1 BUGS

Please report any bugs or feature requests to:

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Bot-BasicBot-Pluggable-Module-NorskEngelsk>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Bot::BasicBot::Pluggable::Module::NorskEngelsk

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Bot-BasicBot-Pluggable-Module-NorskEngelsk>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Bot-BasicBot-Pluggable-Module-NorskEngelsk>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Bot-BasicBot-Pluggable-Module-NorskEngelsk>

=item * Search CPAN

L<http://search.cpan.org/dist/Bot-BasicBot-Pluggable-Module-NorskEngelsk>

=back


=head1 SEE ALSO

L<Bot::BasicBot::Pluggable>

L<WebService::Google::Language>

=head1 AUTHOR

Cosimo Streppone, L<mailto:cosimo@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Cosimo Streppone, L<mailto:cosimo@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

