directory = /usr/local/bin/


example.html: test.md
	./markdown.awk $< >| $@


.PHONY: clean install uninstall

clean:
	rm -f example.html

install:
	mkdir -p $(directory)
	cp markdown.awk $(directory)

uninstall:
	cd $(directory)
	rm -f mardown.awk
