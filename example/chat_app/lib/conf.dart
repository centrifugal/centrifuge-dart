import 'client/client.dart';

/// The address of the centrifugo service
///
/// Use ipconfig or ifconfig to find out the IP address of your machine
const String serverAddr = '192.168.0.115:8000';

/// The channel name to subscribe to
const String channel = 'chat:index';

/// The user's name
const userName = 'dart';

/// The user's JWT token
///
/// generate user JWT token for user "dart":
/// ./centrifugo gentoken -u dart
const userJwtToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlbm91Z2giLCJleHAiOjE2NzQ3MjcyMzcsImlhdCI6MTY3NDEyMjQzN30.jsKrRp-4jcJun-KlKb_z8J3rJwL7QWV8EZpWyl5g1ds';

/// The subscription token
///
/// generate subscription JWT token for user "dart" and channel "chat:index":
/// ./centrifugo gensubtoken -u dart -s chat:index
const subscriptionJwtToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlbm91Z2giLCJleHAiOjE2NzQ3Mjg1ODUsImlhdCI6MTY3NDEyMzc4NSwiY2hhbm5lbCI6ImNoYXQ6aW5kZXgifQ.BRWR0DMFULXrnCn1F9EulerFCP-XY8QIgcl_lV7U1SU';

final ChatClient cli = ChatClient();
