#!/bin/bash
echo "$(date '+%F %T') oksijen kontrolu yapildi: %$((RANDOM % 3 + 20))" >> "/home/sude/ares1/oksijen_raporu.txt"
