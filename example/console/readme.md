# centrifuge-dart console app

You can run environment in two ways:

1. Docker (recommended)
   ```bash
   docker-compose up [-d]
   ```

2. Manually
   ```bash
   # first terminal session
   npm i
   npm start 

   # second terminal session
   ./centrifugo --config config.json --client_insecure
   ```

To run console app itself:
```bash
dart ./simple.dart
```