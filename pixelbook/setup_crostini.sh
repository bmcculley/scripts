#!/bin/bash
# Setup a new Crostini container

# source the configuration file.
. ./crostini_config.sh

# install sublimetext
if [ "$INSTALL_SUBLIME_TEXT" = true ]; 
then
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  if [ "$SUBLIME_CHANNEL" = stable ]; 
  then
    # stable channel
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  else
    # dev channel
    echo "deb https://download.sublimetext.com/ apt/dev/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  fi
  sudo apt-get update
  sudo apt-get install -y sublime-text
fi

# install firefox
if [ "$INSTALL_FIREFOX" = true ]; 
then
  if [ $(dpkg-query -W -f='${Status}' bzip2 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    sudo apt-get install -y bzip2;
  fi

  if [ $(dpkg-query -W -f='${Status}' libdbus-glib-1-2 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    sudo apt-get install -y libdbus-glib-1-2;
  fi

  curl -sL "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -o firefox.tar.bz2
  tar -xjf firefox.tar.bz2
  sudo mv firefox /opt/firefox
  sudo ln -s /opt/firefox/firefox /usr/bin/firefox
  rm firefox.tar.bz2

  sudo bash -c 'cat > /usr/share/applications/firefox.desktop << EOL
  [Desktop Entry]
  Name=Firefox
  Comment=Browse the World Wide Web
  Icon=/opt/firefox/browser/chrome/icons/default/default128.png
  Exec=/opt/firefox/firefox %u
  Type=Application
  Categories=Network;WebBrowser;
  EOL'
  sudo chown root:root /usr/share/applications/firefox.desktop
fi

# install gnome terminal
if [ "$INSTALL_GNOME_TERMINAL" = true ]; 
then
  sudo apt-get install -y gnome-terminal