NULL =

AUTOMAKE_OPTIONS = subdir-objects

AM_CPPFLAGS = \
  $(GLIB_CFLAGS) \
  $(GIO_CFLAGS) \
  $(GEE_CFLAGS) \
  $(NULL)

BUILT_SOURCES = libcatapult_la_vala.stamp

lib_LTLIBRARIES = \
  libcatapult.la
  $(NULL)

libcatapult_la_VALASOURCES = \
	DataInterface.vala \
	Entity.vala \
	EntityProvider.vala \
	Enumerable.vala \
	Error.vala \
	IYamlObject.vala \
	TimerBlock.vala \
	Helpers/IndirectGenerics/IndirectBi.vala \
	Helpers/IndirectGenerics/IndirectFactory.vala \
	Helpers/IndirectGenerics/IndirectTri.vala \
	Helpers/IndirectGenerics/IndirectUni.vala \
	Helpers/IndirectGenerics.Gee/IndirectCollection.vala \
	Helpers/IndirectGenerics.Gee/IndirectList.vala \
	Helpers/IndirectGenerics.Gee/IndirectMap.vala \
	Helpers/IndirectGenericsHelper.vala \
	Helpers/RegexHelper.vala \
	Helpers/ValueHelper.vala \
	Yaml/Constants.vala \
	Yaml/Document.vala \
	Yaml/Enums.vala \
	Yaml/NodeBuilder.vala \
	Yaml/NodeParser.vala \
	Yaml/SequenceNode.vala \
	Yaml/DocumentReader.vala \
	Yaml/DocumentWriter.vala \
	Yaml/Events/AnchorAlias.vala \
	Yaml/Events/DocumentEnd.vala \
	Yaml/Events/DocumentStart.vala \
	Yaml/Events/EventEmitter.vala \
	Yaml/Events/EventEnums.vala \
	Yaml/Events/EventReader.vala \
	Yaml/Events/Event.vala \
	Yaml/Events/MappingEnd.vala \
	Yaml/Events/MappingStart.vala \
	Yaml/Events/Mark.vala \
	Yaml/Events/NodeEvent.vala \
	Yaml/Events/Scalar.vala \
	Yaml/Events/SequenceEnd.vala \
	Yaml/Events/SequenceStart.vala \
	Yaml/Events/StreamEnd.vala \
	Yaml/Events/StreamStart.vala \
	Yaml/MappingNode.vala \
	Yaml/Node.vala \
	Yaml/ScalarNode.vala \
	YamlObject.vala \
	$(NULL)

if USE_LOCAL_YAML
YAML_SOURCES = \
	../libyaml/yaml_private.h \
	../libyaml/api.c \
	../libyaml/reader.c \
	../libyaml/scanner.c \
	../libyaml/parser.c \
	../libyaml/loader.c \
	../libyaml/writer.c \
	../libyaml/emitter.c \
	../libyaml/dumper.c \
	$(NULL)
endif

libcatapult_la_SOURCES = \
  $(YAML_SOURCES) \
  libcatapult_la_vala.stamp \
  $(libcatapult_la_VALASOURCES:.vala=.c) \
  $(NULL)

libcatapult_la_vala.stamp: $(libcatapult_la_VALASOURCES)
	$(VALA_V)$(VALAC) $(VALAFLAGS) -C --vapidir $(srcdir)/../vapi --pkg gobject-2.0 --pkg gio-2.0 --pkg gee-0.8 --pkg gobject-patch --pkg config --pkg libyaml -H catapult.h --library catapult $^
	@touch $@

libcatapult_la_LIBADD = \
  $(YAML_LIBS) \
  $(GLIB_LIBS) \
  $(GIO_LIBS) \
  $(GEE_LIBS) \
  $(NULL)

#libgee_la_LDFLAGS = \
#  -version-info $(LIBGEE_LT_VERSION) \
#  -no-undefined \
#  $(NULL)

catapultincludedir = $(includedir)/catapult

catapultinclude_HEADERS = \
  catapult.h \
  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
  catapult.vapi \
  $(NULL)

EXTRA_DIST = $(libcatapult_la_VALASOURCES) catapult.vapi libcatapult_la_vala.stamp

MAINTAINERCLEANFILES = \
  catapult.vapi \
  catapult.h \
  $(libcatapult_la_VALASOURCES:.vala=.c) \
  $(NULL)

