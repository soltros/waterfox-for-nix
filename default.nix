{ pkgs
, lib ? pkgs.lib
}:

pkgs.stdenv.mkDerivation rec {
  pname   = "waterfox";
  version = "6.5.9";

  src = pkgs.fetchurl {
    url    = "https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
    sha256 = "0oouh44thdir6mo4o2gtno58th946ktapdoe88l2c63i0fs0ddnb";
  };

  nativeBuildInputs = with pkgs; [ autoPatchelfHook copyDesktopItems wrapGAppsHook ];
  buildInputs       = with pkgs; [ alsa-lib dbus-glib gtk3 stdenv.cc.cc.lib xorg.libXtst libva pciutils curl ];
  runtimeDependencies= with pkgs; [ curl libva.out pciutils ];
  appendRunpaths    = [ (lib.getLib pkgs.pipewire) ];

  ## phases ---------------------------------------------------------------
  unpackPhase   = ''runHook preUnpack; tar -xf $src; runHook postUnpack'';
  dontConfigure = true;
  dontBuild     = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/waterfox,share/icons/hicolor/128x128/apps}
    cp -r * $out/lib/waterfox/

    cat > $out/bin/waterfox <<EOF
#!/bin/sh
exec $out/lib/waterfox/waterfox "\$@"
EOF
    chmod +x $out/bin/waterfox

    if [ -f $out/lib/waterfox/browser/chrome/icons/default/default128.png ]; then
      cp $out/lib/waterfox/browser/chrome/icons/default/default128.png \
         $out/share/icons/hicolor/128x128/apps/waterfox.png
    fi
    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name        = "waterfox";
      desktopName = "Waterfox";
      genericName = "Web Browser";
      exec        = "waterfox %U";
      icon        = "waterfox";
      mimeTypes   = [
        "application/vnd.mozilla.xul+xml"
        "application/xhtml+xml"
        "text/html" "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      categories    = [ "Network" "WebBrowser" ];
      startupNotify = true;
      startupWMClass= "waterfox";
      terminal      = false;
      actions = {
        "new-window"      = { name = "New Window";       exec = "waterfox --new-window %U"; };
        "private-window"  = { name = "New Private Window"; exec = "waterfox --private-window %U"; };
        "profile-manager" = { name = "Profile Manager";  exec = "waterfox --ProfileManager"; };
      };
    })
  ];

  passthru = {
    binaryName      = "waterfox";
    libName         = "waterfox";
    inherit (pkgs) gtk3;
    alsaSupport     = true;
    pipewireSupport = true;
  };

  meta = with lib; {
    description      = "Fast and private web browser";
    homepage         = "https://www.waterfox.net/";
    license          = licenses.mpl20;
    platforms        = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
