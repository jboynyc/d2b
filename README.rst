``d2b``
=======

A tool that looks up a DOI and constructs an appropriate BibLaTeX entry.

::

    $ echo 10.1007/s11186-011-9161-5 | d2b
    @article{TODO,
        author = {Richard Swedberg},
        title = {Theorizing in sociology and social science},
        subtitle = {Turning to the context of discovery},
        journaltitle = {Theory and Society},
        volume = {41},
        number = {1},
        date = {2011-11-11},
        pages = {1--40},
        doi = {10.1007/s11186-011-9161-5},
    }

    $ d2b < my-dois.txt > my-references.bib

This is a work in progress. (*Abandoned at this point...*)

Installing ``d2b``
------------------

The only non-standard prerequisite to building ``d2b`` is Chicken
Scheme, available on `many
platforms <https://wiki.call-cc.org/platforms>`__.

::

    $ make
    $ make install # installs in /usr/local by default
    $ make install PREFIX=$HOME/.local
    $ make clean
