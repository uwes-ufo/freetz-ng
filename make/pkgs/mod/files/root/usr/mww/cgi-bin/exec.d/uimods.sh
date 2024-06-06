if [ "$REQUEST_METHOD" != POST ]; then
	echo "Status: 302 Found"
	echo "Location: $(href mod uimods)"
	exit
fi

eval "$(modcgi mod:key:val uimods)"
M="${UIMODS_MOD}"
K="${UIMODS_KEY}"
V="${UIMODS_VAL}"
X="settings/$K"

# redirect stderr to stdout so we see output in webif
exec 2>&1

cgi_begin 'uimods ...'
echo "<pre>"
echo "Processing ..."
echo
echo "mod := $M"
echo "key := $K"
echo
if [ -z "$M" -o -z "$K" ] ; then
	echo "Miserable failure, mod and/or key could not be empty."
	echo "abort."
else
	. /bin/env.mod.rcconf avm

	old="$(ctlmgr_ctl r "$M" "$X")"
	echo "old --> $old"

	echo "new --> $V"
	[ "$V" != "${V#-}" ] && SEP='--' || SEP=''
	ack="$(ctlmgr_ctl w "$M" "$X" $SEP "$V")"
	echo "ack --> $ack"

	chk="$(ctlmgr_ctl r "$M" "$X")"
	echo "chk --> $chk"

	echo
	[ "$V" != "$chk" ] && echo "failed." || echo "done."
fi
echo '</pre>'
back_button mod uimods
cgi_end
