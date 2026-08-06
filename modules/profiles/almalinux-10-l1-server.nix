{
  id = "almalinux-10-l1-server";
  title = "NixOS mapping of CIS AlmaLinux OS 10 Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS AlmaLinux OS 10 Benchmark";
    version = "1.0.0";
    publicationDate = "2025-09-30";
    profile = "Level 1 - Server";
    recommendations = 248;
    automated = 231;
    manual = 17;
    unspecified = 0;
    documentSha256 = "786bc2ffec552db2c4d573679647b81e3d19d1912a97e4886ff04f91f4c566dc";
    url = "https://www.cisecurity.org/benchmark/almalinux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "rpm";
  catalog = import ../catalog/almalinux-10-v1.0.0-l1-server.nix;
}
