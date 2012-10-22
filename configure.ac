AC_INIT([catapult],[m4_esyscmd(build-aux/git-version-gen .tarball-version)],[nuhrin@oceanic.to],[catapult])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([no-dist-gzip dist-bzip2 tar-ustar])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AM_MAINTAINER_MODE

# Add config arguments.
AC_ARG_ENABLE(devhelp, AS_HELP_STRING([--enable-devhelp], [Enable devhelp book generation and/or installation]), enable_devhelp=$enableval, enable_devhelp=no)
AM_CONDITIONAL(ENABLE_DEVHELP, test x$enable_devhelp = xyes)

AC_ARG_ENABLE(local_libyaml, AS_HELP_STRING([--enable-local-libyaml], [Enable use of local libyaml]), enable_local_libyaml=$enableval, enable_local_libyaml=maybe)


# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
LT_INIT

AM_PROG_VALAC([0.17.3])
AC_SUBST(VALAC)
AC_SUBST(VALAFLAGS)

AS_IF([test "x$enable_devhelp" != xno],
  [AC_PATH_PROG(VALADOC, valadoc, :)
   AC_SUBST(VALADOC)
   AS_IF([test "$VALADOC" = :],
        if test -f "doc/catapult/index.htm"; then
       AC_MSG_WARN([valadoc not found: You will not be able to rebuild devhelp documentation.])
     else
       AC_MSG_ERROR([valadoc not found])
     fi)])


# Checks for packages.
GLIB_REQUIRED=2.18.0
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


# Check for system libyaml,  if appropriate
AS_IF([test "x$enable_local_libyaml" == xmaybe], 
		[AC_SEARCH_LIBS([yaml_emitter_emit], [yaml], [enable_local_libyaml=no], [enable_local_libyaml=yes])],
      [test "x$enable_local_libyaml" == xno], 
		[AC_SEARCH_LIBS([yaml_emitter_emit], [yaml],, [AC_MSG_ERROR([libyaml not found])])])

# Setup libyaml
AS_IF([test "x$enable_local_libyaml" = xyes],
	[AC_DEFINE(YAML_VERSION_MAJOR, 0, [Define the major version number.])
	  AC_DEFINE(YAML_VERSION_MINOR, 1, [Define the minor version number.])
	  AC_DEFINE(YAML_VERSION_PATCH, 2, [Define the patch version number.])
	  AC_DEFINE(YAML_VERSION_STRING, "0.1.2", [Define the version string.])
	  AC_HEADER_STDC
	  AC_CHECK_HEADERS([stdlib.h])
	  AC_C_CONST
	  AC_TYPE_SIZE_T],
	[YAML_LIBS=$LIBS
	  AC_SUBST(YAML_LIBS)])
AM_CONDITIONAL(USE_LOCAL_YAML, test x$enable_local_libyaml = xyes)



AC_CONFIG_FILES([
	catapult.pc
	Makefile
	libyaml/Makefile
	src/Makefile
	doc/Makefile
	vapi/Makefile
])

AC_OUTPUT
