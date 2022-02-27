import net

fn test_main() {
	mut conn := net.dial_tcp('127.0.0.1:43254') or { panic('err') }
	conn.write([byte(0x00), 0x00, 0x00, 0x01, 0x03]) or { panic('no') }
}