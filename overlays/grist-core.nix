final: prev: {
  grist-core =
    with final;
    stdenv.mkDerivation (finalAttrs: {
      pname = "grist-core";
      version = "1.3.0";
      __inpure = true;

      src = fetchFromGitHub {
        owner = "gristlabs";
        repo = "grist-core";
        rev = "v${finalAttrs.version}";
        sha256 = "sha256-xrldE455vlvDYlI2oHIARjYSZmifEPT73c8N3PmVFyQ=";
      };

      patches = [ ./grist-core.patch ];

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = finalAttrs.src + "/yarn.lock";
        hash = "sha256-Hyv4zlnD2P8tdKguI9FHSfc4RG030nET4aFY2lMH1sw=";
      };

      buildPhase = ''
        patchShebangs --build buildtools
        yarn --offline run build:prod
      '';

      installPhase = ''
        mkdir -p $out
        yarn --prefer-offline install
        cp -r node_modules $out/node_modules
        cp -r _build $out/_build
        cp -r static $out/static
        cp -r sandbox $out/sandbox
        cp package.json $out/package.json
        cp -r bower_components $out/bower_components
        cp -r plugins $out/plugins
      '';

      nativeBuildInputs = [
        yarnConfigHook
        nodejs
      ];

      # meta = with lib; {
      #   description = "My Yarn package from GitHub";
      #   homepage = "https://github.com/github-user/repo-name"; # Replace with the project homepage
      #   license = licenses.mit; # Replace with the correct license
      #   maintainers = [ maintainers.your-name ]; # Replace with your Nixpkgs maintainer handle
      # };
    });
}
