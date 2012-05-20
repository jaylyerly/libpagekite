/******************************************************************************
pklogging.c - Logging.

This file is Copyright 2011, 2012, The Beanstalks Project ehf.

This program is free software: you can redistribute it and/or modify it under
the terms of the  GNU  Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful,  but  WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see: <http://www.gnu.org/licenses/>

******************************************************************************/
#include <assert.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "pkstate.h"
#include "pkproto.h"
#include "pklogging.h"


int pk_log(int level, const char* fmt, ...)
{
  va_list args;
  char output[4000];
  int r;

  if (level & pk_state.log_mask) {
    va_start(args, fmt);
    r = vsnprintf(output, 4000, fmt, args); 
    va_end(args);
    if (r > 0) fprintf(stderr, "%.4000s\n", output);
  }
  else {
    r = 0;
  }

  return r;
}

int pk_log_chunk(struct pk_chunk* chnk) {
  int r = 0;
  if (chnk->ping) {
    r += pk_log(PK_LOG_TUNNEL_HEADERS, "[_____] Ping!");
  }
  else if (chnk->sid) {
    if (chnk->request_host) {
      r += pk_log(PK_LOG_TUNNEL_CONNS,
                  "[%5.5s] %s:%d requested %s://%s:%d%s",
                  chnk->sid, chnk->remote_ip, chnk->remote_port,
                  chnk->request_proto, chnk->request_host, chnk->request_port,
                  chnk->remote_tls ? " (encrypted)" : "");
    }
    else {
      r += pk_log(PK_LOG_TUNNEL_DATA, "[%5.5s] << FIXME: DATA >>", chnk->sid);
    }
  }
  else {
    r += pk_log(PK_LOG_TUNNEL_HEADERS, "[_____] Non-ping chnk with no SID");
  }
  return r;
}