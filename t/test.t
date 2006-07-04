use Test::More qw[no_plan];
use strict;
$^W = 1;

BEGIN {
    use_ok 'Email::Reply';
    use_ok 'Email::Simple';
    use_ok 'Email::Simple::Creator';
    use_ok 'Email::MIME::Modifier';
    use_ok 'Email::Address';
}

my $response = <<__RESPONSE__;
Welcome to Earth!
__RESPONSE__

my $simple = Email::Simple->create(
    header => [
        To      => Email::Address->new(undef, 'casey@geeknest.com'),
        From    => 'alien@titan.saturn.sol',
        Subject => 'Ping',
    ],
    body => <<__MESSAGE__ );
Are you out there?


-- 
The New Ones
__MESSAGE__

my $reply = reply to => $simple, body => $response;

$reply->header_set(Date => undef);

is $reply->as_string, <<'__MESSAGE__', 'simple reply matches';
From: <casey@geeknest.com>
To: <alien@titan.saturn.sol>
Subject: Re: Ping

alien wrote:
> Are you out there?

Welcome to Earth!

__MESSAGE__

$simple->header_set(Date => undef);
$simple->header_set(Cc => 'martian@mars.sol, "Casey" <human@earth.sol>');
$simple->header_set('Message-ID' => '1232345@titan.saturn.sol');
my $complex = reply to         => $simple,
                    from       => Email::Address->new('Casey West', 'human@earth.sol'),
                    all        => 1,
                    self       => 1,
                    attach     => 1,
                    top_post   => 1,
                    keep_sig   => 1,
                    prefix     => '%% ',
                    attrib     => 'Quoth the raven:',
                    body       => $response;
$complex->header_set(Date => undef);
$complex->header_set('Content-ID' => undef);
$complex->boundary_set('boundary42');
$complex->parts_set([map {$_->header_set(Date=>undef);$_} $complex->parts]);
$complex->parts_set([map {$_->header_set('Content-ID'=>undef);$_} $complex->parts]);
is $complex->as_string, <<'__COMPLEX__', 'complex reply matches';
From: Casey West <human@earth.sol>
To: <alien@titan.saturn.sol>
Subject: Re: Ping
In-Reply-To: <1232345@titan.saturn.sol>
References: <1232345@titan.saturn.sol>
Cc: <casey@geeknest.com>, <martian@mars.sol>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="boundary42"; charset="us-ascii"


--boundary42
MIME-Version: 1.0

Welcome to Earth!

Quoth the raven:
%% Are you out there?
%% 
%% 
%% -- 
%% The New Ones




--boundary42
MIME-Version: 1.0
Content-Type: message/rfc822; charset="us-ascii"

To: <casey@geeknest.com>
From: alien@titan.saturn.sol
Subject: Ping
Cc: martian@mars.sol, "Casey" <human@earth.sol>
Message-ID: 1232345@titan.saturn.sol

Are you out there?


-- 
The New Ones





--boundary42--
__COMPLEX__

$complex->header_set('Message-ID' => '4506957@earth.sol');
my $replyreply = reply to => $complex, body => $response;
$replyreply->header_set(Date => undef);
is $replyreply->as_string, <<'__REPLY2__', 'reply to reply matched';
From: <alien@titan.saturn.sol>
To: Casey West <human@earth.sol>
Subject: Re: Ping
In-Reply-To: <4506957@earth.sol>
References: <1232345@titan.saturn.sol> <4506957@earth.sol>

Casey West wrote:
> Welcome to Earth!
> 
> Quoth the raven:
> %% Are you out there?
> %% 
> %% 
> %% -- 
> %% The New Ones

Welcome to Earth!

__REPLY2__

