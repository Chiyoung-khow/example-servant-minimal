final: prev: with final; {


  haskellPackages = prev.haskellPackages.override (old: {
    overrides = lib.composeManyExtensions (with haskell.lib; [
                  (old.overrides or (_: _: {}))
                  (self: super: {
                    # formatting = self.formatting_7_1_2;
                    colonnade = doJailbreak (markUnbroken super.colonnade);
                    streaming-utils = doJailbreak (markUnbroken super.streaming-utils);
                  })
                  (packageSourceOverrides { example-servant-minimal = ./.; })
                ]);
  });

  example-servant-minimal = haskell.lib.justStaticExecutables haskellPackages.example-servant-minimal;

  ghcWithexample-servant-minimal = haskellPackages.ghcWithPackages (p: [ p.example-servant-minimal ]);

  ghcWithexample-servant-minimalAndPackages = select :
    haskellPackages.ghcWithPackages (p: ([ p.example-servant-minimal ] ++ select p));


  jupyterlab = mkJupyterlab {
    haskellKernelName = "example-servant-minimal";
    haskellPackages = p: with p;
      [ # add haskell pacakges if necessary
        example-servant-minimal
        hvega
        ihaskell-hvega
      ];
    pythonKernelName = "example-servant-minimal";
    pythonPackages = p: with p;
      [ # add python pacakges if necessary
        scipy
        numpy
        tensorflow-bin
        matplotlib
        scikit-learn
        pandas
        lightgbm
      ];
  };
}
