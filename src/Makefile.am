NULL =

AUTOMAKE_OPTIONS = subdir-objects

lib_LTLIBRARIES = \
  libcatapult.la
  $(NULL)

if USE_LOCAL_YAML
LOCAL_YAML_SOURCES = \
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
	$(LOCAL_YAML_SOURCES) \
	DataInterface.vala \
	Entity.vala \
	EntityProvider.vala \
	Enumerable.vala \
	Error.vala \
	IYamlObject.vala \
	Helpers/IndirectGenerics/IndirectBi.vala \
	Helpers/IndirectGenerics/IndirectEnumerable.vala \
	Helpers/IndirectGenerics/IndirectFactory.vala \
	Helpers/IndirectGenerics/IndirectUni.vala \
	Helpers/IndirectGenerics.Gee/IndirectCollection.vala \
	Helpers/IndirectGenerics.Gee/IndirectIterable.vala \
	Helpers/IndirectGenerics.Gee/IndirectMap.vala \
	Helpers/IndirectGenericsHelper.vala \
	Helpers/BlockTimer.vala \
	Helpers/RegexHelper.vala \
	Helpers/ValueHelper.vala \
	Yaml/Constants.vala \
	Yaml/Document.vala \
	Yaml/Enums.vala \
	Yaml/Functions.vala \
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

libcatapult_la_VALAFLAGS = \
	-H catapult.h --vapi catapult.vapi --vapidir $(srcdir)/../vapi \
	--pkg gobject-2.0 --pkg gio-2.0 --pkg gee-0.8 --pkg gobject-patch --pkg config --pkg libyaml \
	--library catapult \
	$(GEE_VALAFLAGS) \
	$(VALAFLAGS) \
	$(NULL)

if USE_LOCAL_YAML
LOCAL_YAML_CFLAGS = \
	-I../libyaml \
	$(NULL)
endif

libcatapult_la_CPPFLAGS = \
  $(GLIB_CFLAGS) \
  $(GIO_CFLAGS) \
  $(GEE_CFLAGS) \
  $(LOCAL_YAML_CFLAGS) \
  $(NULL)

libcatapult_la_LIBADD = \
  $(YAML_LIBS) \
  $(GLIB_LIBS) \
  $(GIO_LIBS) \
  $(GEE_LIBS) \
  $(NULL)

catapultincludedir = $(includedir)/catapult

if USE_LOCAL_YAML
LOCAL_YAML_HEADERS_EXTRA = \
	../libyaml/yaml.h \
	$(NULL)
endif

catapultinclude_HEADERS = \
  catapult.h \
  $(LOCAL_YAML_HEADERS_EXTRA) \
  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
  catapult.vapi \
  $(NULL)

CLEANFILES = \
  catapult.vapi \
  $(NULL)

