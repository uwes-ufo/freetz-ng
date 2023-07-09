#! /usr/bin/env bash
# generates docs/osp/README.md
SCRIPT="$(readlink -f $0)"
PARENT="$(dirname $(dirname ${SCRIPT%/*}))"


#get
LANG=C  wget --spider --recursive --no-verbose --no-parent 'https://osp.avm.de' 2>&1 | tee osp
sed -rn 's,.* URL: (.*) 200 OK,\1,p' -i osp

#cat
for cat in $(sed 's,^https://osp.avm.de/,,;s,/.*,,g' osp | uniq); do
c="$cat"
[ "${cat#fritz}" != "$cat" ] && cat="${cat:5}" && cat="Fritz${cat^}"
CATS="$CATS$c $cat\n"
done

#gen
(
echo -e '[//]: # ( Do not edit this file! Run generate.sh to create it. )'
echo -n "Content: "
echo -e "$CATS" | grep -v ^$ | while read c cat; do echo -n "[$cat](#$(echo ${cat,,} | sed 's/ /-/g')) - "; done | sed 's/...$//'
echo
echo -e '# Temporär verfügbare Open-Source Konglomerate von AVM-Osp'
echo -e ' - AVM veröffentlicht nur riesige Konglomerate die fast 1GB erreichen können. Diese enthalten entpackten und modifizierten Quellcode, was genau verändert wurde darf sich jeder selbst zusammensuchen.'
echo -e ' - Um diese Konglomerate richtig schön aufzublähen befindet sich überflüssiger Kram wie unveränderte Kernelquellen von über 100MB darin.'
echo -e ' - Die enthaltenen .config der libc, busybox oder des Kernels ist nicht unbedingt aktuell und passt in letzter Zeit normalerweise nicht zu den Kernelquellen.'
echo -e ' - Ohne Konglomerat sind Kernelmodule in Freetz deaktiviert. Replace-Kernel ist ab dem neuesten Kernel v4 grundsätzlich deaktiviert, da es nicht vollständig klar ist wie dieser zusammenschustert wird.'
echo -e ' - Fehlende Konglomerate können digitalisierte bei fritzbox_info@avm.de beantragt werden. AVM schafft es leider nicht diesen Vorgang zu automatisieren.'
echo -e ' - Je nach Aufwand und/oder Wetter benötigt AVM für das Schnüren eines Konglomerates zwischen 1 Woche und 1 Jahr und es erscheint dann auf [https://osp.avm.de/](https://osp.avm.de/).'
echo -e ' - Obwohl es in der GPL für AVM keine Ausnahme gibt (What???), rückt AVM trotz Aufforderungen nur seltenst Konglomerate für öffentliche Alpha-Firmwares ("Labor") heraus - einfach mal selbst ausprobieren.'
echo -e ' - Vorsicht: AVM interpretiert den Mindestzeitraum in der GPL als Maximalzeitraum und gibt exakt danach kein Konglomerat mehr heraus!'
echo -e ' - Vorsicht: Auch löscht AVM gerne spontan Konglomerate, diese daher bitte lokal sichern!'
echo -e ' - Diese Liste ist weder vollständig, korrekt noch aktuell.'
echo -e "$CATS" | grep -v ^$ | while read c cat; do
	echo -e "\n### $cat"
	sed -rn "s,^https://osp.avm.de/$c/,,p" osp | while read -s line; do
		new="${line%%/*}"
		[ "$old" != "$new" ] && echo " * $new/" && old="$new"
		file="${line#$new/}"
		echo "   - [${file//%20/ }](https://osp.avm.de/$c/$line)"
	done
done
) | sed 's/_-/-/' > $PARENT/docs/osp/README.md

#tmp
rm -f osp
rmdir osp.avm.de/*/* osp.avm.de/* osp.avm.de/ 2>/dev/null

