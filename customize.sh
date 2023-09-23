#!/system/bin/sh

tmp=$MODPATH/tmp
list=$tmp/List
names=$tmp/Names

if [ "$ARCH" = "arm" ] ; then
  # 32-bit
  wget=$MODPATH/tools/wget/armeabi-v7a/wget
  echo https://f-droid.org/repo/com.termux_118.apk>>$list
  echo https://f-droid.org/repo/com.termux_118.apk=Termux-118>>$names
else
  # 64-bit
  wget=$MODPATH/tools/wget/arm64-v8a/wget
  echo https://f-droid.org/repo/com.termux_118.apk>>$list
  echo https://f-droid.org/repo/com.termux_118.apk=Termux-118>>$names
fi

chmod 777 $wget

echo
echo
echo Downloading... 
for i in $(cat $list)
do
  name=`grep ^$i= $names | cut -d "=" -f 2`
  echo    - $name...
  $wget -q --no-check-certificate -O "$tmp/$name.apk" "$i"
done

sleep 1

echo
echo
echo Installing... 
for i in $(cat $list)
do
  name=`grep ^$i= $names | cut -d "=" -f 2`
  echo    - $name...
  pm install --dont-kill "$tmp/$name.apk" > /dev/null 2>&1
done
sleep 1

echo
echo
echo Cleaning... 
for i in $(cat $list)
do
  name=`grep ^$i= $names | cut -d "=" -f 2`
  echo    - $name...
  rm -rf "$tmp/$name.apk" > /dev/null 2>&1
done

rm -rf $MODPATH/tmp
rm -rf $MODPATH/tools

echo > $MODPATH/remove
echo > $MODPATH/disabled
echo > /data/adb/modules/$MODID/remove
echo > /data/adb/modules/$MODID/disabled

echo
echo
echo
echo visit https://repo-magisk.netlify.app/ for more modules
echo
echo Enjoy! 😉
echo
