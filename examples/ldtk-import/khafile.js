// A new Kha project.
let project = new Project('ldtk-import');

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

// Enable lDtk support.
project.addDefine('use_ldtk');
project.addLibrary('ldtk-haxe-api');
project.addLibrary('deepnightLibs');

resolve(project);