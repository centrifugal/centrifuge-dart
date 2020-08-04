import 'client/client.dart';

const String serverAddr = "centrifugo2.herokuapp.com";

// a demo token
const String token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0c3VpdGVfand0In0.hPmHsVqvtY88PvK4EmJlcdwNuKFuy3BGaF7dMaKdPlw";

const String channel = 'chat:index';

final ChatClient cli = ChatClient();
