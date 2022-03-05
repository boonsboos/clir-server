module server

import net

__global server Server

fn init() {
	server = Server{}
}

pub struct Server {
pub mut:
	listener 	net.TcpListener
	// db connect(ion|or)
	// http server
}

pub fn run() {
	
	server.listener = net.listen_tcp(.ip, '$settings.remote:$settings.port') or {
		panic(err)
	}

	for {
		mut read_buf := []byte{len:1024} // maximum of 1kb per connection/packet to reduce data throughput & load
		mut conn := server.listener.accept() or { panic('connection terminated') }
		conn.set_blocking(true) or { panic('failed to set to blocking') }

		buf_fill := conn.read(mut read_buf) or { panic('failed to read') }
		println(read_buf[0..buf_fill])
		handle_connection(mut conn, mut read_buf)
	}

}

fn handle_connection(mut conn net.TcpConn, mut read_buf []byte) {

	packet := decode_packet(read_buf)
	println(packet.clir)
	process_clir(mut conn, packet)

}

fn process_clir(mut conn net.TcpConn, packet Packet) {
	println(packet.clir)
} 