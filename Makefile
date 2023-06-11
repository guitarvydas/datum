ODIN_FLAGS ?= -debug -o:none

all:
	clear
	odin run . $(ODIN_FLAGS)
