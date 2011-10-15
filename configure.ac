AC_INIT([catapult],[m4_esyscmd(build-aux/git-version-gen .tarball-version)],[nuhrin@oceanic.to],[catapult])
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
LT_INIT

AM_PROG_VALAC([0.11.0])
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

AC_SEARCH_LIBS([yaml_emitter_emit], [yaml], [use_local_yaml=no], [use_local_yaml=yes])
if test "$use_local_yaml" = "yes"; then
	AC_DEFINE(YAML_VERSION_MAJOR, 0, [Define the major version number.])
	AC_DEFINE(YAML_VERSION_MINOR, 1, [Define the minor version number.])
	AC_DEFINE(YAML_VERSION_PATCH, 2, [Define the patch version number.])
	AC_DEFINE(YAML_VERSION_STRING, "0.1.2", [Define the version string.])
	AC_HEADER_STDC
	AC_CHECK_HEADERS([stdlib.h])
	AC_C_CONST
	AC_TYPE_SIZE_T
else
	YAML_LIBS=$LIBS
	AC_SUBST(YAML_LIBS)
fi
AM_CONDITIONAL(USE_LOCAL_YAML, test x$use_local_yaml = xyes)

GLIB_REQUIRED=2.16.0
PKG_CHECK_MODULES(GLIB, glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GLIB_CFLAGS)
AC_SUBST(GLIB_LIBS)
PKG_CHECK_MODULES(GIO, gio-2.0 >= $GLIB_REQUIRED)
AC_SUBST(GIO_CFLAGS)
AC_SUBST(GIO_LIBS)

GEE_REQUIRED=0.7.2
PKG_CHECK_MODULES(GEE, gee-0.8 >= $GEE_REQUIRED)
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
	catapult.pc
	Makefile
	libyaml/Makefile
	src/Makefile
	doc/Makefile
	vapi/Makefile
])
AC_OUTPUT
