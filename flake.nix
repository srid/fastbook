{
  description = "fastbook";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, flake-utils, nixpkgs, ... } @ inputs:
    flake-utils.lib.eachSystem
      [
        flake-utils.lib.system.aarch64-darwin
        flake-utils.lib.system.x86_64-linux
      ]
      (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          formatter = pkgs.nixpkgs-fmt;
          packages.default = pkgs.python3.withPackages (ps: with ps; [
            pandas
            jupyter
            nbdev
            matplotlib
            scikit-learn
            graphviz
            fastai
            sentencepiece
            ipywidgets
            # azure-cognitiveservices-search-imagesearch
          ]);
          apps.default.program = "${packages.default}/bin/jupyter-lab";
          apps.default.type = "app";
        }
      );
}
