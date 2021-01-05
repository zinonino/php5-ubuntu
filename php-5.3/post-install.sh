v=5.3
sudo rm -rf /usr/bin/pecl /usr/bin/pear* 2>/dev/null || true
for tool in pear peardev pecl php phar phar.phar php-cgi php-fpm php-config phpize; do
  if [ -e /usr/local/php/"$v"/bin/"$tool" ]; then
    sudo cp /usr/local/php/"$v"/bin/"$tool" /usr/bin/"$tool$v"
    sudo update-alternatives --install /usr/bin/"$tool" "$tool" /usr/bin/"$tool$v" 50
    sudo update-alternatives --set "$tool" /usr/bin/"$tool$v"
  fi
done
sudo update-alternatives --install /usr/lib/libphp5.so libphp5 /usr/local/php/"$v"/usr/lib/libphp"$v".so 50 && sudo ldconfig
ini_file=$(php --ini | grep "Loaded Configuration" | sed -e "s|.*:s*||" | sed "s/ //g")
sudo chmod 777 "$ini_file"
echo -e "\ndate.timezone=UTC\nmemory_limit=-1" >>"$ini_file"
sudo mkdir -p /usr/lib/systemd/system
sudo cp -f /usr/local/php/"$v"/etc/init.d/php"$v"-fpm /etc/init.d/php"$v"-fpm
sudo cp -f /usr/local/php/"$v"/etc/systemd/system/php-fpm.service /lib/systemd/system/php"$v"-fpm.service
sudo chmod a+x /usr/local/php/"$v"/bin/php-fpm-socket-helper
sudo service php"$v"-fpm start
