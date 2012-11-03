NULL =

SRC_FILES = \
	$(top_srcdir)/src/Helpers/*.vala \
	$(top_srcdir)/src/Helpers/IndirectGenerics/*.vala \
	$(top_srcdir)/src/Helpers/IndirectGenerics.Gee/*.vala \
	$(top_srcdir)/src/Yaml/Events/*.vala \
	$(top_srcdir)/src/Yaml/Constants.vala \
	$(top_srcdir)/src/Yaml/NodeBuilder.vala \
	$(top_srcdir)/src/Yaml/NodeParser.vala \
	$(top_srcdir)/src/Yaml/DocumentReader.vala \
	$(top_srcdir)/src/Yaml/DocumentWriter.vala \
	$(top_srcdir)/src/Yaml/Document.vala \
	$(top_srcdir)/src/Yaml/Node.vala \
	$(top_srcdir)/src/Yaml/ScalarNode.vala \
	$(top_srcdir)/src/Yaml/SequenceNode.vala \
	$(top_srcdir)/src/Yaml/MappingNode.vala \
	$(top_srcdir)/src/Yaml/Enums.vala \
	$(top_srcdir)/src/Yaml/Functions.vala \
	$(top_srcdir)/src/IYamlObject.vala \
	$(top_srcdir)/src/YamlObject.vala \
	$(top_srcdir)/src/Entity.vala \
	$(top_srcdir)/src/DataInterface.vala \
	$(top_srcdir)/src/EntityProvider.vala \
	$(top_srcdir)/src/Enumerable.vala \
	$(top_srcdir)/src/Error.vala \
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
	$(VALADOC) $(VALADOC_OPTIONS) --doclet=devhelp --driver=0.18.x --vapidir=$(top_srcdir)/vapi $(GEE_VALAFLAGS) \
		--pkg gee-0.8 --pkg gio-2.0 --pkg gobject-patch --pkg libyaml -o catapult/ --force -b $(top_srcdir) $(SRC_FILES)
	mv catapult tmp
	mv tmp/catapult .
	rmdir tmp

EXTRA_DIST = $(devhelp_dist)

clean-local:         
	-rm -rf catapult
