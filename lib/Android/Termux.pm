package Android::Termux;
use strict;
use 5.26; # latest available on Termux

use Exporter 'import';

no warnings 'experimental::signatures';
use feature 'signatures';

use JSON 'decode_json';

sub run( @cmd ) {
    open my $fh, '-|', @cmd
        or die "Couldn't spawn [@cmd]: $! / $?"
    binmode $fh, ':raw';
    return join '', <$fh>;
}

sub run_json( @cmd ) {
    decode_json( run( @cmd ))
}

sub termux_info() {
    run( 'termux_info' )
}

sub contact_list() {
    run_json( 'termux_contact_list' )
}

sub wifi_connectioninfo() {
    run_json( 'termux_wifi_connectioninfo' )
}

sub wifi_scaninfo() {
    run_json( 'termux_wifi_scaninfo' )
}

sub camera_info() {
    run_json( 'termux_camera_info' )
}

sub camera_photo(%options) {
    $options{ camera_id } //= 0;
    run_json( 'termux_camera_photo', '-c', $options{ camera_id } )
}


1;

=head1 ANDROID PERMISSIONS

Whenever Termux first needs a permission, the request will fail with a result
of

  { error: "Permission..." }

Your program should handle that situation gracefully and try again after
the user had time to grant the permission.

=head1 SEE ALSO

L<https://wiki.termux.com/wiki/Termux:API>

=cut