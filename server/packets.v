module server

import time

// C->S Handshake
// S->C Handshake
// C->S Authentication Request
// Server Verifies
// If fails:
	// S->C Invalid
	// terminates the connection
// S->C Clir Request
// C->S Clir
// S Processes

// If ANY packet fails, the connection is terminated

// Packets are length prefixed (u32)

struct Packet {
pub:
	key  string
	clir Clir
}