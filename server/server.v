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
		buf_fill := conn.read(mut read_buf) or { panic('failed to read data') }
		println(read_buf[0..buf_fill])
		handle_connection(mut conn, mut read_buf)
		read_buf.clear()
		buf_fill2 := conn.read(mut read_buf) or { panic('failed to read data') }
		println(read_buf[0..buf_fill2])
		handle_connection(mut conn, mut read_buf)
		read_buf.clear()
		buf_fill3 := conn.read(mut read_buf) or { panic('failed to read data') }
		println(read_buf[0..buf_fill3])
		handle_connection(mut conn, mut read_buf)
		read_buf.clear()
	}

}

fn handle_connection(mut conn net.TcpConn, mut read_buf []byte) {

	packet := decode_packet(read_buf)

	if packet is CHandshake {
		process_handshake(mut conn, packet)
	} if packet is CAuthRequest {
		println(packet.key)
		process_auth_request(mut conn, packet)
	} else if packet is CClirSend {
		println(packet.clir)
		process_clir_send(mut conn, packet)
	} else {
		conn.close() or { panic('failed to close') } // SInvalid
	}
}

fn process_handshake(mut conn net.TcpConn, packet CHandshake) {
	s_handshake := SHandshake{packet.id, packet.ts}
	conn.write(encode_handshake(s_handshake)) or { panic('oh noes') }
}

fn process_auth_request(mut conn net.TcpConn, packet CAuthRequest) {
	if packet.key == 'blub' {
		conn.write(encode_clir_request()) or { panic('failed to write clir request') }
	} else {
		conn.write(encode_invalid()) or { panic('failed to write invalid packet') }
	}
}

fn process_clir_send(mut conn net.TcpConn, packet CClirSend) {
	println(packet.clir)
} 