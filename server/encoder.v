module server

import encoding.binary

[heap]
pub struct Encoder {
mut:
	data	[]byte
}

// strings are length prefixed
pub fn (mut c Encoder) encode_string(s string) {
	c.encode_u32(u32(s.len))
	c.data << s.bytes()
}

pub fn (mut c Encoder) encode_u64(u u64) {
	mut tmp := []byte{len:8}
	binary.little_endian_put_u64(mut tmp, u)
	c.data << tmp
}

pub fn (mut c Encoder) encode_u32(u u32) {
	mut tmp := []byte{len:4}
	binary.little_endian_put_u32(mut tmp, u)
	c.data << tmp
}

pub fn (mut c Encoder) encode_u16(u u16) {
	mut tmp := []byte{len:2}
	binary.little_endian_put_u16(mut tmp, u)
	c.data << tmp
}

pub fn (mut c Encoder) encode_byte(b byte) {
	c.data << b
}

pub fn (mut c Encoder) encode_bool(b bool) {
	c.encode_byte(byte(b))
}

pub fn (mut c Encoder) finish() []byte {
	mut tmp := []byte{len:4}
	binary.little_endian_put_u32(mut tmp, u32(c.data.len))
	tmp << c.data
	return tmp
}

pub fn encode_handshake(pack SHandshake) []byte {
	mut e := Encoder{}
	e.encode_byte(pack.id)
	e.encode_u64(pack.ts)
	return e.finish()
}

pub fn encode_invalid() []byte {
	mut e := Encoder{}
	e.encode_byte(3) // packet ID of invalid packet
	return e.finish()
}

pub fn encode_clir_request() []byte {
	mut e := Encoder{}
	e.encode_byte(4)
	return e.finish()
}