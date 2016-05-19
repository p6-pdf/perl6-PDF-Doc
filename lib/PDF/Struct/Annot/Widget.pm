use v6;

use PDF::Struct::Annot;

class PDF::Struct::Annot::Widget
    is PDF::Struct::Annot {

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    # See [PDF 1.7 TABLE 8.39 Additional entries specific to a widget annotation]
    subset HName of PDF::DAO::Name where 'N'|'I'|'O'|'P'|'T';
    has HName $.H is entry;            #| (Optional; PDF 1.2) The annotation’s highlighting mode, the visual effect to be used when the mouse button is pressed or held down inside its active area:
                                       #| N(None)    - No highlighting.
                                       #| I(Invert)  - Invert the contents of the annotation rectangle.
                                       #| O(Outline) - Invert the annotation’s border.
                                       #| P(Push)    - Display the annotation as if it were being pushed below the surface of the page;
                                       #| T(Toggle)   - Same as P (which is preferred)
    has Hash $.MK is entry;            #| (Optional) An appearance characteristics dictionary to be used in constructing a dynamic appearance stream specifying the annotation’s visual presentation on the page.
    has Hash $.A is entry;             #| (Optional; PDF 1.1) An action to be performed when the link annotation is activated (see Section 8.5, “Actions”).
    has Hash $.AA is entry;            #| (Optional; PDF 1.2) An additional-actions dictionary defining the annotation’s behavior in response to various trigger events (see Section 8.5.2, “Trigger Events”).
    use PDF::Struct::Border;
    has PDF::Struct::Border $.BS is entry;            #| (Optional; PDF 1.2) A border style dictionary specifying the width and dash pattern to be used in drawing the annotation’s border.
                                       #| Note: The annotation dictionary’s AP entry, if present, takes precedence over the Land BS entries

}