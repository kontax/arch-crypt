.DEFAULT_GOAL := crypt
.PHONY: all crypt clean

all: clean crypt

crypt: clean
	@echo Generating iso file
	sudo mkarchiso -v -w /tmp/archiso-tmp crypt/

clean:
	@echo Removing temp files
	sudo rm -rf /tmp/archiso-tmp/
	sudo rm -rf out/*
