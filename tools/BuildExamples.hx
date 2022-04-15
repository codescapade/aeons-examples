package;

import haxe.Exception;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;
import haxe.io.Path;

using StringTools;

class BuildExamples {

  static function main() {
    var sourcePath = Path.join([Sys.programPath(), '../../examples/features']);
    var outPath = Path.join([Sys.programPath(), '../../site/src/exampleFiles/features']);
    buildExamples(sourcePath, outPath);

    sourcePath = Path.join([Sys.programPath(), '../../examples/demos']);
    outPath = Path.join([Sys.programPath(), '../../site/src/exampleFiles/demos']);
    buildExamples(sourcePath, outPath);
    

    final sitePath = Path.join([Sys.programPath(), '../../site']);
    Sys.setCwd(sitePath);
    runCommand('', 'npx', ['@11ty/eleventy']);
  }

  static function buildExamples(sourcePath: String, outPath: String) {
    final folders = FileSystem.readDirectory(sourcePath);
    if (FileSystem.exists(outPath)) {
      deleteDir(outPath);
    }

    final docsPath = Path.join([Sys.programPath(), '../../docs']);
    if (FileSystem.exists(docsPath)) {
      deleteDir(docsPath);
    }

    FileSystem.createDirectory(outPath);

    final haxelibPath = getHaxelibPath('aeons');
    final makePath = Path.join([haxelibPath, 'lib/Kha/make.js']);
    for (folder in folders) {
      final path = Path.join([sourcePath, folder]);
      final draftPath = Path.join([path, '.draft']);
      if (FileSystem.exists(draftPath)) {
        continue;
      }
      
      final buildPath = Path.join([path, 'build']);
      if (FileSystem.exists(buildPath)) {
        deleteDir(buildPath);
      }
      Sys.setCwd(path);
      
      runCommand('', 'node', [makePath, 'html5']);
      FileSystem.deleteFile('build/html5/index.html');

      final outFolder = Path.join([outPath, folder]);
      FileSystem.createDirectory(outFolder);
      copyDir('build/html5', outFolder);

      if (FileSystem.exists(buildPath)) {
        deleteDir(buildPath);
      } 
    }
  }

  /**
   * Find the location of a haxelib library.
   * @param name The library to find.
   * @return The location path.
   */
  static function getHaxelibPath(name: String): String {
		final proc = new Process('haxelib', ['path', name]);
		var result = '';

		try {
			var previous = '';
			while (true) {
				final line = proc.stdout.readLine();
				if (line.startsWith('-D $name'))
				{
					result = previous;
					break;
				}
				previous = line;
			}
		} catch (e: Dynamic) {

    }

		proc.close();

		return result;
	}

  /**
   * Run a Sys command and restore the working directory after.
   * @param path The path to run the command in.
   * @param command The command to run.
   * @param args A list of command parameters.
   * @param throwErrors Show this throw errors.
   * @return The command status. 0 is success.
   */
  static function runCommand(path: String, command: String, args: Array<String>, throwErrors = true): Int {
    var currentPath = '';
    if (path != null && path != '') {
      currentPath = Sys.getCwd();

      try {
        Sys.setCwd(path);
      } catch (e: Dynamic) {
        trace('cannot set current working directory to %{path}.');
      }
    }

    var result = Sys.command(command, args);
    if (currentPath != '') {
      Sys.setCwd(currentPath);
    }

    if (result != 0 && throwErrors) {
      Sys.exit(1);
    }

    return result;
  }
  
  /**
   * Recursive copy a directory.
   * @param source The source folder.
   * @param destination The destination folder.
   */
  static function copyDir(source: String, destination: String) {
    final files = FileSystem.readDirectory(source);
    for (file in files) {
      final sourcePath = Path.join([source, file]);
      final destinationPath = Path.join([destination, file]);
      if (FileSystem.isDirectory(sourcePath)) {
        FileSystem.createDirectory(destinationPath);
        copyDir(sourcePath, destinationPath);
      } else {
        File.copy(sourcePath, destinationPath);
      }
    }
  }

  /**
   * Delete a folder recursive.
   * @param dir The folder to delete.
   */
  static function deleteDir(dir: String) {
    final files = FileSystem.readDirectory(dir);
    for (file in files) {
      final path = Path.join([dir, file]);
      if (FileSystem.isDirectory(path)) {
        deleteDir(path);
        var newFiles = FileSystem.readDirectory(path);
        if (newFiles.length == 0) {
          FileSystem.deleteDirectory(path);
        }
      } else {
        if (FileSystem.exists(path)) {
          try {
            FileSystem.deleteFile(path);
          } catch (e: Exception) {
            trace(e.toString());
          }
        }
      }
    }
    // FileSystem.deleteFile(dir);
  }
}