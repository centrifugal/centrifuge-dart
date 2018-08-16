class Config {
  final String privateChannelPrefix;
  final Duration readTimeout;
  final Duration writeTimeout;
  final Duration pingInterval;

  Config(
      {this.privateChannelPrefix,
      this.readTimeout,
      this.writeTimeout,
      this.pingInterval});
}
