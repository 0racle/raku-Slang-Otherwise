role Otherwise::Grammar {

    rule statement_control:sym<for> {
        <sym><.kok> {}
        <.vetPerl5Syntax>
        <xblock(2)> {}
        [ 'otherwise' <elseblock=pblock> ]?
    }

    rule vetPerl5Syntax {
        [ <?before 'my'? '$'\w+\s+'(' >
            <.typed_panic: 'X::Syntax::P5'> ]?
        [ <?before '(' <.EXPR>? ';' <.EXPR>? ';' <.EXPR>? ')' >
            <.obs('C-style "for (;;)" loop', '"loop (;;)"')> ]?
    }

}

role Otherwise::Actions {
    use nqp;
    use QAST:from<NQP>;

    sub lookup(Mu \match, \key) {
        nqp::atkey(
            nqp::findmethod(match, 'hash')(match),
            key
        ).?ast
    }

    method statement_control:sym<for> (Mu $match) {
        my $forloop := callsame;
        if lookup($match, 'elseblock') -> $elseblock {
            $match.make:
                QAST::Op.new: :op<unless>, $forloop,
                QAST::Op.new: :op<call>,   $elseblock
        }
    }

}

sub EXPORT {
    $*LANG.define_slang:
        "MAIN",
        $*LANG.slangs<MAIN>         but Otherwise::Grammar,
        $*LANG.slangs<MAIN-actions> but Otherwise::Actions;

    return hash();
}
