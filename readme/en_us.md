## EN
#### Compiling
1. Install php4delphi, synedit and CEF4Delphi Packages from the project's dir
2. Open project file (SoulEngine.dpr or SoulEngine.dproj either)
3. Compile project, the output binaries will be in the `C:\DevelStudio 3.0Beta\`.

If you see error when running binaries, rather components 
installed uncorrectly or DevelStudio 3.0.4 
installation doesn't exist in 
final(end-point) build directory `C:\DevelStudio 3.0Beta\`


#### Additional extensions
Extensions with all included info located at the `ext/` directory.

#### Using conditionals
(in sDef.inc)
1) ADD_SYN - add Synedit to the build

   ADD_SYN_OPT - add additional SynEdit Highlighters Set
2) ADD_CHROMIUM - add CEF (Chromium Embedded Framework 69)
3) PHP560 - add PHP 5.6 up support
4) PHP_Unice - add partial unicode support




P.s Sorry for bicycles and so unclean code, but, if you look at the code i started from, you'll want to beat up Dim-S, whose code is worse than my.
