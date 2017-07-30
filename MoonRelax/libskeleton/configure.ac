# Process this file with autoconf to produce a configure script.
AC_INIT([libskeleton], [0.1.0], [https://bugs.launchpad.net/skeleton])
AC_CONFIG_SRCDIR([src/skeleton.c])

AC_PREREQ(2.53)

AC_CANONICAL_TARGET

AM_INIT_AUTOMAKE(libskeleton, 0.1.0)
AM_CONFIG_HEADER(config.h)

SHARED_VERSION_INFO="1:0:1"
SHLIB_VERSION_ARG=""

# Checks for programs
AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_INSTALL
AC_PROG_MAKE_SET

AC_C_CONST
AC_C_BIGENDIAN

AM_PROG_CC_C_O

dnl Add parameters for aclocal
AC_SUBST(ACLOCAL_AMFLAGS, "-I m4")

dnl Checks for library functions
AC_CHECK_FUNCS([assert])

dnl Check for pkg-config
AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)

dnl Check for doxygen
AC_CHECK_PROG(HAVE_DOXYGEN, doxygen, true, false)
AM_CONDITIONAL(HAVE_DOXYGEN,$HAVE_DOXYGEN)
if test $HAVE_DOXYGEN = "false"; then
             AC_MSG_WARN([*** doxygen not found, docs will not be built])
fi

# Check for valgrind
VALGRIND_ENVIRONMENT=""
ac_enable_valgrind=no
AC_ARG_ENABLE(valgrind-testing,
     [  --enable-valgrind-testing     enable running of tests inside Valgrind ],     [ ac_enable_valgrind=yes ], [ ac_enable_valgrind=no] )

if test "x${ac_enable_valgrind}" = xyes ; then
  if test "x${enable_shared}" = xyes ; then
    VALGRIND_ENVIRONMENT="libtool --mode=execute "
  fi

  AC_CHECK_PROG(HAVE_VALGRIND, valgrind, yes, no)
  if test "x$HAVE_VALGRIND" = xyes ; then
    VALGRIND_ENVIRONMENT="$VALGRIND_ENVIRONMENT valgrind -q --leak-check=yes --show-reachable=yes --num-callers=100"
    AC_SUBST(VALGRIND_ENVIRONMENT)
    TESTS_INFO="Type 'make check' to run test suite. Tests will be run under:
  ${VALGRIND_ENVIRONMENT}"
  else
    TESTS_INFO="Type 'make check' to run test suite (Valgrind not found)"
  fi
else  TESTS_INFO="Type 'make check' to run test suite (Valgrind testing not enabled)"
fi

skeleton_config_ok=yes
skeleton_examples="skeleton-info"

dnl
dnl  Configuration option to add -Werror to all Makefiles
dnl

AC_ARG_ENABLE(gcc-werror,
     AC_HELP_STRING([--enable-gcc-werror], [enable -Werror in all Makefiles]),
     [ ac_enable_gcc_werror=yes ], [ ac_enable_gcc_werror=no] )

if test "x${ac_enable_gcc_werror}" = xyes ; then
  CFLAGS="-Werror $CFLAGS"
fi


dnl
dnl  Detect ogg
dnl
HAVE_OGG="no"
if test "x$HAVE_PKG_CONFIG" = "xyes"
then
  PKG_CHECK_MODULES(OGG, ogg >= 1.0, HAVE_OGG="yes", HAVE_OGG="no")
fi
if test "x$HAVE_OGG" = "xyes" ; then
  AC_DEFINE(HAVE_OGG, [], [Define if have libogg])
  AC_SUBST(OGG_CFLAGS)
  AC_SUBST(OGG_LIBS)
else
  XIPH_PATH_OGG(, AC_MSG_ERROR([
*** libogg does not seem to exist on your system.
*** Please install it and run this ./configure again.
  ]))
  cflags_save=$CFLAGS
  libs_save=$LIBS
  CFLAGS="$CFLAGS $OGG_CFLAGS"
  LIBS="$LIBS $OGG_LIBS"
  AC_CHECK_FUNC(oggpackB_read, , [
    AC_MSG_ERROR([newer libogg version (1.1 or later) required])
  ])
  CFLAGS=$cflags_save
  LIBS=$libs_save    
fi

dnl
dnl Configure for target platform
dnl

case "$target_os" in
  darwin* | rhapsody*)
    dnl Disable -Wall and -pedantic for Apple Darwin/Rhapsody.
    dnl System headers on these systems are broken.
    temp_CFLAGS=`echo $CFLAGS | sed "s/-Wall -pedantic//"`
    CFLAGS=$temp_CFLAGS
    dnl add extra mac-specific directories to include path
    CFLAGS="$CFLAGS -I/Developer/Headers/FlatCarbon/"
    HAVE_FRAMEWORKS="yes"
    AC_SUBST(PLATFORM,"mac")
    ;;
  linux* | solaris* | gnu* | k*bsd*-gnu)
    SHLIB_VERSION_ARG="-Wl,--version-script=Version_script"
    AC_SUBST(PLATFORM,"linux")
    ;;
  *)
    ;;
esac

dnl Use -Wall if we have gcc.
dnl changequote(,)dnl
if test "x$ac_cv_prog_gcc" = xyes ; then
  CFLAGS="$CFLAGS -Wall -g"
fi
dnl changequote([,])dnl

dnl
dnl  Configuration tests complete -- provide summary of results.
dnl

if test $skeleton_config_ok = no ; then

AC_MSG_RESULT([
**************************************************************

*** $PACKAGE $VERSION: Automatic configuration FAILED.

*** The file config.log has full details.

*** The following required libraries are missing or
*** misconfigured on your system:
])

if test "x$HAVE_OGG" != xyes ; then
    AC_MSG_RESULT(
[*** libogg, available from http://www.xiph.org/ogg/])
fi

AC_MSG_RESULT(
[*** If you install the required libraries from source, you
*** need to inform the dynamic linker of their location. If
*** you install them in a system-wide directory such as
*** /usr/local (the default), you must ensure that
*** /usr/local/lib is listed in /etc/ld.so.conf, then run
*** ldconfig to update the dynamic linking system.
*** Alternatively, you can set your LD_LIBRARY_PATH environment
*** variable to include the library installation directory.
])


AC_MSG_RESULT(
[**************************************************************
])


AC_MSG_ERROR([
***
*** After fixing the above problems, you must run ./configure again.
***
])

else

AC_SUBST(SHLIB_VERSION_ARG)
AC_SUBST(SHARED_VERSION_INFO)

AC_OUTPUT([
Makefile
doc/Makefile
doc/Doxyfile
include/Makefile
include/skeleton/Makefile
src/Makefile
src/Version_script
examples/Makefile
skeleton.pc
skeleton-uninstalled.pc
])

AS_AC_EXPAND(LIBDIR, ${libdir})
AS_AC_EXPAND(INCLUDEDIR, ${includedir})
AS_AC_EXPAND(BINDIR, ${bindir})
AS_AC_EXPAND(DOCDIR, ${datadir}/doc)

AC_MSG_RESULT([
------------------------------------------------------------------------
  $PACKAGE $VERSION:  Automatic configuration OK.

  Examples (./examples):

    $skeleton_examples

  Installation paths:

    libskeleton: ................. ${LIBDIR}
    C header files: .............. ${INCLUDEDIR}/skeleton
    Documentation: ............... ${DOCDIR}/$PACKAGE

  Building:

    Type 'make' to compile $PACKAGE.

    Type 'make install' to install $PACKAGE.

    ${TESTS_INFO}

------------------------------------------------------------------------
])

fi
