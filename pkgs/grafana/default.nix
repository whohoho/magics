{ pkgs }:

pkgs.buildGo110Package rec {
  version = "5.3.2";
  name = "grafana-${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = pkgs.fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1p2vapyaf11d7zri73vnq1rsgwb018pqbjzdkdgppcm5xfrrjh8y";
  };

  srcStatic = pkgs.fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "067rj2lrdwxda1clcg89m1cnl9sfrl2l9ia5fx2bcxq3yzhchazh";
  };

  postPatch = ''
    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
  
  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf,tools} $bin/share/grafana/
    ln -sf ${pkgs.phantomjs2}/bin/phantomjs $bin/share/grafana/tools/phantomjs/phantomjs
  '';

}
