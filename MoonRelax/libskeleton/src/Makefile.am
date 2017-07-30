## Process this file with automake to produce Makefile.in

AM_CFLAGS = -Wall -Wdeclaration-after-statement

INCLUDES = $(INCLTDL) -I$(top_srcdir)/include

EXTRA_DIST = Version_script.in

# Libraries to build
lib_LTLIBRARIES = libskeleton.la

noinst_HEADERS =			\
	skeleton_macros.h		\
	skeleton_private.h		\
	skeleton_vector.h
	
libskeleton_la_SOURCES =     		\
	skeleton.c			\
	skeleton_query.c		\
	skeleton_vector.c		
	
libskeleton_la_CFLAGS = $(AM_CFLAGS) $(OGG_CFLAGS) $(CFLAGS)
libskeleton_la_LDFLAGS = -version-info @SHARED_VERSION_INFO@ @SHLIB_VERSION_ARG@ 
libskeleton_la_LIBADD = @OGG_LIBS@
