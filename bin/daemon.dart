import 'dart:io';
import 'dart:core';

void main(List<String> args) {
	ProcessSignal.SIGUSR1.watch().listen((sig) => exit(0));
	ProcessSignal.SIGTERM.watch().listen((ProcessSignal sig) {
		File pidFile = new File('./pidfile');
		pidFile.exists().then((bool exist) {
			if (exist) {
				pidFile.deleteSync();
			}
			exit(0);
		});
	});
}