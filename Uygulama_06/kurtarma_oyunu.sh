#!/bin/bash
# Veri Merkezi Kurtarma Oyunu
# Surec yonetimi tekrar alistirmasi

echo "=========================================="
echo "   VERI MERKEZI ALARMI!"
echo "   Sunucular asiri isindi. 20 dakika icinde"
echo "   sistemi kurtarmazsan tum veriler kaybolacak."
echo "=========================================="

# 1) Her 7 saniyede bir uyari mesaji
(
  while true; do
    echo "!!! UYARI: Sunucu sicakligi kritik seviyede !!!"
    sleep 7
  done
) &

# 2) 1 dakika sonra CPU'yu zorlayan iki surec
(
  sleep 60
  echo ">>> Sogutma fanlari durdu! Islemci zorlaniyor..."
  bash -c 'while true; do :; done # fan_arizasi_1' &
  bash -c 'while true; do :; done # fan_arizasi_2' &
) &

# 3) 20 dakika sonra oyunu bitirecek zamanlanmis gorev
if command -v at > /dev/null; then
  echo "pkill -f fan_arizasi; pkill -f kurtarma_oyunu.sh; echo 'OYUN BITTI: Veriler kayboldu.' > $HOME/oyun_sonucu.txt" | at now + 20 minutes 2> /dev/null
  echo "Geri sayim basladi. Zaman doldugunda oyun bitecek."
else
  echo "HATA: 'at' komutu kurulu degil. Once 'sudo apt install at' ile kurun."
fi
