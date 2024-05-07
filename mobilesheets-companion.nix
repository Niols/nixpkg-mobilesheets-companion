{ stdenv
, lib
, mkWindowsApp
, wine
, fetchurl
, makeDesktopItem
, makeDesktopIcon
, copyDesktopItems
, copyDesktopIcons
}:

mkWindowsApp rec {
  inherit wine;

  pname = "mobilesheets-companion";
  version = "3.2.0";

  src = fetchurl {
    url = "https://www.zubersoft.download/MobileSheetsProCompanion.exe";
    sha256 = "16h4hah5r7rfpbn8vsys5v0pi8b0wibkzcgbca55i632qgha98bv";
  };

  nativeBuildInputs = [ copyDesktopItems copyDesktopIcons ];
  dontUnpack = true;

  winAppInstall = ''
    $WINE ${src} /install /quiet
  '';

  winAppRun = ''
   $WINE "$WINEPREFIX/drive_c/Program Files/Zubersoft/MobileSheetsCompanion/MobileSheetsCompanion.exe" "$ARGS"
  '';

  installPhase = ''
    runHook preInstall
    ln -s $out/bin/.launcher $out/bin/${pname}
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "MobileSheets Companion";
      exec = pname;
      icon = pname;
      desktopName = "MobileSheets Companion";
    })
  ];

  desktopicon = makeDesktopIcon {
    name = pname;
    icoIndex = 2;

    src = fetchurl {
      url = "https://zubersoft.download/_astro/logo.Dgdo-ur4.png";
      sha256 = "0rrpp2b6ckp6n5nk5wmdqii0yxdqw771sgmq62ayk0ilxxk2lkgk";
    };
  };

  meta = with lib; {
    homepage = "https://zubersoft.com/mobilesheets/companion/";
    maintainers = with maintainers; [ niols ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    mainProgram = pname;
  };
}
