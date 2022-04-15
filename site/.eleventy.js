const syntaxHighlight = require('@11ty/eleventy-plugin-syntaxhighlight');
const markdownIt = require('markdown-it');

const MARKDOWN_OPTIONS = {
    html: true,
    breaks: false,
    linkify: true
};
const markdownLibrary = markdownIt(MARKDOWN_OPTIONS);

module.exports = (config) => {
  config.addPlugin(syntaxHighlight);
  config.addPassthroughCopy('src/static');
  config.addPassthroughCopy('src/thumbnails');
  config.addPassthroughCopy({'src/exampleFiles': 'examples'});

  config.setLibrary("md", markdownLibrary);

  config.addCollection('examples', (collection) => {
    return collection.getFilteredByGlob('./src/examples/**/*.md');
  });

  return {
    markdownTemplateEngine: 'njk',
    dataTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',
    dir: {
      input: 'src',
      output: '../docs'
    }
  };
};
