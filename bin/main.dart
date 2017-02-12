import 'dart:io';
import 'package:args/args.dart';
import 'package:daemonproof/src/DaemonCommander.dart';

void main(List<String> args) {
	ArgParser parser = new ArgParser();
	ArgResults results;
	
	parser.addOption('option',
		abbr: 'o',
		allowed: ['start', 'restart', 'kill'],
		defaultsTo: 'start'
	);
	
	try {
		results = parser.parse(args);
	} on FormatException catch(exception) {
		print(exception.message);
		exit(1);
	}
	
	DaemonCommander dc = new DaemonCommander('./bin/daemon.dart');
	
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