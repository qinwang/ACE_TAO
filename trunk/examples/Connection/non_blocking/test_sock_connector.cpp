// $Id$

#include "ace/SOCK_Connector.h"
#include "ace/INET_Addr.h"
#include "CPP-connector.h"

typedef Peer_Handler<ACE_SOCK_STREAM> PEER_HANDLER;
typedef IPC_Client<PEER_HANDLER, ACE_SOCK_CONNECTOR> IPC_CLIENT;

// ACE_SOCK Client.
                                                        
int 
main (int argc, char *argv[])                       
{                                                       
  // Perform Service_Config initializations
  ACE_Service_Config daemon (argv[0]);

  IPC_CLIENT peer_connector;

  if (peer_connector.init (argc, argv) == -1)
    ACE_ERROR_RETURN ((LM_ERROR, "%p\n", "init"), -1);
  
  return peer_connector.svc ();
}                                                       

#if defined (ACE_TEMPLATES_REQUIRE_SPECIALIZATION)
template class ACE_Connector<PEER_HANDLER, ACE_SOCK_CONNECTOR>;
template class ACE_Svc_Handler<ACE_SOCK_STREAM, ACE_SYNCH>;
template class ACE_Svc_Tuple<PEER_HANDLER>;
template class IPC_Client<PEER_HANDLER, ACE_SOCK_CONNECTOR>;
template class Peer_Handler<ACE_SOCK_STREAM>;
template class ACE_Map_Entry<ACE_HANDLE, ACE_Svc_Tuple<PEER_HANDLER> *>;
template class ACE_Map_Iterator<ACE_HANDLE, ACE_Svc_Tuple<PEER_HANDLER> *, ACE_SYNCH_RW_MUTEX>;
template class ACE_Map_Manager<ACE_HANDLE, ACE_Svc_Tuple<PEER_HANDLER> *, ACE_SYNCH_RW_MUTEX>;

#if defined (ACE_HAS_THREADS)
  template class ACE_Guard<ACE_SYNCH_RW_MUTEX>;
  template class ACE_Read_Guard<ACE_SYNCH_RW_MUTEX>;
  template class ACE_Write_Guard<ACE_SYNCH_RW_MUTEX>;
#else
  // These are specialized in libACE if ACE doesn't have threads.
#endif /* ACE_HAS_THREADS */
#endif /* ACE_TEMPLATES_REQUIRE_SPECIALIZATION */
