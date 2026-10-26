#!/usr/bin/env bash
# AutoPatch
# Author: Etar125 Admanse <admanse@etar125.ru> / <Admanse@yandex.ru>
# Date: 2025-08-15
# License: WTFPL v2

# Список URL патчей для скачивания, в качестве примера, нужные мне патчи для st
# https://st.suckless.org/patches/anysize/st-anysize-0.8.4.diff https://st.suckless.org/patches/kitty-graphics-protocol/st-kitty-graphics-20240922-a0274bc.diff
patches="https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20230819-3a6d6d7.diff https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff https://st.suckless.org/patches/clipboard/st-clipboard-0.8.3.diff https://st.suckless.org/patches/csi_22_23/st-csi_22_23-0.8.5.diff https://st.suckless.org/patches/defaultfontsize/st-defaultfontsize-20210225-4ef0cbd.diff https://st.suckless.org/patches/w3m/st-w3m-0.8.3.dif"

# DWM
#patches="https://dwm.suckless.org/patches/alpha/dwm-alpha-6.4.diff https://dwm.suckless.org/patches/alttab2/dwm-alttab2+winview-6.4.diff https://dwm.suckless.org/patches/alwaysontop/alwaysontopall-6.2.diff "

reverse=n
[ "$1" == "r" ] && reverse=y

index=0

continue_on_error=y # y - продолжать, любое другое значение - нет

echo "Загрузка патчей..."

for p in $patches; do
    [ -f "patch$index.diff" ] && index=$(expr $index + 1) && continue
    [ -z "$p" ] && index=$(expr $index + 1) && continue
	echo "$index: $p"
    wget -q $p -O "patch$index.diff"
    [ $? != 0 ] && [ "$continue_on_error" != "y" ] && exit 1
    index=$(expr $index + 1)
done

([ "$reverse" == "n" ] && echo "Применение патчей...") || echo "Откат патчей..."

i=0

if [ "$reverse" == "n" ]; then
while [ $i -lt $index ]; do
    echo "Применение патча $i"
    patch -s -p1 < "patch$i.diff"
    [ $? != 0 ] && [ "$continue_on_error" != "y" ] && exit 1
    i=$(expr $i + 1)
done
else
while [ $index -ge 0 ]; do
    echo "Откат патча $index"
    patch -s -p1 -R < "patch$index.diff"
    [ $? != 0 ] && [ "$continue_on_error" != "y" ] && exit 1
    index=$(expr $index - 1)
done
fi

echo "{ MODKEY|ShiftMask, XK_space, togglealwaysontop, {0} },"
