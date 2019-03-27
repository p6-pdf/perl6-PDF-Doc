use v6;
use PDF::COS::Array;
use PDF::COS::Dict;
use PDF::COS::Stream;
use PDF::COS::Tie::Array;
use PDF::COS::Tie::Hash;
use PDF::Content::XObject;

my Set $std-methods .= new: flat( <cb-init cb-check cb-finish type subtype <anon> delegate-function delegate-shading>, (PDF::COS::Stream, PDF::COS::Array).map: *.^methods>>.name);
my Set $stream-accessors .= new: <Length Filter DecodeParms F FFilter FDecodeParms DL>;

my %classes;

sub scan-classes($path) {

    for $path.dir.sort {
        next if /[^|'/']['.'|t|Type|Loader]/;
        if .d {
            scan-classes($_);
        }
        else {
            next unless /'.pm''6'?$/;
            my @class = .Str.split('/');
            @class.shift;
            next if @class[*-2] eq 'Class';
            @class.tail ~~ s/'.pm'$//;
            my $name = @class.join: "::";

            %classes{$name} = True;
        }
    }
    # delete base clasess
    %classes.keys.map: {
        my @c = .split('::'); @c.pop;
        %classes{@c.join('::')}:delete;
    }
}

sub MAIN(:$class is copy) {
    $class //= do {
        scan-classes('lib'.IO);
        %classes.keys
    }
    for $class.list.sort({ when 'PDF::Class' {'A'}; when 'PDF::Catalog' {'B'}; default {$_}}) -> $name {
        my $class = (require ::($name));

        my $type = do given $class {
            when PDF::COS::Array|PDF::COS::Tie::Array  {'array'}
            when PDF::COS::Stream|PDF::Content::XObject {'stream'}
            when PDF::COS::Dict|PDF::COS::Tie::Hash   {'dict'}
            default {
                warn "ignoring class: $name ({$type.perl})";
                next;
            }
        };

        my $doc = $class.WHY // '';
        my @interfaces = $class.^roles.grep({.^name ~~ /^ISO_32000/}).list;
        my @see-also = @interfaces.map: *.^name;

        my @accessors = $class\
            .^attributes\
            .grep({.can('entry') || .can('index')})\
            .unique(:as(*.tied.accessor-name))\
            .map({my $name = .tied.accessor-name; $name ~= "($_)" with .tied.alias; $name })\
            .grep(* ∉ $stream-accessors).sort;

        my @methods = $class.^methods.map(*.name).grep(* ∉ $std-methods).sort.unique;
        say "$name | $type | {@accessors.join: ', '} | {@methods.join: ', '} | $doc | {@see-also.join: ' '}";

    }

    say '';
    say '*(generated by `etc/make-quick-ref.pl`)*';
}

