// $Id$

#ifndef GLOBALS_H
#define GLOBALS_H

// ============================================================================
//
// = LIBRARY
//    TAO/tests
//
// = FILENAME
//    Globals.h
//
// = DESCRIPTION
//    All the globally defined classes, functions, types, and #defines
//    are centralized here.
//
// = AUTHOR
//    Nagarajan Surendran <naga@cs.wustl.edu>
//
// ============================================================================

#include "ace/OS.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

#include "ace/Get_Opt.h"
#include "ace/Synch_T.h"
#include "ace/Sched_Params.h"
#include "ace/Singleton.h"

#if defined (VXWORKS) && defined (VME_DRIVER)
#define VX_VME_INIT \
STATUS status = vmeDrv ();\
if (status != OK)\
     ACE_DEBUG ((LM_DEBUG,\
                "ERROR on call to vmeDrv()\n"));\
  status = vmeDevCreate ("/vme");\
  if (status != OK)\
    ACE_DEBUG ((LM_DEBUG,\
                "ERROR on call to vmeDevCreate()\n"));
#else
#define VX_VME_INIT
#endif /* VXWORKS && VME_DRIVER */

#if defined (__Lynx__)
#define SCHED_PRIORITY 30
#elif defined (VXWORKS)
#define SCHED_PRIORITY 6
#elif defined (ACE_WIN32)
#define SCHED_PRIORITY \
ACE_Sched_Params::priority_max(ACE_SCHED_FIFO,ACE_SCOPE_THREAD)
#else
#define SCHED_PRIORITY \
ACE_THR_PRI_FIFO_DEF + 25
#endif /* ! __Lynx__ */

// Enable FIFO scheduling, e.g., RT scheduling class on Solaris.
#define SCHED_PARAMS_FIFO \
ACE_OS::sched_params (ACE_Sched_Params (ACE_SCHED_FIFO,\
                                        SCHED_PRIORITY,\
                                        ACE_SCOPE_PROCESS))

#if defined (CHORUS)
#define PCCTIMER_INIT {int pTime;/*Initialize the PCC timer chip */pccTimerInit ();\
if (pccTimer (PCC2_TIMER1_START, &pTime) != K_OK)\
ACE_DEBUG ((LM_DEBUG,"pccTimer has a pending benchmark\n"));\
}
#else /* !CHORUS */
#define PCCTIMER_INIT
#endif /* !CHORUS */

#if defined (VXWORKS) && defined (FORCE_ARGS)
static char *force_argv[]=
{
  "server",
  "-f",
  "ior.txt"
};
#endif /* defined (VXWORKS) && defined (FORCE_ARGS) */

#if defined (VXWORKS) && defined (FORCE_ARGS)
#define FORCE_ARGV(argc,argv) \
argc = 4;
argv = force_argv;
#else /* !VXWORKS && !FORCE_ARGS */
#define FORCE_ARGV(argc,argv)
#endif
// Number of utilisation computations to compute the duration of one
// util computation.
#define NUM_UTIL_COMPUTATIONS 10000

#define THREAD_PER_RATE_OBJS 4
// Number of cubit objects in the thread per rate test.

#define TASK_ID_LEN 32
// length of the task id ,used in vxworks.

#define PRIORITY_INCR 25
// added to ACE_THR_PRI_FIFO_DEF for non vxworks and non win32 platforms.

#define TASKNAME_LEN 14
// Length of the task name in the task control block for vxworks.

#define UTIL_BOUND_CONSTANT 1000
// A constant to avoid the utility thread blocking the machine and to
// bound its  number of computations.

class Globals
{
  // = TITLE
  //     Globals class to be used as a singleton.
  //
  // = DESCRIPTION
  //     This is used both by the server and client.
public:
  Globals (void);
  // default constructor.

  int parse_args (int argc, char **argv);
  // parse the arguments.

  static int sched_fifo_init (void);
  // enables fifo scheduling eg.RT scheduling class on solaris.
  char hostname[BUFSIZ];
  // hostname to be used for ORB_init.

  char *ior_file;
  // file name to read/write the iors of the servants.

  int base_port;
  // The base port upon which the servants will listen.  The high
  // priority servant will listen at the <base_port> and the
  // low_priority servants will listen at <base_port> + i where i is
  // the number of that low priority servant.

  u_int num_of_objs;
  // number of objects per servant thread.

  u_int thread_per_rate;
  //  thread_per_rate test flag.

  u_int use_multiple_priority;
  // flag to use multiple priorities for the low priority servants
  // instead of one priority.

  int ready_;
  // ready flag used by the high priority thread to wake up the low
  // priority threads after it's parsed the arguments.

  ACE_SYNCH_MUTEX ready_mtx_;
  // mutex for the condition variable.

  ACE_Condition<ACE_SYNCH_MUTEX> ready_cnd_;
  // condition variable for the low priority threads to wait
  //until the high priority thread is done with the arguments parsing.

  ACE_Barrier *barrier_;
  // Barrier for the multiple servants to synchronize after binding to
  // the orb.
};

// Make the globals a Singleton.
typedef ACE_Singleton<Globals,ACE_Null_Mutex> GLOBALS;

class MT_Priority
{
  // = TITLE
  //     Helper class to find high and low priorities for the
  //     MT_Cubit application over multiple platforms.
  //
  // = DESCRIPTION
  //     This class has 2 methods, one for the high priority and the
  //     other for low priority.If the flag use_multiple_priority is
  //     passed then multiple priorities are used for the low priority
  //     threads.

public:
  MT_Priority (void);
  // constructor.

  virtual ACE_Sched_Priority get_high_priority (void);
  // Sets the priority of the high priority thread.

  virtual ACE_Sched_Priority get_low_priority
    (u_int num_low_priority,
     ACE_Sched_Priority prev_priority,
     u_int use_multiple_priority);
  // Sets the priority to be used for the low priority thread.

  u_int number_of_priorities (void);
  // Accessor for num_priorities_.

  u_int grain (void);
  // Accessor for grain_.

protected:
  u_int num_priorities_;
  // Number of priorities used.

  u_int grain_;
  // Granularity of the assignment of the priorities.  Some OSs have
  // fewer levels of priorities than we have threads in our test, so
  // with this mechanism we assign priorities to groups of threads
  // when there are more threads than priorities.
};

#endif /* GLOBALS_H */
