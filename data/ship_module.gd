class_name ShipModule

enum Type {
	EMPTY,
	COCKPIT,
	WING,
	ENGINE
}

static func get_name(t: Type) -> String:
	match t:
		Type.COCKPIT: return "cockpit"
		Type.WING: return "wing"
		Type.ENGINE: return "engine"
		_: return ""

static func get_color(t: Type) -> Color:
	match t:
		Type.COCKPIT: return Color.DARK_GRAY
		Type.WING: return Color.CYAN
		Type.ENGINE: return Color.ORANGE
		_: return Color.DARK_SLATE_GRAY
#const PixelNames = {
	#PixelType.EMPTY: "",
	#PixelType.COCKPIT: "cockpit",
	#PixelType.WING: "wing",
	#PixelType.ENGINE: "engine"
#}
#
#const NameToType = {
	#"": PixelType.EMPTY,
	#"cockpit": PixelType.COCKPIT,
	#"wing": PixelType.WING,
	#"engine": PixelType.ENGINE
#}
