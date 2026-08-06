{
  id = "amazon-linux-2-l1-server";
  title = "NixOS mapping of CIS Amazon Linux 2 Level 1 Server";

  source = {
    publisher = "Center for Internet Security";
    benchmark = "CIS Amazon Linux 2 Benchmark";
    version = "4.0.0";
    publicationDate = "2026-03-26";
    profile = "Level 1 - Server";
    recommendations = 225;
    automated = 0;
    manual = 0;
    unspecified = 225;
    assessmentNote = "The source PDF does not display Automated or Manual assessment labels on recommendation pages.";
    documentSha256 = "8cc1c7321a2e69babf36cba84f565acc3fb3d2ef4bb3e65d8676c9e30cc8a786";
    url = "https://www.cisecurity.org/benchmark/amazon_linux";
  };

  alignment = {
    status = "derived";
    certified = false;
    statement = "This profile adapts security intent to NixOS and does not assert conformance with or certification against the source benchmark.";
  };

  internal.evaluatorFamily = "amazon-linux";
  catalog = import ../catalog/amazon-linux-2-v4.0.0-l1-server.nix;
}
