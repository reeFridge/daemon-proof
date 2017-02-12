import 'dart:core';
import 'package:args/args.dart';
import 'package:daemonproof/src/DaemonCommander.dart';

void main(List<String> args) {
	ArgParser parser = new ArgParser();
	parser.addOption('option',
		abbr: 'o',
		allowed: ['start', 'restart', 'kill'],
		defaultsTo: 'start'
	);
	ArgResults results = parser.parse(args);
	
	DaemonCommander dc = new DaemonCommander();
	
	switch (results['option']) {
		case 'kill':
			dc.killDaemon();
			break;
		case 'restart':
			dc.restartDaemon();
			break;
		case 'start':
		default:
			dc.startDaemon();
	}
}