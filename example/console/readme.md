# console

Example console chat app

Before running example make sure you created `chat` namespace in Centrifugo configuration and allowed publishing into channel - i.e. using config like this:

```json
{
  ...
  "allowed_origins": ["http://localhost:8000"],
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

Alternatively to running in insecure mode, you can regenerate the tokens in `example.dart` on your system.

Now check the IP address if your system with `ipconfig` on Windows and `ip adds` on Unix-like systems and change the serverAddr in `lib/conf.dart` accordingly.

When the configuration is correct, you can launch the console app with `dart example.dart`.

When you have started centrifugo with the `--admin` option, you can also open `http://localhost:8000/#/actions` to send a message to your console app with the
following settings:
* Method: Publish
* Channel: `chat:index`
* Data: `{"message": "hello world", "username": "admin"}`

Congratulations, you have a running centrifugo system and a Flutter console app that connects to it!