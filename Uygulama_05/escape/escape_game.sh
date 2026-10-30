#!/bin/bash

echo "=================================================="
echo "  Kacis oyunu basladi. Kacmak icin 30 dakikan var!"

terminal=$(tty)

# 5 dakika sonra calisacak ve oyunu kaybettiginizi belirten bir planli gorev olusturuyoruz
echo "echo Sure doldu. Oyunu kaybettiniz. Tum surecler durduruluyor. > $terminal; killall escape_game.sh" | at now + 30 minutes &


# 1 dakika sonra CPU yuku artiran bir engel olusturan bir gorev
echo "nice -n 5 bash -c 'echo Ek bir engel daha! CPU daha da zorlaniyor. > $terminal; while true; do : ; done' &" | at now + 1 minute &



# Arka planda surekli calisarak her 5 saniyede bir "Server'da kapali kaldiniz!!!" mesaji gosteren bir islem
(
  while true; do
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo " Server'da kapali kaldiniz. Cikis yolu bulmalisiniz."
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    sleep 5  # Her 5 saniyede bir mesaj goster
  done
) &

echo "=================================================="

# CPU kullanimi artiran arka plan islemi
(
  while true; do
    :  # Bos bir islem CPU'yu kullanir
  done
) &
