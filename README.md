<pre>
 _____ _____ _____ _____ __ __
|  |  |  |  | __  | __  |  |  |
|     |  |  |    -|    -|_   _|
|__|__|_____|__|__|__|__| |_|
 _____ _____ _____ __    _____
|     |  _  |  _  |  |  |   __|
| | | |     |   __|  |__|   __|
|_|_|_|__|__|__|  |_____|_____|
 __    _____ ____
|  |  |  _  |    \   ___ ___ _____
|  |__|     |  |  |_|  _| . |     |
|_____|__|__|____/|_|___|___|_|_|_|
</pre>

[![Build Status](http://img.shields.io/travis/hurrymaplelad/hmlad.com/master.svg?style=flat-square)](https://travis-ci.org/hurrymaplelad/hmlad.com)

Getting Started
---------------

    > npm install
    > gulp open

Writing A New Post
------------------

    > gulp new:post

When it looks about right, merge into master and let Travis run tests do the publishing.

Running Tests
-------------

    > gulp spec

Runs a few selenium-webdriver powered integration tests and crawls the
site for broken links.

Manually Publishing
-------------------

    > gulp publish

Runs tests pushes to gh-pages.  Usually Travis will do this automatically for
passing master builds, but you can always do it manually.
