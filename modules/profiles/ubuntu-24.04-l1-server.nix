{
  id = "ubuntu-24.04-l1-server";
  title = "NixOS mapping of CIS Ubuntu Linux 24.04 LTS Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS Ubuntu Linux 24.04 LTS Benchmark";
    version = "2.0.0";
    publicationDate = "2026-05-28";
    profile = "Level 1 - Server";
    recommendations = 258;
    automated = 246;
    manual = 12;
    unspecified = 0;
    documentSha256 = "9486caebef04f5d3fbe534930ec4f88506ef6deb292d270ee578488cbc991736";
    url = "https://www.cisecurity.org/benchmark/ubuntu_linux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "ubuntu";
  catalog = import ../catalog/ubuntu-24.04-v2.0.0-l1-server.nix;
}
