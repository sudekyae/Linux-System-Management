#!/bin/bash
# ARES-1 dönüş kapsülü kalkış sistemi
DOGRU="e8c62128636741ec6c090518fd440a57"
if [ $# -ne 1 ]; then
  echo "Kullanım: ./kalkis.sh KALKIS-SIFRESI"
  exit 1
fi
OZET=$(printf '%s' "$1" | md5sum | cut -c1-32)
if [ "$OZET" != "$DOGRU" ]; then
  echo "❌ Şifre hatalı! Kapsül kilitli. Parçaların sırasını ve yazımını kontrol et."
  exit 1
fi
for i in 5 4 3 2 1; do echo "   Kalkışa $i..."; sleep 1; done
cat <<'R'
            /\
           /  \
          | ** |
          |ARES|
          | -1 |
         /|    |\
        / |    | \
       |  |____|  |
       |_/ |  | \_|
          /____\
          ||||||
         ((((()))))
        (( (( )) ))
         ( (( )) )

  🚀  KALKIŞ BAŞARILI!  Toz fırtınasından kaçtınız.
      Dünya'ya dönüş yolculuğu başladı. Tebrikler mühendis!
R
