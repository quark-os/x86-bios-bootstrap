bootstrap_src = bootstrap.asm fs.asm util.asm

.PHONY: x86-bios-bootstrap
x86-bios-bootstrap: #$(addprefix x86-bios-bootstrap/, $(bootstrap_src))
	nasm src/bootstrap.asm -o bin/x86-bios-bootstrap -O0
	mkefs ~/quark -o bin/boot.img -b charm
	mksysimg bin/boot.img -m bin/x86-bios-bootstrap -o bin/sys.img
