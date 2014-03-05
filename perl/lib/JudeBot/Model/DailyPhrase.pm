package JudeBot::Model::DailyPhrase;

use strict;
use warnings;
use LWP::Curl;
use Moose;
use Date::Format;
use JSON::PP;
use FindBin;

has 'api' => ( is=>'rw',default => 'http://www.ihbristol.com/english-phrases' );
has 'article_url' => ( is=>'ro', default => 'http://www.ihbristol.com/english-phrases/example/' );
has 'datapath' => ( is=>'rw', default => 'public/english/phrase-of-today.json' );


sub get_data {
    my $self = shift;
    my $data = $self->_parse();
    my $encoded_json = encode_json $data;

    open (DATAFILE, '> '.$self->datapath);
    print DATAFILE $encoded_json;
    close(DATAFILE);
    return $data;
}
sub _parse {
    my $self = shift;

    my $lwpcurl = LWP::Curl->new();
    my $content = $lwpcurl->get($self->api);
    my $obj;

    $content =~ m/class\="colorb\">(.+)<\/p>/;
    $obj->{phrase} = $1;

    $content =~ m/<em>(.+)<\/em>/;
    $obj->{desc} = $1;

    $obj->{timestamp} = time;

    $obj->{url} = $self->article_url . time2str('%Y-%m-%d', time);

    return $obj;
}

1;
