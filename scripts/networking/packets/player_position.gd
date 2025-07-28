class_name PlayerPosition extends PacketInfo

var id: int
var position: Vector2

static func create(id: int, position: Vector2) -> PlayerPosition:
	var info: PlayerPosition = PlayerPosition.new()
	info.packet_type = PACKET_TYPE.PLAVER_POSITION
	info.flag = ENetPacketPeer.FLAG_UNSEQUENCED
	info.id = id
	info.position = position
	return info

static func create_from_data(data: PackedByteArray) -> IDAssignment:
	var info: IDAssignment = IDAssignment.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(10) # sizeof(id + position)
	data.encode_u8(1, id)
	data.encode_float(2, position.x)
	data.encode_float(6, position.y)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_double(1)
	position = Vector2(data.decode_float(2), data.decode_float(6))
