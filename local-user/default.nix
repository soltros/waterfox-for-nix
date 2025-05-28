{ pkgs ? import <nixpkgs> { } }:

let
  pname   = "waterfox";
  version = "6.5.9";           # <- update.sh rewrites this

  sha256  = "mmpiscoywzntlmcmbio34cuoyusdkovmw4heekrgdbzah6agw3vq"; # <- update.sh rewrites this
in
pkgs.stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url    = "https://cdn1.waterfox.net/waterfox/releases/${version}/Linux_x86_64/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = with pkgs; [ autoPatchelfHook copyDesktopItems wrapGAppsHook ];
  buildInputs       = with pkgs; [
    alsa-lib dbus-glib gtk3 stdenv.cc.cc.lib xorg.libXtst libva pciutils curl
    nss nspr libpulseaudio
  ];

  unpackPhase  = "tar -xjf $src";
  dontBuild    = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/{bin,lib/waterfox,share/icons/hicolor/128x128/apps}
    cp -r waterfox/* $out/lib/waterfox/
    ln -s $out/lib/waterfox/waterfox $out/bin/waterfox
    if [ -f $out/lib/waterfox/browser/chrome/icons/default/default128.png ]; then
      cp $out/lib/waterfox/browser/chrome/icons/default/default128.png \
         $out/share/icons/hicolor/128x128/apps/waterfox.png
    fi
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name           = pname;
      desktopName    = "Waterfox";
      genericName    = "Web Browser";
      exec           = "waterfox %U";
      icon           = pname;
      mimeTypes      = [
        "application/vnd.mozilla.xul+xml" "application/xhtml+xml"
        "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https"
      ];
      categories     = [ "Network" "WebBrowser" ];
      startupNotify  = true;
      startupWMClass = "waterfox";
      terminal       = false;
    })
  ];

  meta = with pkgs.lib; {
    description = "Fast and private web browser";
    homepage    = "https://www.waterfox.net/";
    license     = licenses.mpl20;
    platforms   = [ "x86_64-linux" ];
  };
}
