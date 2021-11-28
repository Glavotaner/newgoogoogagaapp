import 'package:googoogagaapp/models/message/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Messages> getMessages(String messagesType) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final messages = sharedPrefs.getStringList(messagesType);
  return messages?.map(Message.fromString).toList() ?? [];
}

Future<Message?> getTokenMessage(String tokenType) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final message = sharedPrefs.getString(tokenType);
  if (message != null) {
    return Message.fromString(message);
  }
}

Future<bool> setTokenMessage(Message tokenMessage, String tokenType) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  return sharedPrefs.setString(tokenType, tokenMessage.toString());
}

Future<Map> updateMessage(Message updated, String messagesType) async {
  final messages = await getMessages(messagesType);
  Message oldMessage = messages.singleWhere(
      (message) => message.messageId == updated.messageId,
      orElse: () => updated);
  oldMessage = updated;
  return {'message': oldMessage, 'messages': messages};
}

Future<Messages> removeMessage(
    Message messageToRemove, String messagesType) async {
  final messages = await getMessages(messagesType);
  final messageIndex = messages
      .indexWhere((message) => message.messageId == messageToRemove.messageId);
  if (messageIndex > -1) {
    messages.removeAt(messageIndex);
  }
  return messages;
}

Future<bool> removeTokenMessage(String messageType) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  return sharedPrefs.remove(messageType);
}
