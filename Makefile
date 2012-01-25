CC      = gcc
CFLAGS  = -c -g -O2 -Wall
LDFLAGS =

SRC     = $(wildcard *.c)
OBJ     = $(SRC:.c=.o)

GIT2LOG := $(shell if [ -x ./git2log ] ; then echo ./git2log --update ; else echo true ; fi)
GITDEPS := $(shell [ -d .git ] && echo .git/HEAD .git/refs/heads .git/refs/tags)

VERSION := $(shell $(GIT2LOG) --version VERSION ; cat VERSION)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

changelog: $(GITDEPS)
	$(GIT2LOG) --changelog changelog

all: checkmedia

checkmedia: $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) -o $@

install: checkmedia
	install -m 755 -D checkmedia tagmedia $(DESTDIR)/usr/bin

clean:
	rm -f $(OBJ) checkmedia *~
