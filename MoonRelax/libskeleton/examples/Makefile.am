## Process this file with automake to produce Makefile.in

AM_CFLAGS = -Wall

INCLUDES = -I$(top_srcdir)/include @OGG_CFLAGS@

SKELETONDIR = ../src
SKELETON_LIBS = $(SKELETONDIR)/libskeleton.la @OGG_LIBS@

# Tools

noinst_PROGRAMS = skeleton-apply skeleton-info

skeleton_apply_SOURCE = skeleton-apply.c
skeleton_apply_LDADD = $(SKELETON_LIBS)
skeleton_info_SOURCES = skeleton-info.c
skeleton_info_LDADD = $(SKELETON_LIBS)
