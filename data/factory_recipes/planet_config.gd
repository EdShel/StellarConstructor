class_name PlanetConfig

var result_item: String = "ore"
var planet_buffer: float = 100.0
var send_rocket_threshold: float = 100.0
var planet_buffer_limit: float = 200
var mining_rate_per_sec: float = 1.0

static func create_planets() -> Array[PlanetConfig]:
	var result: Array[PlanetConfig] = []
	
	var ore = PlanetConfig.new()
	ore.result_item = "ore"
	ore.planet_buffer = 100.0
	ore.send_rocket_threshold = 100.0
	ore.planet_buffer_limit = 200.0
	ore.mining_rate_per_sec = 1.0
	result.push_back(ore)
	
	var crystal = PlanetConfig.new()
	crystal.result_item = "crystal"
	crystal.planet_buffer = 100.0
	crystal.send_rocket_threshold = 100.0
	crystal.planet_buffer_limit = 200.0
	crystal.mining_rate_per_sec = 1.0
	result.push_back(crystal)
	
	var water = PlanetConfig.new()
	water.result_item = "water"
	water.planet_buffer = 100.0
	water.send_rocket_threshold = 100.0
	water.planet_buffer_limit = 200.0
	water.mining_rate_per_sec = 1.0
	result.push_back(water)
	
	return result
