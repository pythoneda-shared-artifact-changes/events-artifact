{
  description = "Events representing changes in source code";
  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-shared-artifact-changes-shared = {
      url =
        "github:pythoneda-shared-artifact-changes/shared-artifact/0.0.1a1?dir=shared";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
    };
    pythoneda-shared-pythoneda-domain = {
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.1a25?dir=domain";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        pname = "pythoneda-shared-artifact-changes-events";
        description = "Events representing changes in source code";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-shared-artifact-changes/events";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/shared.nix;
        pythonpackage = "pythoneda.shared.artifact_changes.events";
        pythoneda-shared-artifact-changes-events-for = { python
          , pythoneda-shared-artifact-changes-shared
          , pythoneda-shared-pythoneda-domain, version }:
          let
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion pythonpackage
                version;
              pythonedaSharedArtifactChangesSharedVersion =
                pythoneda-shared-artifact-changes-shared.version;
              pythonedaSharedPythonedaDomainVersion =
                pythoneda-shared-pythoneda-domain.version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              unidiffVersion = python.pkgs.unidiff.version;
              src = pyprojectTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = "pythoneda-shared-artifact-changes";
              repo = "events";
              rev = version;
              sha256 = "sha256-aaqAlb/uW+BTvogQwW/RxxbAOvaygpPqFJ6muAZ4OkE=";
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-shared-artifact-changes-shared
              pythoneda-shared-pythoneda-domain
            ];

            pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod -R +w $sourceRoot
              cat ${pyprojectTemplate}
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
        pythoneda-shared-artifact-changes-events-0_0_1a4-for = { python
          , pythoneda-shared-artifact-changes-shared
          , pythoneda-shared-pythoneda-domain }:
          pythoneda-shared-artifact-changes-events-for {
            version = "0.0.1a4";
            inherit python pythoneda-shared-artifact-changes-shared
              pythoneda-shared-pythoneda-domain;
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pythoneda-shared-artifact-changes-events-latest;
          pythoneda-shared-artifact-changes-events-0_0_1a4-python38 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-0_0_1a4-python38;
              python = pkgs.python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python38;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-0_0_1a4-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-0_0_1a4-python39;
              python = pkgs.python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-0_0_1a4-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-artifact-changes-events-0_0_1a4-python310;
              python = pkgs.python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-shared-artifact-changes-events-latest =
            pythoneda-shared-artifact-changes-events-latest-python310;
          pythoneda-shared-artifact-changes-events-latest-python38 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python38;
          pythoneda-shared-artifact-changes-events-latest-python39 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python39;
          pythoneda-shared-artifact-changes-events-latest-python310 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python310;
        };
        packages = rec {
          default = pythoneda-shared-artifact-changes-events-latest;
          pythoneda-shared-artifact-changes-events-0_0_1a4-python38 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-latest-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python38;
            };
          pythoneda-shared-artifact-changes-events-0_0_1a4-python39 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-latest-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python39;
            };
          pythoneda-shared-artifact-changes-events-0_0_1a4-python310 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-changes-shared =
                pythoneda-shared-artifact-changes-shared.packages.${system}.pythoneda-shared-artifact-changes-shared-latest-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-latest-python310;
            };
          pythoneda-shared-artifact-changes-events-latest =
            pythoneda-shared-artifact-changes-events-latest-python310;
          pythoneda-shared-artifact-changes-events-latest-python38 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python38;
          pythoneda-shared-artifact-changes-events-latest-python39 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python39;
          pythoneda-shared-artifact-changes-events-latest-python310 =
            pythoneda-shared-artifact-changes-events-0_0_1a4-python310;
        };
      });
}
