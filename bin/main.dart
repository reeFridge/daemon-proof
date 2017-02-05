import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

void main(List<String> args) {
	stdout.writeln('[DAEMON-PROOF] Runs daemon and close.');
	File lockfile = new File('./daemon.lock');
	lockfile.exists().then((bool exist) {
		if (exist) {
			int daemon_pid = int.parse(lockfile.readAsStringSync());
			stdout.writeln('Daemon already runing.');
			exit(0);
		} else {
			Process.start(
				'dart',
				['./bin/daemon.dart'],
				mode: ProcessStartMode.DETACHED,
				includeParentEnvironment: false
			).then((Process proc) {
				stdout.writeln('Daemon runs with pid: ${proc.pid}');
				lockfile.writeAsStringSync(proc.pid.toString());
				exit(0);
			});
		}
	});
}