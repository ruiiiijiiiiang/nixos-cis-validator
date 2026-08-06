{
  id = "rhel-10-l1-server";
  title = "NixOS mapping of CIS Red Hat Enterprise Linux 10 Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS Red Hat Enterprise Linux 10 Benchmark";
    version = "1.0.1";
    publicationDate = "2025-09-30";
    profile = "Level 1 - Server";
    recommendations = 248;
    automated = 231;
    manual = 17;
    unspecified = 0;
    documentSha256 = "5ac1adfbc26394c82227b334bfb8216d07875458fa75f558833e9af63d9b7a2a";
    url = "https://www.cisecurity.org/benchmark/red_hat_linux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "rpm";
  catalog = import ../catalog/rhel-10-v1.0.1-l1-server.nix;
}
