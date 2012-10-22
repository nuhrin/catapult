NULL =

SRC_FILES = \
	$(top_srcdir)/src/*.vala \
	$(top_srcdir)/src/Helpers/*.vala \
	$(top_srcdir)/src/Helpers/IndirectGenerics/*.vala \
	$(top_srcdir)/src/Helpers/IndirectGenerics.Gee/*.vala \
	$(top_srcdir)/src/Yaml/*.vala \
	$(top_srcdir)/src/Yaml/Events/*.vala \
	$(NULL)

bookdir=$(datadir)/devhelp/books/catapult
imgdir=$(datadir)/devhelp/books/catapult/img

book_data = \
	catapult/catapult.devhelp2 \
	catapult/*.css \
	catapult/*.js \
	catapult/*.html \
	catapult/*.png \
	$(NULL)

book_DATA = \
	catapult/index.htm \
	$(book_data) \
	$(NULL)

img_DATA = \
	catapult/img/*.png \
	$(NULL)

$(book_data) $(img_DATA): catapult/index.htm

if ENABLE_DEVHELP
devhelp_dist = \
	$(book_DATA) \
	$(img_DATA) \
	$(NULL)
endif

catapult/index.htm:
	$(VALADOC) $(VALADOC_OPTIONS) --doclet=devhelp --driver=0.18.x --vapidir=$(top_srcdir)/vapi --pkg gee-0.8 --pkg gio-2.0 --pkg gobject-patch --pkg libyaml -o catapult/ --force -b $(top_srcdir) $(SRC_FILES)
	mv catapult tmp
	mv tmp/catapult .
	rmdir tmp

EXTRA_DIST = $(devhelp_dist)

clean-local:         
	-rm -rf pandora-glib
