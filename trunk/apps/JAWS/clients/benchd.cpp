// benchd: Adapted from the "ntalker" example.
// Sumedh Mungee

#include "ace/INET_Addr.h"
#include "ace/SOCK_Dgram_Mcast.h"
#include "ace/Reactor.h"
#include "ace/Get_Opt.h"
#include "ace/ARGV.h"

#if defined (ACE_HAS_IP_MULTICAST)
// network interface to subscribe to
//   this is hardware specific.
//   use netstat(1M) to find whether your interface
//   is le0 or ie0

// Maximum number of arguments supported for a request
static const int MAX_ARGS = 16;
// Name of the client benchmarking tool
static const char *TESTER = "http_tester";
static int QUIET = 0;
static const char *INTERFACE = "le0";
static const char *MCAST_ADDR = ACE_DEFAULT_MULTICAST_ADDR;
static const u_short UDP_PORT = ACE_DEFAULT_MULTICAST_PORT;

// Handle both multicast and stdin events.

class Handle_Events : public ACE_Event_Handler
{
public:
  Handle_Events (u_short udp_port, 
		 const char *ip_addr,
		 const char *interface,
		 ACE_Reactor &reactor);
  ~Handle_Events (void);

  virtual int handle_input (ACE_HANDLE);
  virtual int handle_close (ACE_HANDLE, ACE_Reactor_Mask);

private:
  int serve(char *buf);
  ACE_SOCK_Dgram_Mcast mcast_;
  ACE_Handle_Set handle_set_;
};

int
Handle_Events::handle_input (ACE_HANDLE h)
{
  char buf[BUFSIZ];

  if (h == 0)
    {
      int readresult = ACE_OS::read (h, buf, BUFSIZ);
      if (readresult > 0)
	{
	  if (this->mcast_.send (buf, readresult) != readresult)
	    {
	      ACE_OS::perror ("send error");
	      return -1;
	    }
	  return 0;
	}
      else if (readresult == -1)
	::perror ("can't read from STDIN");

      return -1;
    }
  else
    {
      ACE_INET_Addr remote_addr;

      // receive message from multicast group
      int retcode = this->mcast_.recv (buf, sizeof buf, remote_addr);
      
      if (retcode != -1)
	{
          /*
            cout << "received datagram from host " << remote_addr.get_host_name () 
            << " on port " << remote_addr.get_port_number () 
            << " bytes = " << retcode << endl;
            */
          switch(ACE_OS::fork()) {
          case -1:
            ACE_OS::perror ("fork");
            return -1;
          case 0:
            ACE_OS::exit(serve(buf));
          default:
            /*   ACE_OS::write (ACE_STDOUT, buf, retcode);
            cout << endl; */
            break;
          }
	  return 0;
	}

      ACE_OS::perror ("Something amiss.");
      return -1;
    }
}

int
Handle_Events::handle_close (ACE_HANDLE h, ACE_Reactor_Mask)
{
  if (h == 0)
    cout << "STDIN_Events handle removed from reactor." << endl << flush;
  else
    cout << "Mcast_Events handle removed from reactor." << endl << flush;
  return 0;
}

Handle_Events::~Handle_Events (void)
{
  // ACE_OS::exit on error (bogus)...

  if (this->mcast_.unsubscribe () == -1)
    ACE_OS::perror ("unsubscribe fails"), ACE_OS::exit (1);
}

Handle_Events::Handle_Events (u_short udp_port, 
			      const char *ip_addr,
			      const char *interface,
			      ACE_Reactor &reactor)
{
  // Create multicast address to listen on.

  ACE_INET_Addr sockmc_addr (udp_port, ip_addr);
  
  // subscribe to multicast group.

  if (this->mcast_.subscribe (sockmc_addr, 1, interface) == -1) 
    ACE_OS::perror ("can't subscribe to multicast group"), ACE_OS::exit (1);

  // Disable loopbacks.
  //  if (this->mcast_.set_option (IP_MULTICAST_LOOP, 0) == -1 )
  //    ACE_OS::perror (" can't disable loopbacks " ), ACE_OS::exit (1);

  if(!QUIET) {
    this->handle_set_.set_bit (0);
  }
  this->handle_set_.set_bit (this->mcast_.get_handle ());

  // Register callbacks with the ACE_Reactor.
  if (reactor.register_handler (this->handle_set_,
				this,
				ACE_Event_Handler::READ_MASK) == -1)
    ACE_OS::perror ("can't register events"), ACE_OS::exit (1);
}


// This method handles multicast requests..
// These requests are of the following form:
// command (arguments)


// currently only one is supported (and indeed needed :-))
// http_tester arguments

int
Handle_Events::serve(char *buf) {
  ACE_ARGV arguments(buf);
  if(ACE_OS::strcmp(arguments[0],TESTER) == 0) {
    return ACE_OS::execvp(TESTER, arguments.argv());
  }
}

static void
parse_args (int argc, char *argv[])
{
  ACE_Get_Opt get_opt (argc, argv, "i:u:q");

  int c;

  while ((c = get_opt ()) != -1)
    switch (c)
      {
      case 'q':
        QUIET = 1;
      case 'i':
	INTERFACE = get_opt.optarg;
	break;
      case 'u':
	// Usage fallthrough.
      default:
        ACE_DEBUG ((LM_DEBUG, "%s -i interface\n", argv[0]));
	ACE_OS::exit (1);
      }
}

static sig_atomic_t done = 0;

// Signal handler.

extern "C" void
handler (int)
{
  done = 1;
}

int 
main (int argc, char *argv[])
{
  ACE_Sig_Action sa ((ACE_SignalHandler) handler, SIGINT);
  ACE_UNUSED_ARG (sa);

  parse_args (argc, argv);

  ACE_Reactor reactor;
  Handle_Events handle_events (UDP_PORT, MCAST_ADDR, INTERFACE, reactor);

  // main loop
	  
  while (!done)
    reactor.handle_events ();

  cout << "\nbenchd done.\n";
  return 0;
}
#else
int 
main (int argc, char *argv[])
{
  ACE_ERROR ((LM_ERROR, "error: %s must be run on a platform that support IP multicast\n",
	    argv[0]));
  return 0;
}
#endif /* ACE_HAS_IP_MULTICAST */
