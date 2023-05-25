NAME
====

Slang::Otherwise - Slang to add 'otherwise' block to 'for' loops

SYNOPSIS
========

This slang adds syntax for an `otherwise` block that will run if the for loop is not entered.

```raku
use Slang::Otherwise;

for dir.grep(*.basename.contains: 'xyx') -> $f {
    say "Found $f"
}
otherwise {
    say 'Got nothing'
}
```

CREDITS & NOTES
===============

This code is shamelessly taken from a [blog post by Damian Conway](https://blogs.perl.org/users/damian_conway/2019/09/itchscratch.html).

Damian's slang called the block `else`, but the post spawned some discussion about whether that is a good name, also taking into consideration that Python's `for`/`else` does something entirely different. In [commenting on the article](https://www.reddit.com/r/perl6/comments/d5u1mv/itchscratch_damian_conway/), several people suggested `otherwise`, which is a good a name as any.

LICENCE
=======

    The Artistic License 2.0

See LICENSE file in the repository for the full license text.
