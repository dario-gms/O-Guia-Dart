// Exercício 3: Sistema de Notificações
// Desenvolva um sistema de notificações que utiliza generics para diferentes tipos de payloads.

// Implemente NotificationSystem<T> com:
// - subscribe(String topic, void Function(T payload) callback)
// - unsubscribe(String topic)
// - notify(String topic, T payload)

class NotificationSystem<T> {
  final Map<String, List<void Function(T)>> _subscribers = {};
  
  void subscribe(String topic, void Function(T) callback) {
    _subscribers.putIfAbsent(topic, () => []).add(callback);
  }
  
  bool unsubscribe(String topic, void Function(T) callback) {
    var callbacks = _subscribers[topic];
    if (callbacks != null) {
      return callbacks.remove(callback);
    }
    return false;
  }
  
  void notify(String topic, T payload) {
    var callbacks = _subscribers[topic];
    if (callbacks != null) {
      for (var callback in callbacks) {
        try {
          callback(payload);
        } catch (e) {
          print('Erro ao notificar subscriber: $e');
        }
      }
    }
  }
  
  void clearTopic(String topic) {
    _subscribers.remove(topic);
  }
  
  int getSubscriberCount(String topic) {
    return _subscribers[topic]?.length ?? 0;
  }
}

void main() {
  // Sistema de notificações para mensagens de texto
  var textNotificationSystem = NotificationSystem<String>();

  // Sistema de notificações para dados mais complexos
  var dataNotificationSystem = NotificationSystem<Map<String, dynamic>>();

  // --- Inscrição em tópicos ---
  textNotificationSystem.subscribe("chat", (msg) {
    print("Recebido no chat: $msg");
  });

  textNotificationSystem.subscribe("alerta", (msg) {
    print("Alerta: $msg");
  });

  dataNotificationSystem.subscribe("pedido", (dados) {
    print("Novo pedido recebido:");
    print("Cliente: ${dados['cliente']}");
    print("Produto: ${dados['produto']}");
  });

  // --- Notificando ---
  textNotificationSystem.notify("chat", "Olá, mundo!");
  textNotificationSystem.notify("alerta", "Sistema fora do ar!");
  
  dataNotificationSystem.notify("pedido", {
    "cliente": "Maria",
    "produto": "Notebook Gamer"
  });

  // --- Cancelando inscrição ---
  void alertaCallback(String msg) {
    print("Callback extra de alerta: $msg");
  }

  textNotificationSystem.subscribe("alerta", alertaCallback);
  textNotificationSystem.notify("alerta", "Servidor reiniciado.");

  // Remove o callback extra
  textNotificationSystem.unsubscribe("alerta", alertaCallback);
  textNotificationSystem.notify("alerta", "Serviço restaurado.");

  // --- Contando assinantes ---
  print("Assinantes do chat: ${textNotificationSystem.getSubscriberCount("chat")}");
}
