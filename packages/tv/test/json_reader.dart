import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test') || dir.endsWith(r'\test')) {
    dir = dir.substring(0, dir.length - 5);
  }
  var file = File('$dir/test/$name');
  if (!file.existsSync()) {
    file = File('$dir/$name');
  }
  return file.readAsStringSync();
}
