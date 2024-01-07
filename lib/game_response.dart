class GameResponse {
  String? message;
  String? messageType;
  int? senderId;
  int? myId;
  Position? position;
  int? clientCount;
  List<ClientsPosition>? clientsPosition;

  GameResponse({this.message, this.messageType, this.senderId, this.myId, this.position, this.clientCount, this.clientsPosition});

  GameResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['message_type'];
    senderId = json['sender_id'];
    myId = json['my_id'];
    position = json['position'] != null ? Position.fromJson(json['position']) : null;
    clientCount = json['client_count'];
    if (json['clients_position'] != null) {
      clientsPosition = <ClientsPosition>[];
      json['clients_position'].forEach((v) {
        clientsPosition!.add(ClientsPosition.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['message_type'] = messageType;
    data['sender_id'] = senderId;
    data['my_id'] = myId;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['client_count'] = clientCount;
    if (clientsPosition != null) {
      data['clients_position'] = clientsPosition!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Position {
  int? x;
  int? y;

  Position({this.x, this.y});

  Position.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}

class ClientsPosition {
  int? clientId;
  Position? position;

  ClientsPosition({this.clientId, this.position});

  ClientsPosition.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    position = json['position'] != null ? Position.fromJson(json['position']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientId;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}
