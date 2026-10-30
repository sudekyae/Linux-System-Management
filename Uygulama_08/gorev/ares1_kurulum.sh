#!/bin/bash

U="$HOME/ares1"
TERM_YOLU=$(tty 2>/dev/null) || TERM_YOLU=""

echo "ARES-1 üssüne bağlanılıyor..."

# --- Önceki denemeden kalanları temizle ------------------------------
pkill -f "ares1/araclar/alarm_sistemi" 2>/dev/null
pkill -f "ares1/araclar/panel_hesapla" 2>/dev/null
pkill -f "ares1/araclar/toprak_analizi" 2>/dev/null
rm -rf "$U"

mkdir -p "$U"/{loglar,depo/haritalar,depo/yedekler,depo/fotograflar,kargo/karisik/"eski sefer",kasa,kapsul,araclar}

# --- Görev 3: gizli karşılama mesajı (1. parça) -----------------------
echo "Üsse hoş geldiniz, mühendis! İlk iş olarak üssün içini dolaşın." > "$U/BENI_OKU.txt"
cat > "$U/.hosgeldin" <<'X'
Merhaba yeni mühendis,
Dünya'ya acil dönmem gerekti, kusura bakma. Toz fırtınası yaklaşırken
kalkış şifresini güvenlik için 6 parçaya bölüp üssün farklı yerlerine
sakladım. Her görevi tamamladıkça bir parça bulacaksın.

1. PARÇA: KIZIL

Bol şans!
— Dr. Orhan
X
# --- Görev 4: oksijen günlüğü (2. parça: en çok KRITIK veren modül) ----
moduller=(ALFA BETA GAMA DELTA ZETA OMEGA)
RANDOM=2087
for ((i = 1; i <= 3000; i++)); do
  r=$((RANDOM % 100))
  if   ((r < 6));  then m=ZETA;                    s=KRITIK; msj="oksijen seviyesi tehlikeli"
  elif ((r < 9));  then m=${moduller[RANDOM % 6]}; s=KRITIK; msj="basinc dususu"
  elif ((r < 22)); then m=${moduller[RANDOM % 6]}; s=UYARI;  msj="filtre degisimi gerekli"
  elif ((r < 27)); then m=${moduller[RANDOM % 6]}; s=NORMAL; msj="deger kritik esigin altinda"
  else                  m=${moduller[RANDOM % 6]}; s=NORMAL; msj="oksijen %$((RANDOM % 5 + 19))"
  fi
  printf '2087-03-%02d %02d:%02d:%02d %s %s %s\n' $((i * 20 / 3000 + 1)) $((RANDOM % 24)) $((RANDOM % 60)) $((RANDOM % 60)) "$m" "$s" "$msj"
done > "$U/loglar/oksijen.log"

# --- Görev 5: dolu depo (3. parça: en büyük dosyanın adı) --------------
for i in $(seq 1 60); do head -c $((RANDOM % 30000 + 500)) /dev/urandom > "$U/depo/fotograflar/krater_$i.jpg"; done
for i in $(seq 1 20); do head -c $((RANDOM % 50000 + 500)) /dev/urandom > "$U/depo/haritalar/bolge_$i.map"; done
head -c 90M /dev/urandom > "$U/depo/yedekler/yedek_ORION.img"
head -c 70M /dev/urandom > "$U/depo/yedekler/.kara_kutu.bin"
head -c 30M /dev/urandom > "$U/depo/haritalar/eski_harita.img"
# --- Görev 6: karışık kargo (4. parça: toplam numune sayısı) -----------
K="$U/kargo/karisik"
for b in domates marul patates fasulye biber cilek nane; do echo "tohum: $b" > "$K/$b.bitki"; done
for i in $(seq 1 14); do echo "kaya numunesi $i" > "$K/kaya_$i.numune"; done
for i in $(seq 1 10); do : > "$K/gecici_$i.tmp"; done
echo "buz numunesi"  > "$K/eski sefer/kutup buzu.numune"
echo "toz numunesi"  > "$K/eski sefer/kizil toz.numune"
echo "meteor parcasi" > "$K/eski sefer/meteor parcasi.numune"
echo "uzay cilegi"   > "$K/eski sefer/uzay cilegi.bitki"
: > "$K/eski sefer/kayit.tmp"

# --- Görev 8: kasa (5. parça: yalnızca sahibinin okuyabildiği dosya) -----
izinler=(644 664 600 640 444 660 604 666 400 620)
for i in $(seq 0 9); do
  f="$U/kasa/kutu_$((i + 1)).txt"
  if [ "${izinler[$i]}" = 400 ]; then
    echo "5. PARÇA: FIRTINA" > "$f"
  else
    echo "Boş kutu. Burada parça yok, izinlere daha dikkatli bak!" > "$f"
  fi
  chmod "${izinler[$i]}" "$f"
done

# --- Görev 9: süreçler (6. parça: alarmın kapatma kodu) ----------------
cat > "$U/araclar/alarm_sistemi" <<'X'
#!/bin/bash
# ARES-1 meteor alarm sistemi (ARIZALI)
T="$1"
while true; do
  echo "$(date '+%T') METEOR ALARMI! (yanlis alarm)" >> "$HOME/ares1/loglar/alarm.log"
  if [ -n "$T" ] && [ -w "$T" ]; then
    printf '\n\a🚨 [ARES-1] METEOR ALARMI! Alarm sistemi arızalı... Susturmak için süreci bul!\n' > "$T"
  fi
  sleep 20 & wait $!
done
X
cat > "$U/araclar/panel_hesapla" <<'X'
#!/bin/bash
# Güneş paneli açı hesaplayıcı (sürekli çalışır)
while true; do echo "$(date '+%T') panel acisi: $((RANDOM % 90)) derece" > "$HOME/ares1/loglar/panel.log"; sleep 2 & wait $!; done
X
cat > "$U/araclar/toprak_analizi" <<'X'
#!/bin/bash
# Mars toprak analizi (çok uzun sürer)
echo "Toprak analizi başladı... (saatler sürer)"
sleep 7200
echo "Analiz tamamlandı: toprakta su izi bulundu!"
X
cat > "$U/araclar/oksijen_kontrol.sh" <<X
#!/bin/bash
echo "\$(date '+%F %T') oksijen kontrolu yapildi: %\$((RANDOM % 3 + 20))" >> "$U/oksijen_raporu.txt"
X
cat > "$U/araclar/uyandir.sh" <<X
#!/bin/bash
echo "\$(date '+%F %T') Gunaydin murettebat! Kahvaltı serada." >> "$U/uyandirma.txt"
X
chmod 755 "$U"/araclar/*
setsid nohup "$U/araclar/alarm_sistemi" "$TERM_YOLU" --kapatma-kodu=VEGA >/dev/null 2>&1 < /dev/null &
setsid nohup "$U/araclar/panel_hesapla" >/dev/null 2>&1 < /dev/null &

# --- Görev 11: kalkış betiği (bilerek çalıştırılabilir değil) -----------
cat > "$U/kapsul/kalkis.sh" <<'X'
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
X
chmod 644 "$U/kapsul/kalkis.sh"

echo
echo "Bağlantı kuruldu. Üs: $U"
echo "Dikkat: Meteor alarm sistemi arızalı, ekranınıza alarm mesajları gelebilir."
echo "Kolay gelsin, mühendis!"
