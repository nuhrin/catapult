NULL =

AUTOMAKE_OPTIONS = subdir-objects

AM_CPPFLAGS = \
  $(GLIB_CFLAGS) \
  $(GEE_CFLAGS) \
  $(NULL)

BUILT_SOURCES = libyamldb_la_vala.stamp

lib_LTLIBRARIES = \
  libyamldb.la
  $(NULL)

libyamldb_la_VALASOURCES = \
  DataInterface.vala \
	Delegates.vala \
	Entity.vala \
	Enumerable.vala \
	Enumerator.vala \
	Error.vala \
	IYamlObject.vala \
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
	Yaml/libyaml.vapi \
	Yaml/NodeBuilder.vala \
	Yaml/NodeParser.vala \
	Yaml/OrderedMappingSet.vala \
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
	Yaml/NodeList.vala \
	Yaml/Node.vala \
	Yaml/ScalarNode.vala \
	YamlObject.vala \
	$(NULL)

libyamldb_la_SOURCES = \
  libyamldb_la_vala.stamp \
  $(libyamldb_la_VALASOURCES:.vala=.c) \
  $(NULL)


libyamldb_la_vala.stamp: $(libyamldb_la_VALASOURCES)
	$(VALA_V)$(VALAC) $(VALAFLAGS) -C --vapidir $(srcdir)/../vapi --pkg gobject-2.0 --pkg gee-1.0 --pkg gobject-patch --pkg config -H yamldb.h --library yamldb $^
	@touch $@
 
libyamldb_la_LIBADD = \
  $(GLIB_LIBS) \
  $(GEE_LIBS) \
  $(NULL)

#libgee_la_LDFLAGS = \
#  -version-info $(LIBGEE_LT_VERSION) \
#  -no-undefined \
#  $(NULL)

yamldbincludedir = $(includedir)/yamldb

yamldbinclude_HEADERS = \
  yamldb.h \
  $(NULL)

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
  yamldb.vapi \
  $(NULL)

EXTRA_DIST = $(libyamldb_la_VALASOURCES) yamldb.vapi libyamldb_la_vala.stamp

MAINTAINERCLEANFILES = \
  yamldb.vapi \
  yamldb.h \
  $(libyamldb_la_VALASOURCES:.vala=.c) \
  $(NULL)

