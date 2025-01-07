final: prev: {
  grist-node-sqlite3 =
    with final;
    stdenv.mkDerivation (finalAttrs: {
      pname = "grist-node-sqlite3";
      version = "5.1.4-grist.8";

      src = fetchFromGitHub {
        owner = "gristlabs";
        repo = "node-sqlite3";
        rev = "v${finalAttrs.version}";
        sha256 = "sha256-xrldE455vlvDYlI2oHIARjYSZmifEPT73c8N3PmVFyQ=";
      };

      patches = [ ./grist-node-sqlite3.patch ];

      postPatch = ''
        ls
      '';

      buildPhase = ''
        npm install --build-from-source
      '';

      installPhase = ''
        mkdir -p $out
        cp -r deps $out/deps
        cp -r lib $out/lib
        cp binding.gyp $out/binding.gyp
        cp package.json $out/package.json
      '';

      nativeBuildInputs = [
        nodejs
        python3
      ];

      # meta = with lib; {
      #   description = "My Yarn package from GitHub";
      #   homepage = "https://github.com/github-user/repo-name"; # Replace with the project homepage
      #   license = licenses.mit; # Replace with the correct license
      #   maintainers = [ maintainers.your-name ]; # Replace with your Nixpkgs maintainer handle
      # };
    });
}
