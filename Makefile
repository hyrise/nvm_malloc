CC := gcc
debug:   CFLAGS := -O0 -ggdb -fpic -Wall -I. -Iulib-svn/include
release: CFLAGS := -O3 -fpic -Wall -I. -Iulib-svn/include
LDFLAGS := -lpthread

SRCDIR := src
OBJDIR := objects
OBJECTS := util.o chunk.o object_table.o arena.o nvm_malloc.o
LIBNAME := libnvmmalloc.so

release: $(LIBNAME) libnvmmallocnoflush.so libnvmmallocnofence.so libnvmmallocnone.so

debug: $(LIBNAME)

$(LIBNAME): ulib-svn/lib/libulib.a $(addprefix $(OBJDIR)/, $(OBJECTS))
	$(CC) $(CFLAGS) -shared -o $@ $(addprefix $(OBJDIR)/, $(OBJECTS)) ulib-svn/lib/libulib.a $(LDFLAGS)

libnvmmallocnoflush.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFLUSH $+ ulib-svn/lib/libulib.a $(LDFLAGS)

libnvmmallocnofence.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFENCE $+ ulib-svn/lib/libulib.a $(LDFLAGS)

libnvmmallocnone.so: $(SRCDIR)/*.c ulib-svn/lib/libulib.a
	$(CC) $(CFLAGS) -shared -o $@ -DNOFLUSH -DNOFENCE $+ ulib-svn/lib/libulib.a $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(SRCDIR)/*.h
	@mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

ulib-svn/lib/libulib.a:
	cd ulib-svn; make release

clean:
	@rm -f $(LIBNAME) libnvmmallocnoflush.so libnvmmallocnofence.so libnvmmallocnone.so
	@rm -rf $(OBJDIR)

.PHONY: test debug release
