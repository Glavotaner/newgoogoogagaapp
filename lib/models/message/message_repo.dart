import 'package:googoogagaapp/models/message/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Messages> getMessages(String messagesType,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  final messages = sharedPrefs.getStringList(messagesType);
  return messages?.map(Message.fromString).toList() ?? [];
}

Future<bool> setMessages(String messagesType, Messages messages,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  return sharedPrefs.setStringList(
      messagesType, messages.map((message) => message.toString()).toList());
}

Future<Messages> insertMessage(String messageType, Message message,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  final messages = sharedPrefs.getStringList(messageType) ?? [];
  messages.insert(0, message.toString());
  await sharedPrefs.setStringList(messageType, messages);
  return messages.map(Message.fromString).toList();
}

Future<Message?> getTokenMessage(String tokenType,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  final message = sharedPrefs.getString(tokenType);
  if (message != null) {
    return Message.fromString(message);
  }
}

Messages validQuickKisses(Messages kisses, [SharedPreferences? sharedPrefs]) {
  final Messages validKisses = [];
  final now = DateTime.now();
  for (Message kiss in kisses) {
    final timeReceived = kiss.data.receiveTime!;
    final int timePast = now.difference(timeReceived).inMinutes;
    final timeLeft = kiss.kissType!.data!.quickKissDuration! - timePast;
    if (timeLeft > 0) {
      validKisses.insert(0, kiss..kissType!.data!.timeLeft = timeLeft);
    }
  }
  return validKisses;
}

Future<bool> setTokenMessage(Message tokenMessage, String tokenType,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  return sharedPrefs.setString(tokenType, tokenMessage.toString());
}

Future<Map> updateMessage(Message updated, String messagesType,
    [SharedPreferences? sharedPrefs]) async {
  final messages = await getMessages(messagesType, sharedPrefs);
  Message oldMessage = messages.singleWhere(
      (message) => message.messageId == updated.messageId,
      orElse: () => updated);
  oldMessage = updated;
  return {'message': oldMessage, 'messages': messages};
}

Future<Messages> removeMessage(Message messageToRemove, String messagesType,
    [SharedPreferences? sharedPrefs]) async {
  final messages = await getMessages(messagesType, sharedPrefs);
  final messageIndex = messages
      .indexWhere((message) => message.messageId == messageToRemove.messageId);
  if (messageIndex > -1) {
    messages.removeAt(messageIndex);
  }
  await setMessages(messagesType, messages, sharedPrefs);
  return messages;
}

Future<bool> removeTokenMessage(String messageType,
    [SharedPreferences? sharedPrefs]) async {
  sharedPrefs = sharedPrefs ?? await SharedPreferences.getInstance();
  return sharedPrefs.remove(messageType);
}
