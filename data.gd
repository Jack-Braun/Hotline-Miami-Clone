extends Node

var guns: Dictionary = {
	#Handguns
	"glock": GunData.new(16, 1, 0.25, 0.5),
	"deagle": GunData.new(7, 2, 0.5, 0.6),
	#Submachine guns
	"uzi": GunData.new(32, 1, 0.09, 0.9)
}
