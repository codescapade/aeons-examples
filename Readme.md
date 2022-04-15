# Aeons Examples

This is a repository with examples of features and demos for [Aeons Engine](https://github.com/codescapade/aeons).  

You can see the examples working on [https://codescapade.github.io/aeons-examples](https://codescapade.github.io/aeons-examples).  

This is a work in progress. More examples will be added soon.


## Building the site
Neko is used to run the build tool. This comes with [Haxe](https://haxe.org).
Run `neko tools/BuildExamples` to build all examples and generate the site.

Examples with a `.draft` file in the root directory will be skipped.

Example pages in the `site/examples/` folders that have `eleventyExcludeFromCollections: true` and `permalink: false` front matter
will be excluded from the site.