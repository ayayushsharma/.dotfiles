echo "Removing JetBrainsMono font downloads if they already exist"
rm /tmp/JetBrainsMono.zip
rm /tmp/JetBrainsMono -rf

echo "Downloading JetBrainsMono fonts"
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
unzip /tmp/JetBrainsMono.zip -d /tmp/JetBrainsMono

echo "Removing JetBrainsMono System Installation"
rm /usr/share/fonts/JetBrainsMono -rf
echo "Copying the new fonts to System Installation"
cp /tmp/JetBrainsMono /usr/share/fonts/ -r

echo "Caching All Fonts"
fc-cache -f -v
