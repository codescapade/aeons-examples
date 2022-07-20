
let project = new Project('bitmap-font');

project.addAssets('assets/**', {
  nameBaseDir: 'assets',
  destination: '{dir}/{name}',
  name: '{dir}/{name}'
});

project.icon = 'icon.png';

project.addShaders('shaders/**');

project.addSources('source');

project.addLibrary('aeons');





resolve(project);