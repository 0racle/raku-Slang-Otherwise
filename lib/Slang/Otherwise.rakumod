my role Otherwise::Grammar {
    rule statement-control:sym<for> {
        <.block-for><.kok> {}
        <.vetPerlForSyntax>
        :my $*GOAL := '{';
        :my $*BORG := {};
        <EXPR>
        <pointy-block>
        [ otherwise $<otherwise>=<.pointy-block> ]?
    }
}
my role Otherwise::Actions {
    method statement-control:sym<for>(Mu $/) {
        if $<otherwise> -> $otherwise {
            callsame.replace-otherwise($otherwise.ast);
        }
    }
}

my role Otherwise::Grammar::Legacy {
    rule vetPerlForSyntax {
        [ <?before 'my'? '$'\w+\s+'(' >
            <.typed_panic: 'X::Syntax::P5'> ]?
        [ <?before '(' <.EXPR>? ';' <.EXPR>? ';' <.EXPR>? ')' >
            <.obs('C-style "for (;;)" loop', '"loop (;;)"')> ]?
    }

    rule statement_control:sym<for> {
        <sym><.kok> {}
        <.vetPerlForSyntax>
        <xblock(2)> {}
        [ otherwise <elseblock=pblock> ]?
    }
}

my role Otherwise::Actions::Legacy {
    method statement_control:sym<for>(Mu $/) {
        my $forloop := callsame;
        if $<elseblock> -> $elseblock {
            use QAST:from<NQP>;
            make QAST::Op.new: :op<unless>,
              $forloop,
              QAST::Op.new: :op<call>,
                $elseblock.ast;
        }
    }
}

use Slangify Otherwise::Grammar, Otherwise::Actions,
  Otherwise::Grammar::Legacy, Otherwise::Actions::Legacy;
