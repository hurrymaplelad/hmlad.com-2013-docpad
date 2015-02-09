---
title: Generate Perfectly Aligned SVG Diagrams with LaTeX
template: post
---

![Concept map](/images/latex-diagrams/concept-map.svg)

Just tried out the [Mermaid package](http://knsv.github.io/mermaid/index.html), promising diagrams at the speed of Markdown, built on modern tools like D3.  I was a little disappointed.

<!-- more -->

In my head I had a graph like this:

![](/images/latex-diagrams/simple.svg)


but Mermaid spat out:

![](/images/latex-diagrams/simple.mermaid.svg)

given this graph description:

```
graph LR
  subgraph N
  a --- b
  b --- c
  end

  subgraph M
  d --- e
  e --- f
  end

  a --- d
  a --- e
```

Disappointing results.  What were my other options?

GUIs?
-----

I've whipped together a few diagrams in Google Docs:

![](http://hurrymaplelad.com/images/speed-up-your-responsive-app-with-node-and-varnish/flow.jpg)

But they're not very pretty.  All those little inconsistent spaces and rotations are distracting.

LaTeX!
------
Anyone else have fond memories of typesetting state machines?

![old state machine](/images/latex-diagrams/state-machine.svg)

Señor Knuth put [10+ years](https://www.tug.org/whatis.html) into making the TeX typesetting system capable of producing perfect documents, and some folks recently added fancy [automatic graph layout algorithms](https://fosdem.org/2015/schedule/event/algorithmic_graph_drawing_in_tikz/attachments/slides/621/export/events/attachments/algorithmic_graph_drawing_in_tikz/slides/621/2014_fosdem_talk.pdf).

As usual, it took longer than I expected to try 'em out, but these commands got me started on OSX, with [homebrew](http://brew.sh/) installed:

```sh
$ brew cask install basictex  # the minimal TeX distro
# add /usr/texbin to $PATH    # so we can use tlmgr
$ sudo chown -R adam:staff /usr/local/texlive # without sudo
$ tlmgr update --self
$ tlmgr install standalone    # generate just a picture
$ tlmgr install dvisvgm       # generates SVGs from DVIs
$ brew install ghostscript    # using ghostscript
$ lualatex --output-format=dvi <diagram>.tex
$ dvisvgm \
$  --libgs=/usr/local/lib/libgs.dylib \ # needs help finding the homebrew install
$  <diagram>.dvi
```

I wrapped up the last few commands, rendering a .tex file to an .svg, in a bash script and [threw it on github](https://github.com/hurrymaplelad/texvg).

It took me a while to figure out that the `graphdrawing` package [defaults to `Cartesian placement`](http://www.tcs.uni-luebeck.de/downloads/papers/2011/2011-configurable-graph-drawing-algorithms-jannis-pohlmann.pdf) if we don't specify a graph layout algorithm, which

> starts with the first node and arranges the others by
moving either along the grow axis or branch axis, depending on whether a node belongs to the
same node chain or a different chain group.

With `Cartesian placement`, we can adjust spacing between the nodes using `\graph [grow right=4em, branch down=4em]`.  Here's the [1000+ page manual](http://texdoc.net/texmf-dist/doc/generic/pgf/pgfmanual.pdf) on drawing with `tigz` if you want to learn more.

I eventually coaxed the diagram I wanted out LaTeX (shown above) with something like:

```tex
\begin{tikzpicture}
\graph [
  grow right=6em,
  branch down=6em,
  nodes={draw, rectangle, rounded corners}
] {
  a -- b -- c,
  d -- e -- f,
  a -- d, a -- e
};
\end{tikzpicture}
```

After all that, I really just want to see Mermaid support a little more layout customization.

PS, this is my other [favorite giant LaTeX doc](http://ftp.math.purdue.edu/mirrors/ctan.org/info/symbols/comprehensive/symbols-a4.pdf).  It has magic Icelandic staves.
