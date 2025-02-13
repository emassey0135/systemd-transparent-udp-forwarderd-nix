{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = import nixpkgs {
        inherit system;
      };
        systemd-transparent-udp-forwarderd = (with pkgs;
          stdenv.mkDerivation {
            pname = "systemd-transparent-udp-forwarderd";
            version = "1.0.0";
            src = fetchFromGitHub {
              owner = "mark-kubacki";
              repo = "systemd-transparent-udp-forwarderd";
              rev = "4c60f91a7658adca8088165741a283fc10a3e57b";
              hash = "sha256-hY2x1oFRTWZlchQFJPD5bHgoiRH5KlDUsVNv8mY93vU=";
            };
            nativeBuildInputs = [
              clang
              cmake
              systemd
            ];
            buildPhase = "make -j $NIX_BUILD_CORES";
            installPhase = ''
              mkdir -p $out/bin
              cp $TMP/source/build/systemd-transparent-udp-forwarderd $out/bin
            '';
          }
        );
      in rec {
        defaultApp = flake-utils.lib.mkApp {
          drv = defaultPackage;
        };
        defaultPackage = systemd-transparent-udp-forwarderd;
      }
    );
}
