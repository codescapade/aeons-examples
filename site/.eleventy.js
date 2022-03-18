
module.exports = (config) => {
  config.addPassthroughCopy('src/static');
  config.addPassthroughCopy({'src/exampleFiles': 'examples'});
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
