#!/bin/sh

echo '<h1>$(lang de:"Aktuelle Firmwareversion" en:"Latest firmware version")</h1>'

LAST="$(date -d @$(stat -c %Y /tmp/.juis_check) +'%d.%m.%Y %H:%M:%S' 2>/dev/null)"
echo "<ul><li>$(lang de:"Letzte &Uuml;berpr&uuml;fung" en:"Last check"): ${LAST:-niemals}</li></ul>"

vfromk() {
	sed -rn "s/.*<ns3:$1>(.*)<\/ns3:$1>.*/\1/p" /tmp/.juis_check 2>/dev/null
}
if [ -n "$LAST" ]; then
	echo '<pre>'
	if [ "$(vfromk Found)" == "true" ]; then
		IVER="$(sed -nr 's/^firmware_info[ \t]*//p' /proc/sys/urlader/environment)"
		IREV="$(/etc/version --project)"
		[ -z "$IREV" ] && IREV="$(/etc/version -vsub | sed 's/-//')"
		echo "$(lang de:"Installierte Version" en:"Installierte version"): $IVER-${IREV:-0}"
		echo '</pre><pre>'
		echo -n "$(lang de:"Neueste Version" en:"Latest version"): "
		VERS="$(vfromk Version | sed 's/-/ rev/')"
		NAME="$(vfromk Name)"
		[ -n "$NAME" ] && echo "<a title='$NAME'>${VERS:-$NAME}</a>" || echo "${VERS:-$(lang de:"Unbekannt" en:"Unknown")}"
		TEXT="$(vfromk InfoText)"
		IURL="$(vfromk InfoURL)"
		[ -n "$IURL" ] && echo "$(lang de:"Changelog" en:"Changelog"): <a target="_blank" href=$IURL>${TEXT:-${IURL##*/}}</a>"
		DURL="$(vfromk DownloadURL)"
		[ -n "$DURL" ] && echo "$(lang de:"Download" en:"Download"): <a href=$DURL>${DURL##*/}</a>"
	else
		echo "$(lang de:"Keine Firmware gefunden" en:"No firmware found")"
	fi
	echo '</pre>'
fi

stat_button juis_check '$(lang de:"Firmwareversion pr&uuml;fen" en:"Check firmware version")'
