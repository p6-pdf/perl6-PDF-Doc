use v6;

use PDF::Object::Dict;
use PDF::Object::Type;

class PDF::DOM::Type::CIDSystemInfo
    is PDF::Object::Dict {

    # see [PDF 1.7 TABLE 5.13 Entries in a CIDSystemInfo dictionary]
    use PDF::Object::Tie;

    has Str $.Registry is entry(:required);   #| A string identifying the issuer of the character collection—for example, Adobe.
    has Str $.Ordering is entry(:required);   #| (Required) A string that uniquely names the character collection within the specified registry—for example, Japan1
    has UInt $.Supplement is entry;           #| (Required) The supplement number of the character collection

}