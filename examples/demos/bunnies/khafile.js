// A new Kha project.
let project = new Project('bunnies');

// Make it possible to have the same file name in different folders.
project.addAssets('assets/**', {
    nameBaseDir: 'assets',
    destination: '{dir}/{name}',
    name: '{dir}/{name}'
});

// Shader folder.
project.addShaders('shaders/**');

// Source folder.
project.addSources('source');

// Add the Aeons engine.
project.addLibrary('aeons');

project.addParameter('-dce full');

project.targetOptions.html5.disableContextMenu = true;
project.targetOptions.html5.canvasId = 'aeonsGame';
project.targetOptions.html5.scriptName = 'aeons';

resolve(project);