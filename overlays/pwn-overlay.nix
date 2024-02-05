final: prev: rec {
  pwndbg = prev.callPackage ./packages/pwndbg.nix {};
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [ (pyfinal: pyprev: {
		pwntools = pyfinal.callPackage ./packages/pwntools.nix { debugger = pwndbg; };
	}) ];
}
