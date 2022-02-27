module main

import server
import util

fn main() {
	// read settings
	util.read_config()
	util.handle_args()

	server.run()
}
