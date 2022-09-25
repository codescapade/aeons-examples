
let project = new Project('bunnies');

project.addAssets('assets/**', {
  nameBaseDir: 'assets',
  destination: '{dir}/{name}',
  name: '{dir}/{name}'
});

project.icon = 'icon.png';

project.addShaders('shaders/**');

project.addSources('source');


project.addLibrary('aeons');


project.addParameter('-dce full');

project.targetOptions.html5.disableContextMenu = true;
project.targetOptions.html5.canvasId = 'aeonsGame';
project.targetOptions.html5.scriptName = 'aeons';


resolve(project);