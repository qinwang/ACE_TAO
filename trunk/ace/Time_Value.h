/* -*- C++ -*- */
// $Id$


// ============================================================================
//
// = LIBRARY
//    ace
// 
// = FILENAME
//    Time_Value.h
//
// = AUTHOR
//    Doug Schmidt 
// 
// ============================================================================

#if !defined (ACE_TIME_VALUE_H)
#define ACE_TIME_VALUE_H

// This file should be a link to the platform/compiler-specific
// configuration file (e.g., config-sunos5-sunc++-4.x.h).  By
// including this here we avoid nasty circular include problems...
#include "ace/config.h"

#if defined (__ACE_INLINE__)
#define ACE_INLINE inline
#else
#define ACE_INLINE
#endif /* __ACE_INLINE__ */

// Nasty macro stuff to account for Microsoft Win32 DLL nonsense.  We
// use these macros so that we don't end up with ACE software
// hard-coded to Microsoft proprietary extensions to C++.

#if defined (ACE_HAS_DLL)
#if defined (ACE_BUILD_DLL)
#if !defined (_MSC_VER) /* Mark classes as exported, Borland. */
#define ACE_Export _export
#else /* Microsoft: */
#define ACE_Export __declspec (dllexport)
#endif /* !_MSC_VER */
#else /* Using the DLL. */
#if !defined _MSC_VER
#define ACE_Export _import
#else
#define ACE_Export  __declspec (dllimport)
#endif /* !_MSC_VER */
#endif /* ACE_BUILD_DLL */
 
#else /* We're not building a DLL! */
#define ACE_Export 
#endif /* ACE_HAS_DLL */

#if defined (ACE_HAS_DLL)
#if defined (ACE_BUILD_SVC_DLL)
#if !defined (_MSC_VER) /* Mark classes as exported, Borland. */
#define ACE_Svc_Export _export
#else /* Microsoft: */
#define ACE_Svc_Export __declspec (dllexport)
#endif /* !_MSC_VER */
#else /* Using the DLL. */
#if !defined _MSC_VER
#define ACE_Svc_Export _import
#else
#define ACE_Svc_Export  __declspec (dllimport)
#endif /* !_MSC_VER */
#endif /* ACE_BUILD_DLL || ACE_BUILD_SVC_DLL */
 
#else /* We're not building a DLL! */
#define ACE_Svc_Export 
#endif /* ACE_HAS_DLL */

// This needs to go here *first* to avoid problems with AIX.
// Just to be safe we'll do it with pthreads, too -- jwr
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
extern "C" {
#include <pthread.h>
#if defined (DIGITAL_UNIX)
#define pthread_self __pthread_self
extern "C" pthread_t pthread_self (void);
#endif /* DIGITAL_UNIX */
}
#endif /* ACE_HAS_DCETHREADS */

#if (ACE_NTRACE == 1)
#define ACE_TRACE(X)
#else
#define ACE_TRACE(X) ACE_Trace ____ (X, __LINE__, __FILE__)
#endif /* ACE_NTRACE */

#include <time.h>
#if defined (ACE_NEEDS_SYSTIME_H)
// Some platforms may need to include this, but I suspect that most
// will get it from <time.h>
#if defined (VXWORKS)
#include <sys/times.h>
#else
#include <sys/time.h>
#endif /* VXWORKS */
#endif /* ACE_NEEDS_SYSTIME_H */

#if !defined (ACE_HAS_POSIX_TIME)
// Definition per POSIX.
typedef struct timespec 
{		
  time_t tv_sec; // Seconds 
  long tv_nsec;	// Nanoseconds
} timespec_t;
#elif defined (ACE_HAS_BROKEN_POSIX_TIME)
// OSF/1 defines struct timespec in <sys/timers.h> - Tom Marrs
#include <sys/timers.h>
#endif /* ACE_HAS_POSIX_TIME */

#if !defined (ACE_HAS_SVR4_TIME)
// Definition per SVr4.
typedef struct timespec timestruc_t;	
#endif /* ACE_HAS_SVR4_TIME */

class ACE_Export ACE_Time_Value
  // = TITLE
  //     Operations on "timeval" structures.
  //
  // = DESCRIPTION
  //     This class centralizes all the time-related processing in
  //     ACE.  These timers are typically used in conjunction with
  //     lower-level OS mechanisms like select(), poll(), or
  //     cond_timedwait().  ACE_Time_Value help make the use of these
  //     mechanisms portable across OS platforms,
{
public:
  // = Useful constants.
  static const ACE_Time_Value zero;
  // Constant "0".

  // = Initialization method.
  ACE_Time_Value (long sec = 0, long usec = 0);
  // Default constructor.

  // = Methods for converting to/from various time formats.
  ACE_Time_Value (const struct timeval &t);
  // Construct a Time_Value from a timeval.

  ACE_Time_Value (const timestruc_t &t);
  //  Initializes the ACE_Time_Value object from a timestruc_t. 

  ACE_Time_Value (const ACE_Time_Value &tv);
  // Copy constructor.

#if defined(ACE_WIN32)
  ACE_Time_Value (const FILETIME &ft);
  //  Initializes the ACE_Time_Value object from a Win32 FILETIME
#endif

  void set (long sec = 0, long usec = 0);
  // Construct a Time_Value from a timeval.

  void set (const timeval &t);
  // Construct a Time_Value from a timeval.

  void set (const timestruc_t &t);
  //  Initializes the ACE_Time_Value object from a timestruc_t. 

#if defined(ACE_WIN32)
  void set (const FILETIME &ft);
  //  Initializes the ACE_Time_Value object from a timestruc_t. 
#endif

  long msec (void) const;
  // Converts from Time_Value format into milli-seconds format.

  void msec (long);
  // Converts from milli-seconds format into Time_Value format.

  operator timestruc_t () const;
  // Returns the value of the object as a timestruc_t. 

  operator timeval () const;
  // Returns the value of the object as a timeval.

#if defined(ACE_WIN32)
  operator FILETIME () const;
  // Returns the value of the object as a Win32 FILETIME.
#endif

  // = The following are accessor/mutator methods.

  long sec (void) const;
  // Get seconds.

  void sec (long sec);
  // Set seconds.

  long usec (void) const;
  // Get microseconds.
  
  void usec (long usec);
  // Set microseconds.

  // = The following are arithmetic methods for operating on
  // Time_Values.

  void operator += (const ACE_Time_Value &tv);
  // Add <tv> to this.

  void operator -= (const ACE_Time_Value &tv);
  // Subtract <tv> to this.

  friend ACE_Export ACE_Time_Value operator + (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);
  // Adds two ACE_Time_Value objects together, returns the sum.

  friend ACE_Export ACE_Time_Value operator - (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);
  // Subtracts two ACE_Time_Value objects, returns the difference.

  friend ACE_Export int operator < (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);
  // True if tv1 < tv2.

  friend ACE_Export int operator > (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);  
  // True if tv1 > tv2.

  friend ACE_Export int operator <= (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);
  // True if tv1 <= tv2.

  friend ACE_Export int operator >= (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);  
  // True if tv1 >= tv2.

  friend ACE_Export int operator == (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);  
  // True if tv1 == tv2.

  friend ACE_Export int operator != (const ACE_Time_Value &tv1, const ACE_Time_Value &tv2);  
  // True if tv1 != tv2.

  void dump (void) const;
  // Dump the state of an object.

private:
  void normalize (void);
  // Put the timevalue into a canonical form.

  long tv_sec_;
  // Seconds.
  
  long tv_usec_;
  // Microseconds.
};

#if defined (__ACE_INLINE__)
#include "ace/Time_Value.i"
#endif /* __ACE_INLINE__ */

#endif /* ACE_TIME_VALUE */
