# Chat app example

By default it will run with the Centrifugo public demo instance. To run locally use this configuration for your server:

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

Then change the server address in `conf.dart`
