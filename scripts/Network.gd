extends Node

const DEFAULT_IP := "127.0.0.1"
const DEFAULT_PORT := 31400
const MAX_CLIENTS := 2

func create_server():
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(peer)

func join_server():
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func call_peer(node_path, function, data: String):
	rpc("receive_call", node_path, function, data)

remote func receive_call(node_path: String, function, data: String):
	get_tree().get_root().get_node(node_path).run_server_func(function, data)
