import 'dart:io';
import 'dart:core';

void main(List<String> args) {
	ProcessSignal.SIGUSR2.watch().listen((ProcessSignal sig) {
		File file = new File('./log');
		file.writeAsString('Daemon was received signal $sig');
	});
	
	ProcessSignal.SIGTERM.watch().listen((ProcessSignal sig) {
		File lockfile = new File('./daemon.lock');
		lockfile.exists().then((bool exist) {
			if (exist) {
				int lock_pid = int.parse(lockfile.readAsStringSync());
				if (lock_pid == pid) {
					lockfile.deleteSync();
				}
			}
			exit(0);
		});
	});
}