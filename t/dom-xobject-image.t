use v6;
use Test;

plan 13;

use PDF::DOM::Type;
use PDF::Storage::IndObj;
use PDF::Grammar::Test :is-json-equiv;
use PDF::Grammar::PDF;
use PDF::Grammar::PDF::Actions;

my $actions = PDF::Grammar::PDF::Actions.new;

my $input = q:to"--END-OBJ--";
14 0 obj
<<
/Intent/RelativeColorimetric
/Type/XObject
/ColorSpace/DeviceGray
/Subtype/Image
/Name/X
/Width 2988
/BitsPerComponent 8
/Length 13
/Height 2286
/Filter/DCTDecode
>>
stream
(binary data)
endstream
endobj
--END-OBJ--

PDF::Grammar::PDF.parse($input, :$actions, :rule<ind-obj>)
    // die "parse failed";
my $ast = $/.ast;
my $ind-obj = PDF::Storage::IndObj.new( |%$ast, :$input);
is $ind-obj.obj-num, 14, '$.obj-num';
is $ind-obj.gen-num, 0, '$.gen-num';
my $ximage-obj = $ind-obj.object;
isa-ok $ximage-obj, ::('PDF::DOM::Type')::('XObject::Image');
is $ximage-obj.Type, 'XObject', '$.Type accessor';
is $ximage-obj.Subtype, 'Image', '$.Subtype accessor';
is-json-equiv $ximage-obj.ColorSpace, 'DeviceGray', '$.ColorSpace accessor';
is-json-equiv $ximage-obj.BitsPerComponent, 8, '$.BitsPerComponent accessor';
is $ximage-obj.encoded, "(binary data)", '$.encoded accessor';

my $snoopy = ::('PDF::DOM::Type')::('XObject::Image').open("t/images/snoopy-happy-dance.jpg");
is $snoopy.Width, 200, '$img.Width (jpeg)';
is $snoopy.Height, 254, '$img.Height (jpeg)';
is-deeply $snoopy.ColorSpace, (:name<DeviceRGB>), '$img.ColorSpace (jpeg)';
is $snoopy.BitsPerComponent, 8, '$img.BitsPerComponent (jpeg)';
is $snoopy.Length, $snoopy.encoded.chars, '$img Length (jpeg)';
