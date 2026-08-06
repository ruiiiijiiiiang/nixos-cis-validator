{
  id = "debian-13-l1-server";
  title = "NixOS mapping of CIS Debian Linux 13 Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS Debian Linux 13 Benchmark";
    version = "1.0.0";
    publicationDate = "2025-12-16";
    profile = "Level 1 - Server";
    recommendations = 262;
    automated = 249;
    manual = 13;
    unspecified = 0;
    documentSha256 = "efa5df0e5b8d0ab08fa1f7ef8a228cebfd7bb5a8e6591ba5af4fb459cbc799fc";
    url = "https://www.cisecurity.org/benchmark/debian_linux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "debian";
  catalog = import ../catalog/debian-13-v1.0.0-l1-server.nix;
}
