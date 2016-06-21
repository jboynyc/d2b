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

This is a work in progress.
