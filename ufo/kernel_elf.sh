#!/bin/sh

i2k(){
	#local M=5690Pro_08.03.all_freetz-ng-60e2f6d073-ufo_20251129-164123
	local M=5690Pro_08.03.all_freetz-ng-24df4d3ec9-ufo_20251204-174926
	for f in $@
	do
		local F=$(echo $f | sed -rn 's/(.*).image/\1/p')
		tar -xf $f ./var/tmp/fit-image
		~/git/freetz-ng/tools/path/fitdump var/tmp/fit-image
		rm -rf var
		cp fit-dump/image.001 $F.kernel.bin.lzma
		rm -rf fit-dump
		lzma -kdf $F.kernel.bin.lzma
		~/git/freetz-ng/source/kernel/ref-alder-5690_08.01/linux-5.4/scripts/extract-ikconfig $F.kernel.bin > $F.kernel.config
		diff -u --color $M.kernel.config $F.kernel.config
		diff -u $M.kernel.config $F.kernel.config > $F.kernel.config.diff
		diff -u <(xxd $M.kernel.bin) <(xxd $F.kernel.bin) > $F.kernel.bin.diff
	done
}
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
ksgap(){	printf '0x%x\n' $(($(ksfield addr $1 $((1+$2)))-$(ksfield addr $1 $2)-$(ksfield size $1 $2))); }

updatemodversions(){
	k=source/kernel/ref-alder-5690_08.01/linux-5.4/Module.symvers
	f=build/original/filesystem/lib/modules/5.4.213/piglet_noemif/Piglet_noemif.ko
	x=$(xxd -p -c0 $f)
	p=0
	for s in $(modprobe --dump-modversions $f | sed -r 's/\t//')
	do
		h=$(echo $s | sed -rn 's/0x(.{8})(.*)/\1/p')
		n=$(echo $s | sed -rn 's/0x(.{8})(.*)/\2/p')
		u=$(grep -w $n $k | sed -rn 's/0x(.{8}).*/\1/p')
		if [ $u ] && [ $h != $u ]
		then
			((p++))
			H=$(echo -n $h | tac -rs ..)
			U=$(echo -n $u | tac -rs ..)
			N=$(echo -n $n | xxd -p -c0)
			echo $h $u $n
			local y=$(echo $x | sed 's/'$H$N'/'$U$N'/')
			x=$y
		fi
	done
	echo $x | xxd -r -p > $f.ufo
	printf '%4d\n' $p
}
