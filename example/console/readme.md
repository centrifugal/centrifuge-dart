# console

Example console chat app

Before running this example make sure you created `chat` namespace in Centrifugo configuration and allowed publishing into channel - i.e. using config like this:

```json
{
  "token_hmac_secret_key": "9c4a1a64-7479-4c2c-9895-14b0676c71d8",
  "admin_password": "a15cfff3-b7b7-4261-87ad-c6825c0400b5",
  "admin_secret": "3aaead2e-2d3d-48cb-b330-c54c44b4eac0",
  "api_key": "cb0f41cd-5954-443d-8628-a4453592443c",
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

When you use your own configuration, please re-generate the tokens registered in `example.dart`:
* Use `centrifugo gentoken --user dart` to generate the user's JWT token.
* Use `centrifugo gensubtoken --user dart --channel chat:index` to generate the user's subscription JWT token.


Run Centrifugo with the admin option, to later send messages to all subscribers:

```bash
centrifugo --admin
```


For testing purposes only, you can also run Centrifugo in insecure client mode, so that the validity of JWT tokens 
are not checked:

```bash
centrifugo --client_insecure --admin
```

Now check the IP address if your system with `ipconfig` on Windows and `ip adds` on Unix-like systems and change the `serverAddr` variable in `example.dart` accordingly.

When the configuration is correct, you can launch the console app with `dart example.dart`.

When you have started centrifugo with the `--admin` option, you can also open `http://localhost:8000/#/actions` to send a message to your console app with the
following settings:
* Method: Publish
* Channel: `chat:index`
* Data: `{"message": "hello world", "username": "admin"}`

Congratulations, you have a running centrifugo system and a Flutter console app that connects to it!