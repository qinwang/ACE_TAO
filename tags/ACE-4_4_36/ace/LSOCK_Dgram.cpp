// LSOCK_Dgram.cpp
// $Id$

#define ACE_BUILD_DLL
#include "ace/LSOCK_Dgram.h"

#if !defined (ACE_LACKS_UNIX_DOMAIN_SOCKETS)

ACE_ALLOC_HOOK_DEFINE(ACE_LSOCK_Dgram)

void
ACE_LSOCK_Dgram::dump (void) const
{
  ACE_TRACE ("ACE_LSOCK_Dgram::dump");

  ACE_DEBUG ((LM_DEBUG, ACE_BEGIN_DUMP, this));
  ACE_SOCK_Dgram::dump ();
  ACE_LSOCK::dump ();
  ACE_DEBUG ((LM_DEBUG, ACE_END_DUMP));
}

/* The "do nothing" constructor. */

ACE_LSOCK_Dgram::ACE_LSOCK_Dgram (void)
{
  ACE_TRACE ("ACE_LSOCK_Dgram::ACE_LSOCK_Dgram");
}

/* Here's the general-purpose open routine. */

int
ACE_LSOCK_Dgram::open (const ACE_Addr &local, 
		       int protocol_family, 
		       int protocol)
{
  ACE_TRACE ("ACE_LSOCK_Dgram::open");
  if (ACE_SOCK_Dgram::open (local, protocol_family, 
			    protocol) == -1)
    return -1;
  ACE_LSOCK::set_handle (this->ACE_SOCK_Dgram::get_handle ());
  return 0;
}

/* Create a local ACE_SOCK datagram. */

ACE_LSOCK_Dgram::ACE_LSOCK_Dgram (const ACE_Addr &local, 
				  int protocol_family, 
				  int protocol)
{
  ACE_TRACE ("ACE_LSOCK_Dgram::ACE_LSOCK_Dgram");
  if (this->open (local, protocol_family, 
		  protocol) == -1)
    ACE_ERROR ((LM_ERROR,  ASYS_TEXT ("%p\n"),  ASYS_TEXT ("ACE_LSOCK_Dgram")));
}

#endif /* ACE_LACKS_UNIX_DOMAIN_SOCKETS */
