# Chat app example

Before running this example make sure you created `chat` namespace in Centrifugo configuration and allowed publishing into channel - i.e. using config like this:

```json
{
  ...
  "allowed_origins": ["http://localhost:8000", "http://localhost:3000"],
  "namespaces": [
    {
      "name": "chat",
      "anonymous": false,
      "publish": true,
      "join_leave": true,
      "presence": true,
      "presence_stats": true,
	    "allow_publish_for_subscriber": true,
      "allow_subscribe_for_client": true
    }
  ]
}
```

Call `centrifugo genconfig` to create a basic `config.json` at the first time.

Also run Centrifugo in insecure client mode so it does not expect JWT token from client:

```bash
./centrifugo --config config.json --client_insecure --admin
```

Alternatively to running in insecure mode, you can regenerate the tokens in `lib/src/conf.dart` on your system.

Now check the IP address if your system with `ipconfig` on Windows and `ip adds` on Unix-like systems and change the serverAddr in `lib/conf.dart` accordingly.

When the configuration is correct, you can launch the app on the platform of your choice. When running on web, ensure that you specify a port using the `--web-port` argument 
and that you have whitelisted that port in your Centrifugo `config.json` file. E.g. `"allowed_origins": ["http://localhost:8000", "http://localhost:3000"]` when running
locally on port 3000: `flutter run -d chrome --web-port 3000`.

When you have started centrifugo with the `--admin` option, you can also open `http://localhost:8000/#/actions` to send a message to your console app with the
following settings:
* Method: Publish
* Channel: `chat:index`
* Data: `{"message": "hello world", "username": "admin"}`

Congratulations, you have a running centrifugo system and a Flutter app that connects to it!