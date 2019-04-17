class ClientConfig {
  const ClientConfig({
    this.timeout = const Duration(seconds: 5),
    this.debug = false,
    this.headers = const <String, dynamic>{},
    this.tlsSkipVerify = false,
    this.maxReconnectDelay = const Duration(seconds: 20),
    this.privateChannelPrefix = "\$",
    this.pingInterval = const Duration(seconds: 25),
  });

  final Duration timeout;
  final bool debug;
  final Map<String, dynamic> headers;

  final bool tlsSkipVerify;

  final Duration maxReconnectDelay;
  final String privateChannelPrefix;
  final Duration pingInterval;
}
