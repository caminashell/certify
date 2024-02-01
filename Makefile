CMD=-v -f ./certify.sh -o ./bin/certify

make:
	@mkdir -p bin
	@shc $(CMD)

dist:
	@mkdir -p bin
	@shc $(CMD) -r

install:
	@sudo ln -s $(PWD)/bin/certify /usr/local/bin/certify

uninstall:
	@sudo rm /usr/local/bin/certify
