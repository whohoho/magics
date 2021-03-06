{ pkgs }:

pkgs.buildGo110Package rec {
  name = "influxdb-${version}";
  version = "1.6.3";

  src = pkgs.fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0xf16liapllk8qnw0vsy1ja4if1xlazwwaa4p0r5j7bny5lxm7zy";
  };

  buildFlagsArray = [ ''-ldflags=
    -X main.version=${version}
  '' ];

  goPackagePath = "github.com/influxdata/influxdb";

  excludedPackages = "test";

  # Generated with dep2nix (for 1.6.3) / nix2go (for 1.4.1).
  goDeps = ./. + "/deps-${version}.nix";

}