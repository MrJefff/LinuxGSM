if [ -d "../zip-updaterauto/" ]; then
exec ../zip-updaterauto/zipupdater
fi
if [ -d "../zip-updater/" ]; then
echo "Do you want to update oxide (yes/no) ?"
read answer
if [ $answer = yes ]
  then exec ../zip-updater/zipupdater
fi
fi
