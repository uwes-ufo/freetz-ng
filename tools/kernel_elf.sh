#!/bin/sh

kernel_xxd(){
	ls -l ~/git/freetz-ng/build/*/kernel/
	cp ~/git/freetz-ng/source/kernel/ref-alder-5690_08.01/linux-5.4/vmlinux kernel.elf
	cp ~/git/freetz-ng/build/original/kernel/kernel.raw kernel.ori.lzma
	cp ~/git/freetz-ng/build/modified/kernel/kernel.raw kernel.mod.lzma
	lzma -fd kernel.ori.lzma
	lzma -fd kernel.mod.lzma
	xxd -c4 kernel.ori > kernel.ori.xxd
	xxd -c4 kernel.mod > kernel.mod.xxd
	ls -lt
}
kernel_diff(){
	kernel_xxd
	diff -u <(sed -rn 's/.{8}(.*)/\1/p' kernel.ori.xxd) <(sed -rn 's/.{8}(.*)/\1/p' kernel.mod.xxd) > kernel.diff
	ls -lt
}
ksfield(){
	local F=$1
	case $F in
		name)	F=1 ;;
		type)	F=2 ;;
		addr)	F=3 ;;
		off)	F=4 ;;
		size)	F=5 ;;
	esac
	[ $F -ge 3 ] && echo -n 0x
	readelf -S $2 | sed -rn 's/ +\['"$(printf '%2d' $3)"'\] +([^ ]+) +([^ ]+) +([^ ]+) ([^ ]+) ([^ ]+).*/'\\$F'/p'
}
kspay(){	tail -c+$((1+$(ksfield off $1 $2))) $1 | head -c$(($(ksfield size $1 $2))); }
#relloc(){	printf '0x%x\n' $(($(ksfield addr $1 $3)-$(ksfield addr $1 $2))); }
ksgap(){	printf '0x%x\n' $(($(ksfield addr $1 $3)-$(ksfield addr $1 $2)-$(ksfield size $1 $2))); }
