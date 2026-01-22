# Chat Screen

This Flutter project makes a chat functionality and design (similar to WhatsApp) to use with different APIs

## Configuring

```bash
dart pub get
```

# Default datasources

This application has two datasources:

1. `LocalTestingChatDatasource`: Is used to receive confirmations from text messages.
2. `YesNoMessageDatasource`: Is based on 'Yes-No' helper and functionality used from original yes_no project.

## Changing datasource

Datasource is managed by `ChatRepositoryImplementation`. To change the datasource used in the app, change `chatDatasource` property on `lib/presentation/providers/chat_provider.dart`:

```dart
class ChatProvider extends ChangeNotifier {
    // ...
    final ChatRepositoryImplementation chatRepository =
        ChatRepositoryImplementation(chatDatasource: yourDatasource());
    // ...
}
```
