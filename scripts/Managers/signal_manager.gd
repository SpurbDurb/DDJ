extends Node

# Dicionário para armazenar listas de objetos que devem responder aos sinais
var connections = {}

# Regista um sinal de conexão e assegura que ele existe
func register_signal(connection_id):
	if not connections.has(connection_id):
		connections[connection_id] = []  # Uma lista de listeners para o sinal

# Emite um sinal para uma conexão específica
func emit_connection_signal(connection_id, emitter = null):
	if connections.has(connection_id):
		for callable in connections[connection_id]:
			# Evitar chamar callbacks pertencentes ao emissor
			if callable.get_object() == emitter:
				continue
			callable.call()

# Liga um callback a uma conexão específica
func connect_to_signal(connection_id, callable):
	register_signal(connection_id)  # Assegura que a conexão existe
	connections[connection_id].append(callable)  # Adiciona o listener
