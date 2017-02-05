import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

void main(List<String> args) {
	ArgParser parser = new ArgParser();
	parser.addOption('option', abbr: 'o', allowed: ['kill', 'restart']);
	ArgResults results = parser.parse(args);
	
	File lockfile = new File('./daemon.lock');
	lockfile.exists().then((bool exist) {
		switch (results['option']) {
			case 'kill':
				if (exist) {
					int daemon_pid = int.parse(lockfile.readAsStringSync());
					stdout.writeln('Kill daemon with pid $daemon_pid.');
					Process.killPid(daemon_pid);
				} else {
					stdout.writeln('No daemon process to kill it.');
					exit(1);
				}
				break;
			case 'restart':
				if (exist) {
					int daemon_pid = int.parse(lockfile.readAsStringSync());
					stdout.writeln('Restart daemon with pid $daemon_pid.');
					Process.killPid(daemon_pid);
					spawnDaemon();
				} else {
					stdout.writeln('No daemon process to restart it.');
					exit(1);
				}
				break;
			default:
				if (exist) {
					stdout.writeln('Daemon already running.');
				} else {
					stdout.writeln('[DAEMON-PROOF] Spawn daemon and exit.');
					spawnDaemon();
				}
		}
	});
}

void spawnDaemon() {
	File lockfile = new File('./daemon.lock');
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