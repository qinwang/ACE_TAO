/* -*- C++ -*- */
// $Id$

// The following configuration file is designed to work for HP
// platforms running HP/UX 10.x.  It includes all of the ACE information
// needed for HP-UX 10.x itself.  The compiler-specific information is in
// config-hpux-10.x-<compiler>.h - they include this file.

#if !defined (ACE_CONFIG_H)
#error "You need to use a compiler-specific .h file - they include this file"
#endif

// These should be removed.

// Fixes a problem with HP/UX not wrapping the mmap(2) header files
// with extern "C".
// #define ACE_HAS_BROKEN_MMAP_H

// Header files lack t_errno for ACE_TLI.
// #define ACE_LACKS_T_ERRNO



// Compiling for HPUX.
#if !defined (HPUX)
#define HPUX
#endif /* HPUX */
#define HPUX_10

#define _HPUX_SOURCE

#include /**/ <sys/stdsyms.h>
#include /**/ <sched.h>		/*  pthread.h doesn't include this */

extern int h_errno;	/* This isn't declared in a header file on HP-UX */

// There are a number of sections to this file, one of which is the
// threads-related information.  If _ACE_HPUX_USE_DCETHREADS is defined,
// the DCE threading definitions will be set up for the build.  If it
// is not defined, ACE will be built without thread support.
#define _ACE_HPUX_USE_DCETHREADS


////////////////////////////////////////////////////////////////////////////
//
// General OS information - see README for more details on what they mean
//
///////////////////////////////////////////////////////////////////////////



// Compiler/platform contains the <sys/syscall.h> file.
#define ACE_HAS_SYSCALL_H
// But doesn't have a prototype for syscall()
#define ACE_LACKS_SYSCALL

// Platform supports POSIX 1.b clock_gettime ()
#define ACE_HAS_CLOCK_GETTIME

// Prototypes for both signal() and struct sigaction are consistent.
#define ACE_HAS_CONSISTENT_SIGNAL_PROTOTYPES

// Compiler/platform has correctly prototyped header files.
#define ACE_HAS_CPLUSPLUS_HEADERS

// Platform supports getpagesize() call
#define ACE_HAS_GETPAGESIZE
// But we define this just to be safe
#define ACE_PAGE_SIZE 4096

// Platform supports IP multicast
#define ACE_HAS_IP_MULTICAST

// Platform supports recvmsg and sendmsg.
#define ACE_HAS_MSG

// Compiler/platform supports poll().
#define ACE_HAS_POLL

// Platform supports POSIX O_NONBLOCK semantics.
#define ACE_HAS_POSIX_NONBLOCK

// Platform supports the POSIX struct timespec type
#define ACE_HAS_POSIX_TIME

// Platform supports reentrant functions (i.e., all the POSIX *_r functions).
#define ACE_HAS_REENTRANT_FUNCTIONS
// But this one is not like other platforms
#define ACE_CTIME_R_RETURNS_INT

// Compiler/platform defines the sig_atomic_t typedef
#define ACE_HAS_SIG_ATOMIC_T

// Platform supports SVR4 extended signals
#define ACE_HAS_SIGINFO_T
// Platform supports ucontext_t (which is used in the extended signal API).
#define ACE_HAS_UCONTEXT_T

// Compiler/platform supports strerror ().
#define ACE_HAS_STRERROR

// SunOS 4 style prototype for gettimeofday
#define ACE_HAS_SUNOS4_GETTIMEOFDAY

// HP/UX has an undefined syscall for GETRUSAGE...
#define ACE_HAS_SYSCALL_GETRUSAGE
// Note, this only works if the flag is set above!
#define ACE_HAS_GETRUSAGE

// Platform supports System V IPC (most versions of UNIX, but not Win32)
#define ACE_HAS_SYSV_IPC

// Platform supports the tid_t type
#define ACE_HAS_TID_T

// Platform lacks readers/writer locks.
#define ACE_LACKS_RWLOCK_T

//////////////////////////////////////////////////////////////////////////
//
// STREAMS information
//
//////////////////////////////////////////////////////////////////////////

// Platform supports STREAMS
#define ACE_HAS_STREAMS
// Compiler/platform supports struct strbuf.
#define ACE_HAS_STRBUF_T

// Platform supports STREAM pipes
// This is possible, but not by default - need to rebuild the kernel to
// get them enabled - see pipe(2) and "STREAMS/UX for the HP 9000"
// #define ACE_HAS_STREAM_PIPES

/////////////////////////////////////////////////////////////////////////
//
// TLI information
//
////////////////////////////////////////////////////////////////////////

// Platform supports ACE_TLI.
#define ACE_HAS_TLI
// Platform supports ACE_TLI tiuser header.
#define ACE_HAS_TIUSER_H
// Platform provides ACE_TLI function prototypes.
#define ACE_HAS_TLI_PROTOTYPES

/////////////////////////////////////////////////////////////////////////
//
// Threads information.
// Threads definitions are controlled by _ACE_HPUX_USE_DCETHREADS, above.
//
// NOTE!  The platform_macros.GNU file may also need some settings
// to work with threads.
//
////////////////////////////////////////////////////////////////////////

#ifdef _ACE_HPUX_USE_DCETHREADS
#  define ACE_MT_SAFE
#  define ACE_HAS_THREADS
#  define ACE_HAS_DCETHREADS
#  define ACE_HAS_DCE_DRAFT4_THREADS
#  define ACE_HAS_POSIX_SEM
#  define ACE_HAS_PTHREAD_T

// Platform has pthread_attr_delete instead of pthread_attr_destroy
// ACE needs to define PRIORITY_MAX
#  define ACE_HAS_SETKIND_NP

#  define ACE_HAS_THREAD_SPECIFIC_STORAGE

// They forgot a const in the prototype of pthread_cond_timedwait
#  define ACE_LACKS_CONST_TIMESPEC_PTR

// Platform lacks pthread_thr_sigsetmask
#  define ACE_LACKS_PTHREAD_THR_SIGSETMASK

// Platform has no implementation of pthread_condattr_setpshared()
#  define ACE_LACKS_CONDATTR_PSHARED

// Platform lacks pthread_attr_setdetachstate()
#  define ACE_LACKS_SETDETACH

// Platform lacks TSS keydelete
#  define ACE_LACKS_KEYDELETE

// Platform lacks pthread_attr_setscope
#  define ACE_LACKS_THREAD_PROCESS_SCOPING

// Platform lacks pthread_attr_setstackaddr
#  define ACE_LACKS_THREAD_STACK_ADDR

// Platform uses int for select() rather than fd_set.
// HP's DCE threads redefine a bunch of system I/O calls to wrappered
// versions to avoid blocking the whole process when a call blocks.
// One of them is select(), and it only has the int* (not fd_set*)
// variety.  So, until HP does kernel threads, switch to int select
// when building with threads.
//#  define ACE_SELECT_USES_INT
#  define _CMA_NOWRAPPERS_

// This is a def for this file only
#  undef _ACE_HPUX_USE_DCETHREADS
#endif /* _ACE_HPUX_USE_DCETHREADS

// Turns off the tracing feature.
// To build with tracing enabled, make sure ACE_NTRACE is not defined
#if !defined (ACE_NTRACE)
#define ACE_NTRACE 1
#endif /* ACE_NTRACE */
