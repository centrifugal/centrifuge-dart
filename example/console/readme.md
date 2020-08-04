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
