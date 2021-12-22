import 'package:googoogagaapp/models/message/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Messages> getMessages(String messagesType) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final messages = sharedPreferences.getStringList(messagesType);
  return messages?.map(Message.fromString).toList() ?? [];
}

Future<bool> setMessages(String messagesType, Messages messages) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.setStringList(
      messagesType, messages.map((message) => message.toString()).toList());
}

Future<Messages> insertMessage(String messageType, Message message) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final messages = sharedPreferences.getStringList(messageType) ?? [];
  messages.insert(0, message.toString());
  await sharedPreferences.setStringList(messageType, messages);
  return messages.map(Message.fromString).toList();
}

Future<Message?> getTokenMessage(String tokenType) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final message = sharedPreferences.getString(tokenType);
  if (message != null) {
    return Message.fromString(message);
  }
}

Future<bool> setTokenMessage(Message tokenMessage, String tokenType) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.setString(tokenType, tokenMessage.toString());
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
  await setMessages(messagesType, messages);
  return messages;
}

Future<bool> removeTokenMessage(String messageType) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.remove(messageType);
}
