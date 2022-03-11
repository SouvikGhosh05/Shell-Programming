build:
	chmod +x ./shc_build.sh
	./shc_build.sh

clean:
	rm -rf ./bin
	rm -rf ./src/*.x.c