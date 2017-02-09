import 'dart:io';
import 'dart:core';
import 'package:args/args.dart';

void main(List<String> args) {
	ArgParser parser = new ArgParser();
	parser.addOption('option', abbr: 'o', allowed: ['kill', 'restart']);
	ArgResults results = parser.parse(args);
	
	File pidFile = new File('./pidfile');
	pidFile.exists().then((bool exist) {
		switch (results['option']) {
			case 'kill':
				if (exist) {
					int daemon_pid = int.parse(pidFile.readAsStringSync());
					stdout.writeln('Kill daemon with pid $daemon_pid.');
					Process.killPid(daemon_pid);
				} else {
					stdout.writeln('No daemon process to kill it.');
					exit(1);
				}
				break;
			case 'restart':
				if (exist) {
					int daemon_pid = int.parse(pidFile.readAsStringSync());
					stdout.writeln('Restart daemon with pid $daemon_pid.');
					Process.killPid(daemon_pid, ProcessSignal.SIGUSR1);
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
	File pidFile = new File('./pidfile');
	Process.start(
		'dart',
		['./bin/daemon.dart'],
		mode: ProcessStartMode.DETACHED,
		includeParentEnvironment: false
	).then((Process proc) {
		stdout.writeln('Daemon runs with pid: ${proc.pid}');
		pidFile.writeAsStringSync(proc.pid.toString());
		exit(0);
	});
}