class ConfigModel {
  final bool useMock;
  final String privacyLink;
  final String termsLink;
  final String netApiKey;
  final Map<String, dynamic> data;

  const ConfigModel({
    required this.useMock,
    required this.privacyLink,
    required this.termsLink,
    required this.data,
    required this.netApiKey,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        useMock: json[ConfigKey.useMock.name],
        privacyLink: json[ConfigKey.privacyLink.name],
        termsLink: json[ConfigKey.termsLink.name],
        data: json[ConfigKey.data.name],
        netApiKey: json[ConfigKey.netApiKey.name],
      );
}

enum ConfigKey {
  config,
  data,
  useMock,
  privacyLink,
  termsLink,
  netApiKey,
}
