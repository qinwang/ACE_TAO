/* -*- C++ -*- */
// $Id$

// ============================================================================
//
// = LIBRARY
//    ace
// 
// = FILENAME
//   ACE_Strategies.h 
//
// = AUTHOR
//    Doug Schmidt 
// 
// ============================================================================

#if !defined (ACE_STRATEGIES_H)
#define ACE_STRATEGIES_H

#include "ace/Service_Config.h"

template <class SVC_HANDLER>
class ACE_Creation_Strategy
  // = TITLE
  //     Defines the interface for specifying a creation strategy for
  //     a SVC_HANDLER.  
  //
  // = DESCRIPTION
  //     The default behavior is to make a new SVC_HANDLER.  However,
  //     subclasses can override this strategy to perform SVC_HANDLER
  //     creation in any way that they like (such as creating subclass
  //     instances of SVC_HANDLER, using a singleton, dynamically
  //     linking the handler, etc.).
{
public:
  // = Initialization and termination methods.

  ACE_Creation_Strategy (ACE_Thread_Manager * = 0);
  // Default constructor.

  int open (ACE_Thread_Manager * = 0);
  // A <Thread_Manager> is useful when creating active objects.

  virtual ~ACE_Creation_Strategy (void);

  // = Factory method.
  virtual SVC_HANDLER *make_svc_handler (void);
  // Create a SVC_HANDLER with the appropriate creation strategy.  The
  // default behavior of this method is to make a new SVC_HANDLER,
  // passing in the Thread_Manager (if any).

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:
  ACE_Thread_Manager *thr_mgr_;
};

template <class SVC_HANDLER>
class ACE_Singleton_Strategy : public ACE_Creation_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying a creation strategy for
  //     a <SVC_HANDLER> that always returns the same <SVC_HANDLER> (i.e.,
  //     it's a Singleton).  
  //
  // = DESCRIPTION
  //     Note that this class takes over the ownership of the
  //     SVC_HANDLER passed into it as a parameter and it becomes
  //     responsible for deleting this object.
{
public:
  // = Initialization and termination methods.
  ACE_Singleton_Strategy (SVC_HANDLER * = 0,
			  ACE_Thread_Manager * = 0);
  int open (SVC_HANDLER *,
	    ACE_Thread_Manager * = 0);
  ~ACE_Singleton_Strategy (void);
  
  // = Factory method.
  virtual SVC_HANDLER *make_svc_handler (void);
  // Create a Singleton SVC_HANDLER by always returning the same
  // SVC_HANDLER. 

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:  
  SVC_HANDLER *svc_handler_;
  // Pointer to the Singleton svc_handler.
};

template <class SVC_HANDLER>
class ACE_DLL_Strategy : public ACE_Creation_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying a creation strategy for
  //     a SVC_HANDLER based on dynamic linking of the SVC_HANDLER.
{
public:
  // = Intialization and termination methods.

  ACE_DLL_Strategy (void);
  // "Do-nothing" constructor.

  ACE_DLL_Strategy (const char svc_dll_info[],
		    ACE_Service_Config *,
		    ACE_Thread_Manager * = 0);
  // Initialize the DLL strategy based upon the service's DLL
  // information contained in the <svc_dll_info> string.

  int open (const char svc_dll_info[],
	    ACE_Service_Config *,
	    ACE_Thread_Manager * = 0);
  // Initialize the DLL strategy based upon the service's DLL
  // information contained in the <svc_dll_info> string.

  // = Factory method.
  virtual SVC_HANDLER *make_svc_handler (void);
  // Create a SVC_HANDLER by dynamically linking it from a DLL.

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:
  typedef ACE_Creation_Strategy<SVC_HANDLER> inherited;

  char shared_library_[MAXPATHLEN];
  // Name of the shared library to dynamically link.

  char factory_function_[MAXPATHLEN];
  // Name of the factory function in the shared library to use to
  // obtain a pointer to the new SVC_HANDLER.

  char svc_name[MAXNAMELEN];
  // Name of the service.

  ACE_Service_Config *svc_config_;
  // Pointer to the Service_Configurator. 
};

template <class SVC_HANDLER>
class ACE_Concurrency_Strategy
  // = TITLE
  //     Defines the interface for specifying a concurrency strategy
  //     for a SVC_HANDLER.
  //
  // = DESCRIPTION
  //     Default behavior is to activate the SVC_HANDLER by calling
  //     its open() method (which allows the SVC_HANDLER to define its
  //     own concurrency strategy).  However, subclasses can override
  //     this default strategy to do more sophisticated concurrency
  //     activations (such as creating the SVC_HANDLER as an active
  //     object via multi-threading or multi-processing).
{
public:
  // = Factory method.
  virtual int activate_svc_handler (SVC_HANDLER *svc_handler,
				    void *arg = 0);
  // Activate the <svc_handler> with an appropriate concurrency
  // strategy.  The default behavior of this method is to activate the
  // SVC_HANDLER by calling its open() method (which allows the
  // SVC_HANDLER to define its own concurrency strategy).

  virtual ~ACE_Concurrency_Strategy (void);

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.
};

template <class SVC_HANDLER>
class ACE_Thread_Strategy : public ACE_Concurrency_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying a concurrency strategy
  //     for a <SVC_HANDLER> based on multithreading.
  //
  // = DESCRIPTION
  //     This class provides a strategy that manages the creation of
  //     threads to handle requests from clients concurrently.  It
  //     behaves as a "thread factory", spawning threads "on-demand"
  //     to run the service specified by a user-supplied
  //     <SVC_HANDLER>.
{
public:
  // = Intialization and termination methods.
  ACE_Thread_Strategy (void);
  // "Do-nothing constructor"

  ACE_Thread_Strategy (ACE_Thread_Manager *tm,
		       long thr_flags,
		       int n_threads = 1);
  // Initialize the strategy.

  virtual int open (ACE_Thread_Manager *tm,
		    long thr_flags,
		    int n_threads = 1);
  // Initialize the strategy.
  
  ~ACE_Thread_Strategy (void);

  // = Factory method.
  virtual int activate_svc_handler (SVC_HANDLER *svc_handler,
				    void *arg = 0);
  // Activate the <svc_handler> with an appropriate concurrency
  // strategy.  This method activates the SVC_HANDLER by first calling
  // its open() method and then calling its activate() method to turn
  // it into an active object.

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:
  typedef ACE_Concurrency_Strategy<SVC_HANDLER> inherited;

  ACE_Thread_Manager *thr_mgr_;
  // Thread manager for this class (must be provided).

  long thr_flags_;
  // Flags to pass into the SVC_HANDLER::activate() method.

  int n_threads_;
  // Number of threads to spawn.
};

template <class SVC_HANDLER>
class ACE_Process_Strategy : public ACE_Concurrency_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying a concurrency strategy
  //     for a <SVC_HANDLER> based on multiprocessing.
  //
  // = DESCRIPTION
  //     This class provides a strategy that manages the creation of
  //     processes to handle requests from clients concurrently.  It
  //     behaves as a "process factory", forking threads "on-demand"
  //     to run the service specified by a user-supplied
  //     <SVC_HANDLER>.
{
public:
  // = Intialization and termination methods.
  ACE_Process_Strategy (void);
  // "Do-nothing constructor"

  ACE_Process_Strategy (int n_processes = 1);
  // Initialize the strategy.

  virtual int open (int n_processes = 1);
  // Initialize the strategy.
  
  ~ACE_Process_Strategy (void);

  // = Factory method.
  virtual int activate_svc_handler (SVC_HANDLER *svc_handler,
				    void *arg = 0);
  // Activate the <svc_handler> with an appropriate concurrency
  // strategy.  This method activates the SVC_HANDLER by first forking
  // and then calling the open() method of the SVC_HANDLER in the
  // child.

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:
  typedef ACE_Concurrency_Strategy<SVC_HANDLER> inherited;

  int n_processes_;
  // Number of processes to spawn.
};

template <class SVC_HANDLER, ACE_PEER_ACCEPTOR_1>
class ACE_Accept_Strategy 
  // = TITLE
  //     Defines the interface for specifying a passive connection
  //     acceptance strategy for a SVC_HANDLER.
  //
  // = DESCRIPTION
  //     This class provides a strategy that manages passive
  //     connection acceptance of a client.
{
public:
  // = Initialization and termination methods.
  ACE_Accept_Strategy (void);
  // Default constructor.

  ACE_Accept_Strategy (const ACE_PEER_ACCEPTOR_ADDR &local_addr,
		       int restart = 0);
  // Initialize the <peer_acceptor_> with <local_addr>.

  virtual int open (const ACE_PEER_ACCEPTOR_ADDR &local_addr, 
		    int restart = 0);
  // Initialize the <peer_acceptor_> with <local_addr>.

  virtual ACE_HANDLE get_handle (void) const;
  // Return the underlying ACE_HANDLE of the <peer_acceptor_>.

  virtual ACE_PEER_ACCEPTOR &acceptor (void) const;
  // Return a reference to the <peer_acceptor_>.

  ~ACE_Accept_Strategy (void);

  // = Factory method.
  virtual int accept_svc_handler (SVC_HANDLER *);
  // The default behavior delegates to the <accept> method of the
  // PEER_ACCEPTOR. 

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

protected:
  ACE_PEER_ACCEPTOR peer_acceptor_;     
  // Factory that establishes connections passively.
};

template <class SVC_HANDLER>
class ACE_Scheduling_Strategy
  // = TITLE
  //     Defines the interface for specifying how to suspend and
  //     resume a service .
  //
  // = DESCRIPTION
  //     This class provides a strategy that allows arbitrarily
  //     sophisticated service suspension and resumption.  The default
  //     behavior is to do nothing...
{
public:
  // = Initialization and termination methods.

  ACE_Scheduling_Strategy (SVC_HANDLER * = 0);
  // Constructor

  ~ACE_Scheduling_Strategy (void);
  // Destructor

  // = Scheduling methods

  virtual int suspend (void);
  // Suspend hook.

  virtual int resume (void);
  // Resume hook.

  virtual void dump (void) const;
  // Dump the state of the object.

protected:
  SVC_HANDLER *scheduler_;
  // Points to the scheduler strategy object...

  int delete_scheduler_;
  // Keeps track of whether we need to delete this or not...
};

template <class SVC_HANDLER>
class ACE_Schedule_All_Reactive_Strategy : public ACE_Scheduling_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying how to suspend and
  //     resume a single-threaded reactive service .
  //
  // = DESCRIPTION
  //     This class provides a strategy that suspends and resumes all
  //     the Event_Handlers in a Reactor in one fell swoop.
{
public:
  // = Initialization and termination methods.
  ACE_Schedule_All_Reactive_Strategy (SVC_HANDLER * = 0);
  // Constructor

  // = Scheduling methods

  virtual int suspend (void);
  // Suspend hook.

  virtual int resume (void);
  // Resume hook.

  virtual void dump (void) const;
  // Dump the state of the object.
};

template <class SVC_HANDLER>
class ACE_Schedule_All_Threaded_Strategy : public ACE_Scheduling_Strategy<SVC_HANDLER>
  // = TITLE
  //     Defines the interface for specifying how to suspend and
  //     resume a multithreaded service .
  //
  // = DESCRIPTION
  //     This class provides a strategy that suspends and resumes all
  //     the Event_Handlers controlled by a Thread_Manager in one fell swoop.
{
public:
  // = Initialization and termination methods.
  ACE_Schedule_All_Threaded_Strategy (SVC_HANDLER * = 0);
  // Constructor

  // = Scheduling methods

  virtual int suspend (void);
  // Suspend hook.

  virtual int resume (void);
  // Resume hook.

  virtual void dump (void) const;
  // Dump the state of the object.
};

#if defined (ACE_TEMPLATES_REQUIRE_SOURCE)
#include "ace/Strategies.cpp"
#endif /* ACE_TEMPLATES_REQUIRE_SOURCE */

#if defined (ACE_TEMPLATES_REQUIRE_PRAGMA)
#pragma implementation ("Strategies.cpp")
#endif /* ACE_TEMPLATES_REQUIRE_PRAGMA */

#endif /* ACE_STRATEGIES_H */
