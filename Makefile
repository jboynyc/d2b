PREFIX = /usr/local
CSC = csc
CSCFLAGS = -optimize-level 3
SRC = d2b.scm
OUT = ${SRC:.scm=}

all: egg d2b

egg:
	@echo Installing crossref egg and its dependencies.
	chicken-install

d2b:
	@echo Compiling d2b.
	$(CSC) $(CSCFLAGS) $(SRC) -o $(OUT)

install:
	@echo Installing d2b.
	install -D $(OUT) $(PREFIX)/bin

clean:
	@echo Cleaning.
	rm -f *.import.* *.so $(OUT)

.PHONY: all egg install clean
