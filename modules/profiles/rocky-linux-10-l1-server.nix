{
  id = "rocky-linux-10-l1-server";
  title = "NixOS mapping of CIS Rocky Linux 10 Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS Rocky Linux 10 Benchmark";
    version = "1.0.0";
    publicationDate = "2025-09-30";
    profile = "Level 1 - Server";
    recommendations = 248;
    automated = 231;
    manual = 17;
    unspecified = 0;
    documentSha256 = "1c10115663879b15d0116a49503681a2b0b440e587908e5901f8106773f0ec6e";
    url = "https://www.cisecurity.org/benchmark/rocky_linux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "rpm";
  catalog = import ../catalog/rocky-linux-10-v1.0.0-l1-server.nix;
}
