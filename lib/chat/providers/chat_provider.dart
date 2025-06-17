import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../apis/api_service.dart';
import '../constants/constants.dart';
import '../hive/boxes.dart';
import '../hive/chat_history.dart';
import '../hive/settings.dart';
import '../hive/user_model.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  // list of messages
  final List<Message> _inChatMessages = [];

  // page controller
  final PageController _pageController = PageController();

  // images file list
  List<XFile>? _imagesFileList = [];

  // index of the current screen
  int _currentIndex = 0;

  // current chatId
  String _currentChatId = '';

  // current model
  String _modelType = 'gemini-1.5-flash';

  // loading bool
  bool _isLoading = false;

  // getters
  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  List<XFile>? get imagesFileList => _imagesFileList;
  int get currentIndex => _currentIndex;
  String get currentChatId => _currentChatId;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;

  // setters

  // set inChatMessages
  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) {
        log('message already exists');
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  // load messages from db
  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');
    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      return Message.fromMap(Map<String, dynamic>.from(message));
    }).toList();
    notifyListeners();
    return newData;
  }

  // set file list
  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  // set current model
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  // set current page index
  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  // set current chat id
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  // set loading
  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  // delete chat
  Future<void> deleteChatMessages({required String chatId}) async {
    if (!Hive.isBoxOpen('${Constants.chatMessagesBox}$chatId')) {
      await Hive.openBox('${Constants.chatMessagesBox}$chatId');
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    } else {
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    }

    if (currentChatId.isNotEmpty && currentChatId == chatId) {
      setCurrentChatId(newChatId: '');
      _inChatMessages.clear();
      notifyListeners();
    }
  }

  // prepare chat room
  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    if (!isNewChat) {
      final chatHistory = await loadMessagesFromDB(chatId: chatID);
      _inChatMessages.clear();
      _inChatMessages.addAll(chatHistory);
      setCurrentChatId(newChatId: chatID);
    } else {
      _inChatMessages.clear();
      setCurrentChatId(newChatId: chatID);
    }
  }

  // send message to gemini and get the response
  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    setLoading(value: true);
    String chatId = getChatId();
    final messagesBox = await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final userMessageId = messagesBox.keys.length;
    final assistantMessageId = messagesBox.keys.length + 1;
    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    // user message
    final userMessage = Message(
      messageId: userMessageId.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    try {
      // Prepare the prompt with history
      String prompt = await buildPromptWithHistory(chatId: chatId, message: message, isTextOnly: isTextOnly);

      // Call ApiService
      final response = await ApiService.generateReply(prompt);

      // assistant message
      final assistantMessage = Message(
        messageId: assistantMessageId.toString(),
        chatId: chatId,
        role: Role.assistant,
        message: StringBuffer(response),
        imagesUrls: [],
        timeSent: DateTime.now(),
      );

      _inChatMessages.add(assistantMessage);
      notifyListeners();

      // save messages to hive
      await saveMessagesToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: assistantMessage,
        messagesBox: messagesBox,
      );
    } catch (e) {
      log('Error: $e');
      final errorMessage = Message(
        messageId: assistantMessageId.toString(),
        chatId: chatId,
        role: Role.assistant,
        message: StringBuffer('Error: $e'),
        imagesUrls: [],
        timeSent: DateTime.now(),
      );
      _inChatMessages.add(errorMessage);
      notifyListeners();

      await saveMessagesToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: errorMessage,
        messagesBox: messagesBox,
      );
    } finally {
      setLoading(value: false);
      await messagesBox.close();
    }
  }

  // build prompt with chat history
  Future<String> buildPromptWithHistory({
    required String chatId,
    required String message,
    required bool isTextOnly,
  }) async {
    StringBuffer prompt = StringBuffer();
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);
      for (var msg in inChatMessages) {
        prompt.write('${msg.role == Role.user ? 'User' : 'Assistant'}: ${msg.message}\n');
      }
    }
    prompt.write('User: $message');
    if (!isTextOnly && imagesFileList != null && imagesFileList!.isNotEmpty) {
      prompt.write('\n[Images: ${imagesFileList!.map((img) => img.path).join(', ')}]');
    }
    return prompt.toString();
  }

  // save messages to hive db
  Future<void> saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
  }) async {
    await messagesBox.add(userMessage.toMap());
    await messagesBox.add(assistantMessage.toMap());

    final chatHistoryBox = Boxes.getChatHistory();
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatID, chatHistory);
  }

  // get imagesUrls
  List<String> getImagesUrls({
    required bool isTextOnly,
  }) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imagesFileList != null) {
      for (var image in imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    }
    return currentChatId;
  }

  // init Hive box
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }
  }
}