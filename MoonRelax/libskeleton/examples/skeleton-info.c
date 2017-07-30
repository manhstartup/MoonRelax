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
#include <stdlib.h>
#include <string.h>

#include <ogg/ogg.h>

#include <skeleton/skeleton.h>

/* grab some data from the container */
int buffer_data(FILE *in,ogg_sync_state *oy){
  char *buffer  = ogg_sync_buffer (oy, 4096);
  int bytes     = fread (buffer, 1, 4096, in);
  ogg_sync_wrote (oy,bytes);
  return (bytes);
}

void print_fishead (const OggSkeleton *skeleton)
{
  ogg_int64_t t;
  ogg_uint16_t maj, min;
  char *UTC = NULL;

  printf ("Skeleton fishead header content:\n");
  oggskel_get_ver_maj (skeleton, &maj);
  oggskel_get_ver_min (skeleton, &min);
  printf ("\tSkeleton version: %d.%d\n", maj, min);
  oggskel_get_ptime_num (skeleton, &t);
  printf ("\tPresentation time numerator: %lld\n", t);
  oggskel_get_ptime_denum (skeleton, &t);  
  printf ("\tPresentation time denumerator: %lld\n", t);
  oggskel_get_btime_num (skeleton, &t);  
  printf ("\tBase time numerator: %lld\n", t);
  oggskel_get_btime_denum (skeleton, &t);  
  printf ("\tBase time denumerator: %lld\n", t);
  oggskel_get_utc (skeleton, &UTC);
  printf ("\tUTC: %s\n", UTC);
  
  if (maj == 3 && min >= 2)
  {
    oggskel_get_segment_len (skeleton, &t);
    printf ("\tSegment length: %lld\n", t);
    oggskel_get_non_header_offset (skeleton, &t);
    printf ("\tNon-header offset: %lld\n", t);
  }
  _ogg_free (UTC);
}

void print_fisbone (const OggSkeleton *skeleton, ogg_uint32_t serial_no)
{
  ogg_int64_t t;
  ogg_uint32_t i;
  unsigned char c;
  char *msg_fields = NULL;
  int ret;
  
  ret = oggskel_get_num_headers (skeleton, serial_no, &i);
  if (ret == SKELETON_ERR_BAD_SERIAL_NO)
  {
    printf ("\nThere is no fisbone for %d !!!\n", serial_no);
    return;
  }
  
  printf ("\nSkeleton fisbone header for %d\n", serial_no);
  printf ("\tNumber of headers: %d\n", i);
  oggskel_get_granule_num (skeleton, serial_no, &t);
  printf ("\tGranule position numerator: %lld\n", t);
  oggskel_get_granule_denum (skeleton, serial_no, &t);
  printf ("\tGranule position denumerator: %lld\n", t);
  oggskel_get_start_granule (skeleton, serial_no, &t);
  printf ("\tStart granule position: %lld\n", t);
  oggskel_get_preroll (skeleton, serial_no, &i);
  printf ("\tPreroll: %d\n", i);
  oggskel_get_granule_shift (skeleton, serial_no, &c);
  printf ("\tGranule shift: %d\n", c);
  oggskel_get_msg_header (skeleton, serial_no, &msg_fields);
  printf ("\tMessage header fields:\n\t\t%s\n", msg_fields);
  _ogg_free (msg_fields);
}

int
main (int argc, char **argv)
{
  ogg_sync_state    oy;
  ogg_page          og;
  ogg_packet        op;
  ogg_stream_state  os, skel_stream;
  OggSkeleton     * skeleton;
  FILE            * fd;
  int               sk_headers = -1, sk_p = 0;
  int               flag = 1;
  int               serials[255];
  int               num_streams = 0;
  int               skel_serial = 0;
  
  if (argc < 2)
  {
    printf ("File name not given!\n");
    return -1;
  }
  
  fd = fopen (argv[1], "rb");
  if (fd == NULL)
  {
    perror ("opening file");
    return -1;
  }
  
  memset (serials, 0, 255);
  
  /* initialise ogg_sync_state */
  ogg_sync_init (&oy);
  
  /* create skeleton handle */
  skeleton = oggskel_new ();
  if (skeleton == NULL)
  {
    printf ("error while creating skeleton handle\n");
    return -1;
  }

  /* process all the bos pages....*/
  while (flag)
  {
    int ret = buffer_data (fd, &oy);
    if (ret == 0) break;
    while (ogg_sync_pageout (&oy, &og) > 0)
    {
      int got_packet;

      if (ogg_page_bos (&og))
      {
        /* record the serial number of the streams in the container */
        serials[num_streams++] = ogg_page_serialno (&og);
      }
      else
      {
        if (sk_p) ogg_stream_pagein (&skel_stream, &og);
        flag = 0;
      }
      ogg_stream_init (&os, ogg_page_serialno (&og));
      ogg_stream_pagein (&os, &og);
      got_packet = ogg_stream_packetpeek (&os, &op);
      
      if ((got_packet == 1) && !sk_p &&(sk_headers = oggskel_decode_header (skeleton, &op)) > 0)
      {
        /* found a skeleton stream, save it */
        memcpy (&skel_stream, &os, sizeof (os));
        sk_p = 1;
        skel_serial = ogg_page_serialno (&og);
        if (sk_headers) ogg_stream_packetout (&skel_stream, NULL);
      }
      else
      {
        /* packet was not a skeleton header */
        ogg_stream_clear (&os);
      }
      
      if (sk_headers < -1) {
        flag = 0;
        break;
      }
    }
  }
  
  /* process the rest of the skeleton headers */
  while (sk_headers && sk_p)
  {
    int ret = -1;
    
    while (sk_headers && (ret = ogg_stream_packetpeek (&skel_stream, &op)))
    {
      if (ret < 0) continue;
      sk_headers = oggskel_decode_header (skeleton, &op);
      if (sk_headers < 0)
      {
        printf ("Error parsing Skeleton stream headers\n");
        return -1;
      }
      else if (sk_headers)
      {
        ogg_stream_packetout (&skel_stream, NULL);
      }

      sk_p++;
    }
    
    if (!(sk_headers && sk_p)) break;
    
    if(ogg_sync_pageout(&oy,&og) > 0)
    {
      if (sk_p) ogg_stream_pagein (&skel_stream, &og);
    }
    else
    {
      int bytes = buffer_data (fd, &oy); /* someone needs more data */
      if (bytes == 0)
      {
        printf("End of file while searching for codec headers.\n");
        return -1;
      }
    }
  }

  
  if (sk_p)
  {
    int i = 0;
    print_fishead (skeleton);
    
    for (i = 0; i < num_streams; ++i)
    {
      if (serials[i] != skel_serial)
        print_fisbone (skeleton, serials[i]);
    }
  }
  else
  {
    switch (sk_headers) {
      case SKELETON_ERR_UNSUPPORTED_VERSION:
        printf ("Unsupported skeleton version\n");
        break;
      case SKELETON_ERR_MALICIOUS_FISHEAD:
        printf ("Malicious fishead header\n");
        break;
      case SKELETON_ERR_MALICIOUS_FISBONE:
        printf ("Malicious fisbone header\n");
        break;
      case SKELETON_ERR_MALICIOUS_INDEX:
        printf ("Malicious index header\n");
        break;
      case SKELETON_ERR_BAD_PACKET:
        printf ("Bad packet\n");
        break;
      case SKELETON_ERR_OUT_OF_MEMORY:
        printf ("Ran out of memory\n");
        break;
      case SKELETON_ERR_BAD_SKELETON:
        printf ("Bad OggSkeleton handle");
        break;
      default:
        printf ("Couldn't find any skeleton headers in the ogg file\n");
    }
  }

  oggskel_destroy (skeleton);
  
  fclose (fd);
  
  return 0;
}