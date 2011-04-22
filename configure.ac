AC_INIT([yamldb], m4_esyscmd([build-aux/git-version-gen .tarball-version]), [nuhrin@oceanic.to], [yamldb])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AM_PROG_VALAC([0.11.0])
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

GLIB_REQUIRED=2.16.0
PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)
PKG_CHECK_MODULES(GIO, gio-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GIO_CFLAGS)
AC_SUBST(GIO_LIBS)

GEE_REQUIRED=0.6.1
PKG_CHECK_MODULES(GEE, gee-1.0 >= $GEE_REQUIRED)
AC_SUBST(GEE_CFLAGS)
AC_SUBST(GEE_LIBS)

AC_ARG_ENABLE(doc, AS_HELP_STRING([--enable-doc], [Enable documentation generation]), enable_doc=$enableval, enable_doc=no)
AM_CONDITIONAL(ENABLE_DOC, test x$enable_doc = xyes)

AS_IF([test "x$enable_doc" != xno],
  [AC_PATH_PROG(VALADOC, valadoc, :)
   AC_SUBST(VALADOC)
   AS_IF([test "$VALADOC" = :],
    [AC_MSG_ERROR([valadoc not found])])])


AC_CONFIG_FILES([
	yamldb.pc
	Makefile
	src/Makefile
	doc/Makefile
	vapi/Makefile
])
AC_OUTPUT

#	src/Yaml/Makefile
#	src/Helpers/IndirectGenerics/Makefile
#	src/Helpers/IndirectGenerics.Gee/Makefile
#	src/Yaml/Events/Makefile
