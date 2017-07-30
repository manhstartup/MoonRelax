/**
   Copyright (c) 2010, Xiph.org Foundation

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   - Neither the name of the Xiph.org Foundation nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION
   OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
#include <stdio.h>
#include <unistd.h>

#include <ogg/ogg.h>
#include <skeleton/skeleton.h>

static void 
usage ()
{
  printf ("\n\n");
}

/* grab some data from the container */
int buffer_data(FILE *in, ogg_sync_state *oy){
  char *buffer  = ogg_sync_buffer (oy, 4096);
  int bytes     = fread (buffer, 1, 4096, in);
  ogg_sync_wrote (oy,bytes);
  return (bytes);
}

int
main (int argc, char **argv)
{
  int indexing, ch;
  FILE *in;
  ogg_sync_state    oy;
  ogg_page          og;
  ogg_stream_state  os;
  
  indexing = 0;
  
  while ((ch = getopt(argc, argv, "io:")) != -1) 
  {
    switch (ch) 
    {
      case 'i':
        indexing = 1;
        break;

      case 'o':
        break;

      case '?':
      default:
        usage();
    }
  }

  argc -= optind;
  argv += optind;
  
  if (argc == 0)
  {
    usage ();
    return 1;
  }
  
  in = fopen (argv[0], "rb");
  if (in == NULL)
  {
    perror ("error opening input");
    return -1;
  }

  /* initialise ogg_sync_state */
  ogg_sync_init (&oy);
  
  /* process all the headers of the Ogg container */
  while (1)
  {
    int ret = buffer_data (in, &oy);
    if (ret == 0) break;
    while (ogg_sync_pageout (&oy, &og) > 0)
    {
      ogg_packet        op;
      int               got_packet;

      ogg_stream_init (&os, ogg_page_serialno (&og));
      ogg_stream_pagein (&os, &og);
      if ((got_packet = ogg_stream_packetout (&os, &op)))
      {
      }
    }
  }

  fclose (in);
  
  return 0;
}
