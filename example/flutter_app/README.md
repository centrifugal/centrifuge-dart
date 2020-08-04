# centrifuge_app

Flutter app example.

Before running example make sure you created `chat` namespace in Centrifugo configuration and allowed publishing into channel - i.e. using config like this:

```json
{
  ...
  "namespaces": [
    {
      "name": "chat",
      "anonymous": false,
      "publish": true,
      "join_leave": true,
      "presence": true,
      "presence_stats": true
    }
  ]
}
```

Also run Centrifugo in insecure client mode so it does not expect JWT token from client:

```bash
./centrifugo --config config.json --client_insecure
```

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
