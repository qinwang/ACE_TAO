/* -*- C++ -*- */
// $Id$

#if !defined (ACE_HAS_INLINED_OSCALLS)
#undef ACE_INLINE
#define ACE_INLINE
#endif /* ACE_HAS_INLINED_OSCALLS */

#if defined (ACE_LACKS_RLIMIT_PROTOTYPE)
int getrlimit (int resource, struct rlimit *rlp);
int setrlimit (int resource, const struct rlimit *rlp);
#endif /* ACE_LACKS_RLIMIT_PROTOTYPE */

#if !defined (ACE_HAS_STRERROR)
#if defined (ACE_HAS_SYS_ERRLIST)
extern char *sys_errlist[];
#define strerror(err) sys_errlist[err]
#else
#define strerror(err) "strerror is unsupported"
#endif /* ACE_HAS_SYS_ERRLIST */
#endif /* !ACE_HAS_STERROR */

#if defined (ACE_HAS_SYS_SIGLIST)
#if !defined (_sys_siglist)
#define _sys_siglist sys_siglist
#endif /* !defined (sys_siglist) */
//extern char **_sys_siglist;
#endif /* ACE_HAS_SYS_SIGLIST */

#if defined (ACE_HAS_SIZET_SOCKET_LEN)
typedef size_t ACE_SOCKET_LEN;
#else
typedef int ACE_SOCKET_LEN;
#endif /* ACE_HAS_SIZET_SOCKET_LEN */

#if defined (ACE_LACKS_CONST_STRBUF_PTR)
typedef struct strbuf *ACE_STRBUF_TYPE;
#else
typedef const struct strbuf *ACE_STRBUF_TYPE;
#endif /* ACE_LACKS_CONST_STRBUF_PTR */

#if defined (ACE_HAS_VOIDPTR_SOCKOPT)
typedef void *ACE_SOCKOPT_TYPE1;
#elif defined (ACE_HAS_CHARPTR_SOCKOPT)
typedef char *ACE_SOCKOPT_TYPE1;
#else
typedef const char *ACE_SOCKOPT_TYPE1;
#endif /* ACE_HAS_VOIDPTR_SOCKOPT */

#if defined (ACE_NEEDS_WRITEV)
extern "C" ACE_Export int writev (ACE_HANDLE handle, ACE_WRITEV_TYPE *iov, int iovcnt);
#endif /* ACE_NEEDS_WRITEV */

#if defined (ACE_NEEDS_READV)
extern "C" ACE_Export ssize_t readv (ACE_HANDLE handle, ACE_READV_TYPE *iov, int iovcnt);
#endif /* ACE_NEEDS_READV */

#if defined (ACE_NEEDS_FTRUNCATE)
extern "C" ACE_Export int ftruncate (ACE_HANDLE handle, long len);
#endif /* ACE_NEEDS_FTRUNCATE */

#if defined (ACE_HAS_VOIDPTR_MMAP)
// Needed for some odd OS's (e.g., SGI).
typedef void *ACE_MMAP_TYPE;
#else
typedef char *ACE_MMAP_TYPE;
#endif /* ACE_HAS_VOIDPTR_MMAP */

#if defined (ACE_HAS_XLI)
#include /**/ <xliuser.h>
#endif /* ACE_HAS_XLI */

#if !defined (ACE_HAS_CPLUSPLUS_HEADERS)
#include /**/ <libc.h>
#include /**/ <osfcn.h>
#endif /* ACE_HAS_CPLUSPLUS_HEADERS */

#if defined (ACE_HAS_SYSENT_H)
#include /**/ <sysent.h>
#endif /* ACE_HAS_SYSENT_H_*/

#if defined (ACE_HAS_SYS_FILIO_H)
#include /**/ <sys/filio.h>
#endif /* ACE_HAS_SYS_FILIO_H */

#if defined (ACE_HAS_SVR4_GETTIMEOFDAY)
#if !defined (m88k) && !defined (SCO)
extern "C" int gettimeofday (struct timeval *tp, void * = 0);
#else
extern "C" int gettimeofday (struct timeval *tp);
#endif  /*  !m88k && !SCO */
#elif defined (ACE_HAS_OSF1_GETTIMEOFDAY)
extern "C" int gettimeofday (struct timeval *tp, struct timezone * = 0);
#elif defined (ACE_HAS_SUNOS4_GETTIMEOFDAY)
#define ACE_HAS_SVR4_GETTIMEOFDAY
/*
#elif defined (ACE_HAS_IRIX_GETTIMEOFDAY)
extern "C" int gettimeofday (struct timeval *tp, ...);
#else
extern "C" int gettimeofday (struct timeval *tp);
*/
#endif /* ACE_HAS_SVR4_GETTIMEOFDAY */

#if defined (ACE_LACKS_CONST_TIMESPEC_PTR)
typedef struct timespec * ACE_TIMESPEC_PTR;
#else
typedef const struct timespec * ACE_TIMESPEC_PTR;
#endif /* HPUX */

#if !defined (ACE_LACKS_MALLOC_H)
#include /**/ <malloc.h>
#endif /* ACE_LACKS_MALLOC_H */

// Returns the value of the object as a timeval.

ACE_INLINE
ACE_Time_Value::operator timeval () const
{
  // ACE_TRACE ("ACE_Time_Value::operator timeval");
  return this->tv_;
}

// Returns a pointer to the object as a timeval.

ACE_INLINE
ACE_Time_Value::operator timeval * () const
{
  // ACE_TRACE ("ACE_Time_Value::operator timeval");
  return (timeval *) &this->tv_;
}

ACE_INLINE void
ACE_Time_Value::set (long sec, long usec)
{
  // ACE_TRACE ("ACE_Time_Value::set");
  this->tv_.tv_sec = sec;
  this->tv_.tv_usec = usec;
}

ACE_INLINE void
ACE_Time_Value::set (double d)
{
  // ACE_TRACE ("ACE_Time_Value::set");
  long l = (long) d;
  this->tv_.tv_sec = l;
  this->tv_.tv_usec = (long) ((d - (double) l) * ACE_ONE_SECOND_IN_USECS);
  this->normalize ();
}

// Initializes a timespec_t.  Note that this approach loses precision
// since it converts the nano-seconds into micro-seconds.  But then
// again, do any real systems have nano-second timer precision
// anyway?!

ACE_INLINE void
ACE_Time_Value::set (const timespec_t &tv)
{
  // ACE_TRACE ("ACE_Time_Value::set");
#if ! defined(ACE_HAS_BROKEN_TIMESPEC_MEMBERS)
  this->tv_.tv_sec = tv.tv_sec;
  // Convert nanoseconds into microseconds.
  this->tv_.tv_usec = tv.tv_nsec / 1000;
#else
  this->tv_.tv_sec = tv.ts_sec;
  // Convert nanoseconds into microseconds.
  this->tv_.tv_usec = tv.ts_nsec / 1000;
#endif /* ACE_HAS_BROKEN_TIMESPEC_MEMBERS */

  this->normalize ();
}

ACE_INLINE void
ACE_Time_Value::set (const timeval &tv)
{
  // ACE_TRACE ("ACE_Time_Value::set");
  this->tv_.tv_sec = tv.tv_sec;
  this->tv_.tv_usec = tv.tv_usec;

  this->normalize ();
}

ACE_INLINE
ACE_Time_Value::ACE_Time_Value (const timeval &tv)
{
  // ACE_TRACE ("ACE_Time_Value::ACE_Time_Value");
  this->set (tv);
}

ACE_INLINE
ACE_Time_Value::ACE_Time_Value (void)
{
  // ACE_TRACE ("ACE_Time_Value::ACE_Time_Value");
  this->set (0, 0);

  // Don't need to normalize time value of (0, 0).
}

ACE_INLINE
ACE_Time_Value::ACE_Time_Value (long sec, long usec)
{
  // ACE_TRACE ("ACE_Time_Value::ACE_Time_Value");
  this->set (sec, usec);
  this->normalize ();
}

// True if tv1 > tv2.

ACE_INLINE int
operator > (const ACE_Time_Value &tv1,
            const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator >");
  if (tv1.tv_.tv_sec > tv2.tv_.tv_sec)
    return 1;
  else if (tv1.tv_.tv_sec == tv2.tv_.tv_sec
           && tv1.tv_.tv_usec > tv2.tv_.tv_usec)
    return 1;
  else
    return 0;
}

// True if tv1 >= tv2.

ACE_INLINE int
operator >= (const ACE_Time_Value &tv1,
             const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator >=");
  if (tv1.tv_.tv_sec > tv2.tv_.tv_sec)
    return 1;
  else if (tv1.tv_.tv_sec == tv2.tv_.tv_sec
           && tv1.tv_.tv_usec >= tv2.tv_.tv_usec)
    return 1;
  else
    return 0;
}

// Returns the value of the object as a timespec_t.

ACE_INLINE
ACE_Time_Value::operator timespec_t () const
{
  // ACE_TRACE ("ACE_Time_Value::operator timespec_t");
  timespec_t tv;
#if ! defined(ACE_HAS_BROKEN_TIMESPEC_MEMBERS)
  tv.tv_sec = this->tv_.tv_sec;
  // Convert nanoseconds into microseconds.
  tv.tv_nsec = this->tv_.tv_usec * 1000;
#else
  tv.ts_sec = this->tv_.tv_sec;
  // Convert nanoseconds into microseconds.
  tv.ts_nsec = this->tv_.tv_usec * 1000;
#endif /* ACE_HAS_BROKEN_TIMESPEC_MEMBERS */
  return tv;
}

// Initializes the ACE_Time_Value object from a timespec_t.

ACE_INLINE
ACE_Time_Value::ACE_Time_Value (const timespec_t &tv)
{
  // ACE_TRACE ("ACE_Time_Value::ACE_Time_Value");
  this->set (tv);
}

// Initializes the ACE_Time_Value object from another ACE_Time_Value

ACE_INLINE
ACE_Time_Value::ACE_Time_Value (const ACE_Time_Value &tv)
  : tv_ (tv.tv_)
{
  // ACE_TRACE ("ACE_Time_Value::ACE_Time_Value");
}

// Returns number of seconds.

ACE_INLINE long
ACE_Time_Value::sec (void) const
{
  // ACE_TRACE ("ACE_Time_Value::sec");
  return this->tv_.tv_sec;
}

// Sets the number of seconds.

ACE_INLINE void
ACE_Time_Value::sec (long sec)
{
  // ACE_TRACE ("ACE_Time_Value::sec");
  this->tv_.tv_sec = sec;
}

// Converts from Time_Value format into milli-seconds format.

ACE_INLINE long
ACE_Time_Value::msec (void) const
{
  // ACE_TRACE ("ACE_Time_Value::msec");
  return this->tv_.tv_sec * 1000 + this->tv_.tv_usec / 1000;
}

// Converts from milli-seconds format into Time_Value format.

ACE_INLINE void
ACE_Time_Value::msec (long milliseconds)
{
  // ACE_TRACE ("ACE_Time_Value::msec");
  // Convert millisecond units to seconds;
  this->tv_.tv_sec = milliseconds / 1000;
  // Convert remainder to microseconds;
  this->tv_.tv_usec = (milliseconds - (this->tv_.tv_sec * 1000)) * 1000;
}

// Returns number of micro-seconds.

ACE_INLINE long
ACE_Time_Value::usec (void) const
{
  // ACE_TRACE ("ACE_Time_Value::usec");
  return this->tv_.tv_usec;
}

// Sets the number of micro-seconds.

ACE_INLINE void
ACE_Time_Value::usec (long usec)
{
  // ACE_TRACE ("ACE_Time_Value::usec");
  this->tv_.tv_usec = usec;
}

// True if tv1 < tv2.

ACE_INLINE int
operator < (const ACE_Time_Value &tv1,
            const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator <");
  return tv2 > tv1;
}

// True if tv1 >= tv2.

ACE_INLINE int
operator <= (const ACE_Time_Value &tv1,
             const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator <=");
  return tv2 >= tv1;
}

// True if tv1 == tv2.

ACE_INLINE int
operator == (const ACE_Time_Value &tv1,
             const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator ==");
  return tv1.tv_.tv_sec == tv2.tv_.tv_sec
    && tv1.tv_.tv_usec == tv2.tv_.tv_usec;
}

// True if tv1 != tv2.

ACE_INLINE int
operator != (const ACE_Time_Value &tv1,
             const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator !=");
  return !(tv1 == tv2);
}

// Add TV to this.

ACE_INLINE void
ACE_Time_Value::operator+= (const ACE_Time_Value &tv)
{
  // ACE_TRACE ("ACE_Time_Value::operator+=");
  this->tv_.tv_sec += tv.tv_.tv_sec;
  this->tv_.tv_usec += tv.tv_.tv_usec;
  this->normalize ();
}

// Subtract TV to this.

ACE_INLINE void
ACE_Time_Value::operator-= (const ACE_Time_Value &tv)
{
  // ACE_TRACE ("ACE_Time_Value::operator-=");
  this->tv_.tv_sec -= tv.tv_.tv_sec;
  this->tv_.tv_usec -= tv.tv_.tv_usec;
  this->normalize ();
}

// Adds two ACE_Time_Value objects together, returns the sum.

ACE_INLINE ACE_Time_Value
operator + (const ACE_Time_Value &tv1,
            const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator +");
  ACE_Time_Value sum (tv1.tv_.tv_sec + tv2.tv_.tv_sec,
                      tv1.tv_.tv_usec + tv2.tv_.tv_usec);

  sum.normalize ();
  return sum;
}

// Subtracts two ACE_Time_Value objects, returns the difference.

ACE_INLINE ACE_Time_Value
operator - (const ACE_Time_Value &tv1,
            const ACE_Time_Value &tv2)
{
  // ACE_TRACE ("operator -");
  ACE_Time_Value delta (tv1.tv_.tv_sec - tv2.tv_.tv_sec,
                        tv1.tv_.tv_usec - tv2.tv_.tv_usec);
  delta.normalize ();
  return delta;
}

#if !defined (ACE_WIN32)

#if !defined (ACE_LACKS_RPC_H)
#include /**/ <rpc/rpc.h>
#endif /* ACE_LACKS_RPC_H */

// Matthew Stevens 7-10-95 Fix GNU GCC 2.7 for memchr() problem.
#if defined (ACE_HAS_GNU_CSTRING_H)
// Define this file to keep /usr/include/memory.h from being included.
#include /**/ <cstring>
#else
#if defined (ACE_LACKS_MEMORY_H)
#include /**/ <string.h>
#else
#include /**/ <memory.h>
#endif /* VXWORKS */
#endif /* ACE_HAS_GNU_CSTRING_H */

// These prototypes are chronically lacking from many versions of
// UNIX.
extern "C" int t_getname (int, struct netbuf *, int);
extern "C" int isastream (int);
extern "C" int getrusage (int who, struct rusage *rusage);

#if defined (ACE_LACKS_SYSCALL)
extern "C" int syscall (int, ACE_HANDLE, struct rusage *);
#endif /* ACE_LACKS_SYSCALL */

#if defined (ACE_LACKS_MKTEMP)
extern "C" char *mktemp (char *);
#endif /* ACE_LACKS_MKTEMP */

// The following are #defines and #includes that must be visible for
// ACE to compile it's OS wrapper class implementation correctly.  We
// put them inside of here to reduce compiler overhead if we're not
// inlining...

#if defined (ACE_HAS_REGEX)
#include /**/ <regexpr.h>
#endif /* ACE_HAS_REGEX */

#if defined (ACE_HAS_SYSINFO)
#include /**/ <sys/systeminfo.h>
#endif /* ACE_HAS_SYS_INFO */

#if defined (ACE_HAS_SYSCALL_H)
#include /**/ <sys/syscall.h>
#endif /* ACE_HAS_SYSCALL_H */

#if defined (UNIXWARE)  /* See strcasecmp, below */
#include /**/ <ctype.h>
#endif /* UNIXWARE */

// Adapt the weird threading and synchronization routines (which don't
// return -1 normally) so that they return -1 and work correctly with
// the ACE_OSCALL macros.
#if defined (VXWORKS)
#define ACE_ADAPT_RETVAL(OP,RESULT) ((RESULT = (OP)) != OK ? (errno = RESULT, -1) : 0)
#else
#define ACE_ADAPT_RETVAL(OP,RESULT) ((RESULT = (OP)) != 0 ? (errno = RESULT, -1) : 0)
#endif /* VXWORKS */

ACE_INLINE int
ACE_OS::chdir (const char *path)
{
  // ACE_TRACE ("ACE_OS::chdir");
#if defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::chdir ((char *) path), ace_result_),
                     int, -1);
#else
  ACE_OSCALL_RETURN (::chdir (path), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::fcntl (ACE_HANDLE handle, int cmd, int value)
{
  // ACE_TRACE ("ACE_OS::fcntl");
#if defined (ACE_LACKS_FCNTL)
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (value);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::fcntl (handle, cmd, value), int, -1);
#endif /* ACE_LACKS_FCNTL */
}

ACE_INLINE int
ACE_OS::fstat (ACE_HANDLE handle, struct stat *stp)
{
  // ACE_TRACE ("ACE_OS::fstat");
  ACE_OSCALL_RETURN (::fstat (handle, stp), int, -1);
}

ACE_INLINE gid_t
ACE_OS::getgid (void)
{
  // ACE_TRACE ("ACE_OS::getgid");
#if defined (VXWORKS)
  // getgid() is not supported:  just one group anyways
  return 0;
#else
  ACE_OSCALL_RETURN (::getgid (), gid_t, (gid_t) -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::getopt (int argc, char *const *argv, const char *optstring)
{
  // ACE_TRACE ("ACE_OS::getopt");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (argc);
  ACE_UNUSED_ARG (argv);
  ACE_UNUSED_ARG (optstring);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_LACKS_GETOPT_PROTO)
  ACE_OSCALL_RETURN (::getopt (argc, (char**) argv, optstring), int, -1);
#elif defined (ACE_LACKS_SOME_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::getopt (argc, (const char* const *) argv, optstring), int, -1);
#else
  ACE_OSCALL_RETURN (::getopt (argc, argv, optstring), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE uid_t
ACE_OS::getuid (void)
{
  // ACE_TRACE ("ACE_OS::getuid");
#if defined (VXWORKS)
  // getuid() is not supported:  just one user anyways
  return 0;
#else
  ACE_OSCALL_RETURN (::getuid (), uid_t, (uid_t) -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::isatty (ACE_HANDLE fd)
{
  // ACE_TRACE ("ACE_OS::isatty");
  ACE_OSCALL_RETURN (::isatty (fd), int, -1);
}

ACE_INLINE int
ACE_OS::mkfifo (const char *file, mode_t mode)
{
  // ACE_TRACE ("ACE_OS::mkfifo");
#if defined (VXWORKS) || defined (CHORUS)
  ACE_UNUSED_ARG (file);
  ACE_UNUSED_ARG (mode);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::mkfifo (file, mode), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::pipe (ACE_HANDLE fds[])
{
  // ACE_TRACE ("ACE_OS::pipe");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (fds);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::pipe (fds), int, -1);
#endif /* VXWORKS */
}

#if defined (DIGITAL_UNIX)
extern "C" {
  extern char *_Pctime_r (const time_t *, char *);
  extern struct tm *_Plocaltime_r (const time_t *, struct tm *);
  extern struct tm *_Pgmtime_r (const time_t *, struct tm *);
  extern char *_Pasctime_r (const struct tm *, char *);
  extern int _Prand_r (unsigned int *seedptr);
  extern int _Pgetpwnam_r (const char *, struct passwd *,
                           char *, size_t, struct passwd **);
}
#endif /* DIGITAL_UNIX */

ACE_INLINE int
ACE_OS::rand_r (ACE_RANDR_TYPE seed)
{
  // ACE_TRACE ("ACE_OS::rand_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if defined (DIGITAL_UNIX)
  ACE_OSCALL_RETURN (::_Prand_r (seed), int, -1);
#elif defined (HPUX_10)
  // rand() is thread-safe on HP-UX 10.  rand_r's signature is not consistent
  // with latest POSIX and will change in a future HP-UX release so that it
  // is consistent.  At that point, this #elif section can be changed or
  // removed, and just call rand_r.
  ACE_UNUSED_ARG (seed);
  ACE_OSCALL_RETURN (::rand(), int, -1);
#else
  ACE_OSCALL_RETURN (::rand_r (seed), int, -1);
#endif /* DIGITAL_UNIX */
#else
  ACE_UNUSED_ARG (seed);
  ACE_OSCALL_RETURN (::rand (), int, -1);
#endif /* ACE_HAS_REENTRANT_FUNCTIONS */
}

ACE_INLINE pid_t
ACE_OS::setsid (void)
{
  // ACE_TRACE ("ACE_OS::setsid");
#if defined (VXWORKS) || defined (CHORUS)
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::setsid (), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE mode_t
ACE_OS::umask (mode_t cmask)
{
  // ACE_TRACE ("ACE_OS::umask");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (cmask);
  ACE_NOTSUP_RETURN (-1);
#else
  return ::umask (cmask); // This call shouldn't fail...
#endif /* VXWORKS */
}

#else /* ACE_WIN32 */

// This is for Win32 exclusively!

// Adapt the Win32 System Calls (which return BOOLEAN values of TRUE
// and FALSE) into int values expected by the ACE_OSCALL macros.
#define ACE_ADAPT_RETVAL(OP,RESULT) ((RESULT = (OP)) == FALSE ? -1 : 0)

// Perform a mapping of Win32 error numbers into POSIX errnos.
#define ACE_FAIL_RETURN(RESULT) do { \
  switch (errno = ::GetLastError ()) { \
  case ERROR_NOT_ENOUGH_MEMORY: errno = ENOMEM; break; \
  case ERROR_FILE_EXISTS:       errno = EEXIST; break; \
  case ERROR_SHARING_VIOLATION: errno = EACCES; break; \
  case ERROR_PATH_NOT_FOUND:    errno = ENOENT; break; \
  } \
  return RESULT; } while (0)

ACE_INLINE int
ACE_OS::chdir (const char *path)
{
  // ACE_TRACE ("ACE_OS::chdir");
  ACE_OSCALL_RETURN (::_chdir (path), int, -1);
}

ACE_INLINE int
ACE_OS::fcntl (ACE_HANDLE handle, int cmd, int value)
{
  // ACE_TRACE ("ACE_OS::fcntl");
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (value);

  ACE_NOTSUP_RETURN (-1); // We should be able to map this stuff
}

ACE_INLINE uid_t
ACE_OS::getgid (void)
{
  // ACE_TRACE ("ACE_OS::getgid");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE int
ACE_OS::getopt (int argc, char *const *argv, const char *optstring)
{
  ACE_UNUSED_ARG (argc);
  ACE_UNUSED_ARG (argv);
  ACE_UNUSED_ARG (optstring);

  // ACE_TRACE ("ACE_OS::getopt");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE uid_t
ACE_OS::getuid (void)
{
  // ACE_TRACE ("ACE_OS::getuid");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE int
ACE_OS::isatty (ACE_HANDLE fd)
{
  // ACE_TRACE ("ACE_OS::isatty");
  ACE_OSCALL_RETURN (::_isatty ((int) fd), int, -1);
}

ACE_INLINE int
ACE_OS::mkfifo (const char *file, mode_t mode)
{
  ACE_UNUSED_ARG (file);
  ACE_UNUSED_ARG (mode);

  // ACE_TRACE ("ACE_OS::mkfifo");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE int
ACE_OS::pipe (ACE_HANDLE fds[])
{
  // ACE_TRACE ("ACE_OS::pipe");
  ACE_OSCALL_RETURN (::_pipe ((int *) fds, PIPE_BUF, 0), int, -1);   // Use default mode
}

ACE_INLINE int
ACE_OS::rand_r (ACE_RANDR_TYPE seed)
{
  ACE_UNUSED_ARG (seed);

  // ACE_TRACE ("ACE_OS::rand_r");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE pid_t
ACE_OS::setsid (void)
{
  // ACE_TRACE ("ACE_OS::setsid");
  ACE_NOTSUP_RETURN (-1);
}

ACE_INLINE mode_t
ACE_OS::umask (mode_t cmask)
{
  // ACE_TRACE ("ACE_OS::umask");
  ACE_OSCALL_RETURN (::_umask (cmask), int, -1);
}

ACE_INLINE int
ACE_OS::fstat (ACE_HANDLE handle, struct stat *stp)
{
  // ACE_TRACE ("ACE_OS::fstat");
  ACE_OSCALL_RETURN (::_fstat ((int) handle, (struct _stat *) stp), int, -1);
}

#endif /* WIN32 */

ACE_INLINE int
ACE_OS::clock_gettime (clockid_t clockid, struct timespec *ts)
{
  // ACE_TRACE ("ACE_OS::clock_gettime");
#if defined (ACE_HAS_CLOCK_GETTIME)
  ACE_OSCALL_RETURN (::clock_gettime (clockid, ts), int, -1);
#else
  ACE_UNUSED_ARG (clockid);
  ACE_UNUSED_ARG (ts);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_CLOCK_GETTIME */
}

ACE_INLINE ACE_Time_Value
ACE_OS::gettimeofday (void)
{
  // ACE_TRACE ("ACE_OS::gettimeofday");
  timeval tv;
  int result = 0;
#if defined (ACE_WIN32)
  // From Todd Montgomery...
  struct _timeb tb;
  ::_ftime (&tb);
  tv.tv_sec = tb.time;
  tv.tv_usec = 1000 * tb.millitm;
#elif defined (ACE_HAS_AIX_HI_RES_TIMER)
  timebasestruct_t tb;

  ::read_real_time (&tb, TIMEBASE_SZ);
  ::time_base_to_time (&tb, TIMEBASE_SZ);

  tv.tv_sec = tb.tb_high;
  tv.tv_usec = tb.tb_low / 1000L;
#else
#if defined (ACE_HAS_TIMEZONE_GETTIMEOFDAY) || \
  (defined (ACE_HAS_SVR4_GETTIMEOFDAY) && !defined (m88k) && !defined (SCO))
  ACE_OSCALL (::gettimeofday (&tv, 0), int, -1, result);
#elif defined (VXWORKS) || defined (CHORUS)
  // Assumes that struct timespec is same size as struct timeval,
  // which assumes that time_t is a long: it currently (VxWorks 5.2/5.3) is.
  struct timespec ts;

  ACE_OSCALL (ACE_OS::clock_gettime (CLOCK_REALTIME, &ts), int, -1, result);
  tv.tv_sec = ts.tv_sec;
  tv.tv_usec = ts.tv_nsec / 1000L;  // timespec has nsec, but timeval has usec
#else
  ACE_OSCALL (::gettimeofday (&tv), int, -1, result);
#endif /* ACE_HAS_SVR4_GETTIMEOFDAY */
#endif /* ACE_WIN32 */
  if (result == -1)
    return -1;
  else
    return ACE_Time_Value (tv);
}

ACE_INLINE int
ACE_OS::stat (const char *file, struct stat *stp)
{
  // ACE_TRACE ("ACE_OS::stat");
#if defined (VXWORKS)
  ACE_OSCALL_RETURN (::stat ((char *) file, stp), int, -1);
#else
  ACE_OSCALL_RETURN (::stat (file, stp), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE time_t
ACE_OS::time (time_t *tloc)
{
  // ACE_TRACE ("ACE_OS::time");
  ACE_OSCALL_RETURN (::time (tloc), time_t, (time_t) -1);
}

ACE_INLINE void
ACE_OS::srand (u_int seed)
{
  // ACE_TRACE ("ACE_OS::srand");
  ::srand (seed);
}

ACE_INLINE int
ACE_OS::rand (void)
{
  // ACE_TRACE ("ACE_OS::rand");
  ACE_OSCALL_RETURN (::rand (), int, -1);
}

ACE_INLINE int
ACE_OS::unlink (const char *path)
{
  // ACE_TRACE ("ACE_OS::unlink");
#if defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::unlink ((char *) path), ace_result_),
                     int, -1);
#else
  ACE_OSCALL_RETURN (::unlink (path), int, -1);
#endif /* VXWORKS */
}


ACE_INLINE char *
ACE_OS::tempnam (const char *dir, const char *pfx)
{
  // ACE_TRACE ("ACE_OS::tempnam");
#if defined (VXWORKS) || defined (ACE_LACKS_TEMPNAM)
  ACE_UNUSED_ARG (dir);
  ACE_UNUSED_ARG (pfx);
  ACE_NOTSUP_RETURN (0);
#else
#if defined (WIN32)
  ACE_OSCALL_RETURN (::_tempnam (dir, pfx), char *, 0);
#else
  ACE_OSCALL_RETURN (::tempnam (dir, pfx), char *, 0);
#endif /* WIN32 */
#endif /* VXWORKS */
}


ACE_INLINE LPTSTR
ACE_OS::cuserid (LPTSTR user, size_t maxlen)
{
  // ACE_TRACE ("ACE_OS::cuserid");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (maxlen);
  if (user == 0)
    {
      // Require that the user field be non-null, i.e., don't
      // allocate or use static storage.
      ACE_NOTSUP_RETURN (0);
    }
  else
    {
      ::remCurIdGet (user, 0);
      return user;
    }
#elif defined (CHORUS)
  ACE_UNUSED_ARG (user);
  ACE_UNUSED_ARG (maxlen);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_WIN32)
  BOOL result = ::GetUserName (user, (u_long *) &maxlen);
  if (result == FALSE)
    ACE_FAIL_RETURN (0);
  else
    return user;
#else
  // Hackish because of missing buffer size!
  ACE_UNUSED_ARG (maxlen);
  ACE_OSCALL_RETURN (::cuserid (user), char *, 0);
#endif /* VXWORKS */
}

// Doesn't need a macro since it *never* returns!

ACE_INLINE void
ACE_OS::_exit (int status)
{
  // ACE_TRACE ("ACE_OS::_exit");
#if defined (VXWORKS)
  ::exit (status);
#else
  ::_exit (status);
#endif /* VXWORKS */
}

ACE_INLINE void *
ACE_OS::malloc (size_t nbytes)
{
  // ACE_TRACE ("ACE_OS::malloc");
  return ::malloc (nbytes);
}

ACE_INLINE void *
ACE_OS::calloc (size_t elements, size_t sizeof_elements)
{
  // ACE_TRACE ("ACE_OS::calloc");
  return ::calloc (elements, sizeof_elements);
}

ACE_INLINE void *
ACE_OS::realloc (void *ptr, size_t nbytes)
{
  // ACE_TRACE ("ACE_OS::realloc");
  return ::realloc (ACE_MALLOC_T (ptr), nbytes);
}

ACE_INLINE void
ACE_OS::free (void *ptr)
{
  // ACE_TRACE ("ACE_OS::free");
  ::free (ACE_MALLOC_T (ptr));
}

ACE_INLINE int
ACE_OS::memcmp (const void *t, const void *s, size_t len)
{
  // ACE_TRACE ("ACE_OS::memcmp");
  return ::memcmp (t, s, len);
}

ACE_INLINE void *
ACE_OS::memcpy (void *t, const void *s, size_t len)
{
  // ACE_TRACE ("ACE_OS::memcpy");
  return ::memcpy (t, s, len);
}

ACE_INLINE void *
ACE_OS::memmove (void *t, const void *s, size_t len)
{
  // ACE_TRACE ("ACE_OS::memcpy");
  return ::memmove (t, s, len);
}

ACE_INLINE void *
ACE_OS::memset (void *s, int c, size_t len)
{
  // ACE_TRACE ("ACE_OS::memset");
  return ::memset (s, c, len);
}

ACE_INLINE char *
ACE_OS::strcat (char *s, const char *t)
{
  // ACE_TRACE ("ACE_OS::strcat");
  return ::strcat (s, t);
}

ACE_INLINE char *
ACE_OS::strstr (const char *s, const char *t)
{
  // ACE_TRACE ("ACE_OS::strstr");
  return ::strstr (s, t);
}

ACE_INLINE size_t
ACE_OS::strspn (const char *s, const char *t)
{
  // ACE_TRACE ("ACE_OS::strstr");
  return ::strspn (s, t);
}

ACE_INLINE char *
ACE_OS::strchr (const char *s, int c)
{
  // ACE_TRACE ("ACE_OS::strchr");
  return ::strchr (s, c);
}

ACE_INLINE char *
ACE_OS::strrchr (const char *s, int c)
{
  // ACE_TRACE ("ACE_OS::strrchr");
  return ::strrchr (s, c);
}

ACE_INLINE int
ACE_OS::strcmp (const char *s, const char *t)
{
  // ACE_TRACE ("ACE_OS::strcmp");
  return ::strcmp (s, t);
}

ACE_INLINE char *
ACE_OS::strcpy (char *s, const char *t)
{
  // ACE_TRACE ("ACE_OS::strcpy");
  return ::strcpy (s, t);
}

ACE_INLINE int
ACE_OS::tolower (int c)
{
  // ACE_TRACE ("ACE_OS::tolower");
  return ::tolower (c);
}

ACE_INLINE char *
ACE_OS::strpbrk (const char *s1, const char *s2)
{
  return ::strpbrk (s1, s2);
}

ACE_INLINE char *
ACE_OS::strdup (const char *s)
{
  // ACE_TRACE ("ACE_OS::strdup");
#if defined (VXWORKS) || defined (CHORUS)
  char *t = (char *) ::malloc (::strlen (s) + 1);
  if (t == 0)
    return 0;
  else
    return ACE_OS::strcpy (t, s);
#else
  return ::strdup (s);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::vsprintf (char *buffer, const char *format, va_list argptr)
{
  return ACE_SPRINTF_ADAPTER (::vsprintf (buffer, format, argptr));
}

ACE_INLINE size_t
ACE_OS::strlen (const char *s)
{
  // ACE_TRACE ("ACE_OS::strlen");
  return ::strlen (s);
}

ACE_INLINE int
ACE_OS::strcasecmp (const char *s, const char *t)
{
#if !defined (ACE_WIN32)
  // ACE_TRACE ("ACE_OS::strcasecmp");
#if defined (ACE_LACKS_STRCASECMP)
  // Handles most of what the BSD version does, but does not indicate
  // lexicographic ordering if the strings are unequal.  Just
  // indicates equal (ignoring case) by return value == 0, else not
  // equal.
  int result = 0;

  if (ACE_OS::strlen (s) != ACE_OS::strlen (t))
    result = 1;
   else
     {
       for (;
            *s != '\0' && *t != '\0';
            ++s; ++t)
         if (ACE_OS::tolower (*s) != ACE_OS::tolower (*t))
           {
             result = ((ACE_OS::tolower (*s) < ACE_OS::tolower (*t)) ? -1 : 1);
             break;
           }
     }

   return result; // == 0 for match, else 1
#else
  return ::strcasecmp (s, t);
#endif /* ACE_LACKS_STRCASECMP */
#else /* ACE_WIN32 */
  return ::_stricmp (s, t);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::strncasecmp (const char *s, const char *t, size_t len)
{
#if !defined (ACE_WIN32)
  // ACE_TRACE ("ACE_OS::strcasecmp");
#if defined (ACE_LACKS_STRCASECMP)
  // Handles most of what the BSD version does, but does not indicate
  // lexicographic ordering if the strings are unequal.  Just
  // indicates equal (ignoring case) by return value == 0, else not
  // equal.
  int result = 0;

  while (*s != '\0' && *t != '\0' && len != 0)
    {
      if (ACE_OS::tolower (*s) != ACE_OS::tolower (*t))
        {
          result = ((ACE_OS::tolower (*s) < ACE_OS::tolower (*t)) ? -1 : 1);
          break;
        }

      ++s; ++t; --len;
    }
  }

  return result; // == 0 for match, else 1
#else
  return ::strncasecmp (s, t, len);
#endif /* ACE_LACKS_STRCASECMP */
#else /* ACE_WIN32 */
  return ::_strnicmp (s, t, len);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::strncmp (const char *s, const char *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncmp");
  return ::strncmp (s, t, len);
}

ACE_INLINE char *
ACE_OS::strncpy (char *s, const char *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncpy");
  return ::strncpy (s, t, len);
}

ACE_INLINE char *
ACE_OS::strncat (char *s, const char *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncat");
  return ::strncat (s, t, len);
}

ACE_INLINE char *
ACE_OS::strtok (char *s, const char *tokens)
{
  // ACE_TRACE ("ACE_OS::strtok");
  return ::strtok (s, tokens);
}

ACE_INLINE char *
ACE_OS::strtok_r (char *s, const char *tokens, char **lasts)
{
  // ACE_TRACE ("ACE_OS::strtok_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
  return ::strtok_r (s, tokens, lasts);
#else
  if (s == 0)
    s = *lasts;
  else
    *lasts = s;
  if (*s == 0)                  // We have reached the end
    return 0;
  int l_org = ACE_OS::strlen (s);
  int l_sub = ACE_OS::strlen (s = ::strtok (s, tokens));
  *lasts = s + l_sub;
  if (l_sub != l_org)
    *lasts += 1;
  return s ;
#endif /* (ACE_HAS_REENTRANT_FUNCTIONS) */
}

ACE_INLINE char *
ACE_OS::strsplit_r (char *str, const char *token, char *&next_start)
{
  char *tok_loc;
  char *ret = 0;

  if (str != 0)
    next_start = str;

  if ( (tok_loc = strstr(next_start, token)) != 0)
    {
      ret = next_start;         // return the beginning of the string
      *tok_loc = '\0';          // insure its terminated
      next_start = tok_loc + strlen(token);
    }

  return ret;
}

ACE_INLINE long
ACE_OS::strtol (const char *s, char **ptr, int base)
{
  // ACE_TRACE ("ACE_OS::strtol");
  return ::strtol (s, ptr, base);
}

ACE_INLINE unsigned long
ACE_OS::strtoul (const char *s, char **ptr, int base)
{
  // ACE_TRACE ("ACE_OS::strtol");
  return ::strtoul (s, ptr, base);
}

ACE_INLINE long
ACE_OS::sysconf (int name)
{
  // ACE_TRACE ("ACE_OS::sysconf");
#if defined (ACE_WIN32) || defined (VXWORKS)
  ACE_UNUSED_ARG (name);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::sysconf (name), long, -1);
#endif /* ACE_WIN32 || VXWORKS */
}

ACE_INLINE int
ACE_OS::mutex_init (ACE_mutex_t *m,
                    int type,
                    LPCTSTR name,
                    void *arg,
                    LPSECURITY_ATTRIBUTES sa)
{
  // ACE_TRACE ("ACE_OS::mutex_init");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined(ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (sa);

  pthread_mutexattr_t attributes;
  int result = -1;

#if defined (ACE_HAS_DCETHREADS)
  if (::pthread_mutexattr_create (&attributes) == 0
#if !defined (ACE_DOES_NOT_HAVE_SETKIND_NP)
      && ::pthread_mutexattr_setkind_np (&attributes, type) == 0
#endif
      && ::pthread_mutex_init (m, attributes) == 0)
#else
    if (::pthread_mutexattr_init (&attributes) == 0
#if defined (ACE_HAS_PTHREAD_MUTEXATTR_SETKIND_NP)
        && ::pthread_mutexattr_setkind_np (&attributes, type) == 0
#endif /* ACE_HAS_PTHREAD_MUTEXATTR_SETKIND_NP */
        && ::pthread_mutex_init (m, &attributes) == 0)
#endif /* ACE_HAS_DCETHREADS */
      result = 0;

#if !defined (ACE_HAS_PTHREAD_MUTEXATTR_SETKIND_NP)
  ACE_UNUSED_ARG (type);
#endif /* ! ACE_HAS_PTHREAD_MUTEXATTR_SETKIND_NP */

#if defined (ACE_HAS_DCETHREADS)
  ::pthread_mutexattr_delete (&attributes);
#else
  ::pthread_mutexattr_destroy (&attributes);
#endif /* ACE_HAS_DCETHREADS */

  return result;
#elif defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (sa);
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::mutex_init (m, type, arg),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_WTHREADS)
  m->type_ = type;

  switch (type)
    {
    case USYNC_PROCESS:
      m->proc_mutex_ = ::CreateMutex (sa, FALSE, name);
      if (m->proc_mutex_ == 0)
        ACE_FAIL_RETURN (-1);
      else
        return 0;
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_init (&m->thr_mutex_, type, name, arg);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (sa);

  // Type includes these options: SEM_Q_PRIORITY, SEM_Q_FIFO, SEM_DELETE_SAFE,
  // and SEM_INVERSION_SAFE that are currently outside of the ACE mutex model.
  return (*m = ::semMCreate (type)) == 0 ? -1 : 0;
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (sa);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::mutex_destroy (ACE_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::mutex_destroy");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (::pthread_mutex_destroy (m), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_mutex_destroy (m), ace_result_), int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::mutex_destroy (m), ace_result_), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  switch (m->type_)
    {
    case USYNC_PROCESS:
      ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::CloseHandle (m->proc_mutex_),
                                           ace_result_),
                         int, -1);
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_destroy (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  return ::semDelete (*m) == OK ? 0 : -1;
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::mutex_lock (ACE_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::mutex_lock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  // Note, don't use "::" here since the following call is often a macro.
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (pthread_mutex_lock (m), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (pthread_mutex_lock (m), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::mutex_lock (m), ace_result_), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  switch (m->type_)
    {
    case USYNC_PROCESS:
      // Timeout can't occur, so don't bother checking...

      switch (::WaitForSingleObject (m->proc_mutex_, INFINITE))
        {
        case WAIT_OBJECT_0:
        case WAIT_ABANDONED:
          // We will ignore abandonments in this method
          // Note that we still hold the lock
          return 0;
        default:
          // This is a hack, we need to find an appropriate mapping...
          errno = ::GetLastError ();
          return -1;
        }
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_lock (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  return ::semTake (*m, WAIT_FOREVER) == OK ? 0 : -1;
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::mutex_lock (ACE_mutex_t *m, int &abandoned)
{
  // ACE_TRACE ("ACE_OS::mutex_lock");
#if defined (ACE_HAS_THREADS) && defined (ACE_HAS_WTHREADS)
  abandoned = 0;
  switch (m->type_)
    {
    case USYNC_PROCESS:
      // Timeout can't occur, so don't bother checking...

      switch (::WaitForSingleObject (m->proc_mutex_, INFINITE))
        {
        case WAIT_OBJECT_0:
          return 0;
        case WAIT_ABANDONED:
          abandoned = 1;
          return 0;  // something goofed, but we hold the lock ...
        default:
          // This is a hack, we need to find an appropriate mapping...
          errno = ::GetLastError ();
          return -1;
        }
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_lock (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#else
  ACE_UNUSED_ARG (m);
  ACE_UNUSED_ARG (abandoned);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS and ACE_HAS_WTHREADS */
}

ACE_INLINE int
ACE_OS::mutex_trylock (ACE_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::mutex_trylock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  // Note, don't use "::" here since the following call is often a macro.
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (pthread_mutex_trylock (m), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (pthread_mutex_trylock (m), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::mutex_trylock (m), ace_result_), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  switch (m->type_)
    {
    case USYNC_PROCESS:
      {
        // Try for 0 milliseconds - i.e. nonblocking.
        switch (::WaitForSingleObject (m->proc_mutex_, 0))
          {
          case WAIT_OBJECT_0:
            return 0;
          case WAIT_ABANDONED:
            // We will ignore abandonments in this method
            // Note that we still hold the lock
            return 0;
          case WAIT_TIMEOUT:
            errno = EBUSY;
            return -1;
          default:
            errno = ::GetLastError ();
            return -1;
          }
      }
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_trylock (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  if (::semTake (*m, NO_WAIT) == ERROR)
    if (errno == S_objLib_OBJ_TIMEOUT)
      {
        // couldn't get the semaphore
        errno = EBUSY;
        return -1;
      }
    else
      // error
      return -1;
  else
    // got the semaphore
    return 0;
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::mutex_trylock (ACE_mutex_t *m, int &abandoned)
{
#if defined (ACE_HAS_THREADS) && defined (ACE_HAS_WTHREADS)
  abandoned = 0;
  switch (m->type_)
    {
    case USYNC_PROCESS:
      {
        // Try for 0 milliseconds - i.e. nonblocking.
        switch (::WaitForSingleObject (m->proc_mutex_, 0))
          {
          case WAIT_OBJECT_0:
            return 0;
          case WAIT_ABANDONED:
            abandoned = 1;
            return 0;  // something goofed, but we hold the lock ...
          case WAIT_TIMEOUT:
            errno = EBUSY;
            return -1;
          default:
            errno = ::GetLastError ();
            return -1;
          }
      }
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_trylock (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#else
  ACE_UNUSED_ARG (m);
  ACE_UNUSED_ARG (abandoned);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS and ACE_HAS_WTHREADS */
}

ACE_INLINE int
ACE_OS::mutex_unlock (ACE_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::mutex_unlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  // Note, don't use "::" here since the following call is often a macro.
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (pthread_mutex_unlock (m), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (pthread_mutex_unlock (m), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::mutex_unlock (m), ace_result_), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  switch (m->type_)
    {
    case USYNC_PROCESS:
      ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::ReleaseMutex (m->proc_mutex_),
                                           ace_result_),
                         int, -1);
    case USYNC_THREAD:
      return ACE_OS::thread_mutex_unlock (&m->thr_mutex_);
    default:
      errno = EINVAL;
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  return ::semGive (*m) == OK ? 0 : -1;
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thread_mutex_init (ACE_thread_mutex_t *m,
                           int type,
                           LPCTSTR name,
                           void *arg)
{
  // ACE_TRACE ("ACE_OS::thread_mutex_init");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (type);
  // Force the use of USYNC_THREAD!
  return ACE_OS::mutex_init (m, USYNC_THREAD, name, arg);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);

  ::InitializeCriticalSection (m);
  return 0;
#elif defined (VXWORKS)
  return mutex_init (m, type, name, arg);
#endif /* ACE_HAS_STHREADS || ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thread_mutex_destroy (ACE_thread_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::thread_mutex_destroy");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  return ACE_OS::mutex_destroy (m);
#elif defined (ACE_HAS_WTHREADS)
  ::DeleteCriticalSection (m);
  return 0;
#elif defined (VXWORKS)
  return mutex_destroy (m);
#endif /* ACE_HAS_STHREADS || ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thread_mutex_lock (ACE_thread_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::thread_mutex_lock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  return ACE_OS::mutex_lock (m);
#elif defined (ACE_HAS_WTHREADS)
  ::EnterCriticalSection (m);
  return 0;
#elif defined (VXWORKS)
  return mutex_lock (m);
#endif /* ACE_HAS_STHREADS || ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thread_mutex_trylock (ACE_thread_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::thread_mutex_trylock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  return ACE_OS::mutex_trylock (m);
#elif defined (ACE_HAS_WTHREADS)
#if defined (ACE_HAS_WIN32_TRYLOCK)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::TryEnterCriticalSection (m), ace_result_),
                     int, -1) ;
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_WIN32_TRYLOCK */
#elif defined (VXWORKS)
  return ACE_OS::mutex_trylock (m);
#endif /* ACE_HAS_STHREADS || ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thread_mutex_unlock (ACE_thread_mutex_t *m)
{
  // ACE_TRACE ("ACE_OS::thread_mutex_unlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  return ACE_OS::mutex_unlock (m);
#elif defined (ACE_HAS_WTHREADS)
  ::LeaveCriticalSection (m);
  return 0;
#elif defined (VXWORKS)
  return ACE_OS::mutex_unlock (m);
#endif /* ACE_HAS_STHREADS || ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (m);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

#if !defined (ACE_LACKS_COND_T)
// NOTE: The ACE_OS::cond_* functions for Unix platforms are defined
// here because the ACE_OS::sema_* functions below need them.
// However, ACE_WIN32 and VXWORKS define the ACE_OS::cond_* functions
// using the ACE_OS::sema_* functions.  So, they appear after the
// ACE_OS::sema_* functions.
ACE_INLINE int
ACE_OS::cond_destroy (ACE_cond_t *cv)
{
  // ACE_TRACE ("ACE_OS::cond_destroy");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (::pthread_cond_destroy (cv), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_cond_destroy (cv), ace_result_), int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::cond_destroy (cv), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_init (ACE_cond_t *cv, int type, LPCTSTR name, void *arg)
{
// ACE_TRACE ("ACE_OS::cond_init");
  type = type;
  name = name;
  arg = arg;
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  pthread_condattr_t attributes;
  int result = -1;

#if defined  (ACE_HAS_DCETHREADS)
  if (::pthread_condattr_create (&attributes) == 0
      && ::pthread_cond_init (cv, attributes) == 0
#else
  if (::pthread_condattr_init (&attributes) == 0
      && ::pthread_cond_init (cv, &attributes) == 0
#  if defined (ACE_HAS_PTHREAD_CONDATTR_SETKIND_NP)
      && ::pthread_condattr_setkind_np (&attributes, type) == 0
#  endif /* ACE_HAS_PTHREAD_CONDATTR_SETKIND_NP */
#endif /* ACE_HAS_DCETHREADS */
#if !defined (ACE_LACKS_CONDATTR_PSHARED)
      && ::pthread_condattr_setpshared (&attributes, type) == 0
#endif /* ACE_LACKS_CONDATTR_PSHARED */
      )
  result = 0;

#if defined (ACE_HAS_DCETHREADS)
  ::pthread_condattr_delete (&attributes);
#else
  ::pthread_condattr_destroy (&attributes);
#endif /* ACE_HAS_DCETHREADS */

  return result;
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::cond_init (cv, type, arg),
                                       ace_result_),
                     int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_signal (ACE_cond_t *cv)
{
// ACE_TRACE ("ACE_OS::cond_signal");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (::pthread_cond_signal (cv), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_cond_signal (cv),ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::cond_signal (cv), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_broadcast (ACE_cond_t *cv)
{
// ACE_TRACE ("ACE_OS::cond_broadcast");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (::pthread_cond_broadcast (cv), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_cond_broadcast (cv),
                                       ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::cond_broadcast (cv),
                                       ace_result_),
                     int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_wait (ACE_cond_t *cv,
                   ACE_mutex_t *external_mutex)
{
  // ACE_TRACE ("ACE_OS::cond_wait");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL_RETURN (::pthread_cond_wait (cv, external_mutex), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_cond_wait (cv, external_mutex), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::cond_wait (cv, external_mutex), ace_result_),
                     int, -1);
#endif /* ACE_HAS_DCETHREADS || ACE_HAS_PTHREADS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (external_mutex);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_timedwait (ACE_cond_t *cv,
                        ACE_mutex_t *external_mutex,
                        ACE_Time_Value *timeout)
{
  // ACE_TRACE ("ACE_OS::cond_timedwait");
#if defined (ACE_HAS_THREADS)
  int result;
  timespec_t ts;

  if (timeout != 0)
    ts = *timeout; // Calls ACE_Time_Value::operator timespec_t().

#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS) || defined (ACE_HAS_FSU_PTHREADS)
  ACE_OSCALL (timeout == 0
              ? ::pthread_cond_wait (cv, external_mutex)
              : ::pthread_cond_timedwait (cv, external_mutex,
                                          (ACE_TIMESPEC_PTR) &ts),
              int, -1, result);
#  else
  ACE_OSCALL (ACE_ADAPT_RETVAL (timeout == 0
                                ? ::pthread_cond_wait (cv, external_mutex)
                                : ::pthread_cond_timedwait (cv, external_mutex,
                                                            (ACE_TIMESPEC_PTR) &ts),
                                result),
              int, -1, result);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
  // We need to adjust this to make the POSIX and Solaris return
  // values consistent.  EAGAIN is from DCE DRAFT4 (HP-UX 10.20 and
  // down).
  if (result == -1 && (errno == ETIMEDOUT || errno == EAGAIN))
    errno = ETIME;

#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL (ACE_ADAPT_RETVAL (timeout == 0
                                ? ::cond_wait (cv, external_mutex)
                                : ::cond_timedwait (cv,
                                                    external_mutex,
                                                    (timestruc_t*)&ts),
                                result),
              int, -1, result);
#endif /* ACE_HAS_STHREADS */
  if (timeout != 0)
    timeout->set (ts); // Update the time value before returning.

  return result;
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (external_mutex);
  ACE_UNUSED_ARG (timeout);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}
#endif /* !ACE_LACKS_COND_T */

ACE_INLINE int
ACE_OS::sema_destroy (ACE_sema_t *s)
{
  // ACE_TRACE ("ACE_OS::sema_destroy");
#if defined (ACE_HAS_POSIX_SEM)
  int result;
#if !defined (ACE_LACKS_NAMED_POSIX_SEM)
  if (s->name_)
    {
      ACE_OS::free ((void *) s->name_);
      ACE_OSCALL (ACE_ADAPT_RETVAL (::sem_unlink (s->name_), result), int, -1, result);
      ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sem_close (s->sema_), ace_result_), int, -1);
    }
  else
#endif /* ACE_LACKS_NAMED_POSIX_SEM */
    {
      ACE_OSCALL (ACE_ADAPT_RETVAL (::sem_destroy (s->sema_), result), int, -1, result);
      delete s->sema_;
      s->sema_ = 0;
      return result;
    }
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sema_destroy (s), ace_result_), int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  int r1 = ACE_OS::mutex_destroy (&s->lock_);
  int r2 = ACE_OS::cond_destroy (&s->count_nonzero_);
  return r1 != 0 || r2 != 0 ? -1 : 0;
#elif defined (ACE_HAS_WTHREADS)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::CloseHandle (*s), ace_result_), int, -1);
#elif defined (VXWORKS)
  int result;
  ACE_OSCALL (ACE_ADAPT_RETVAL (::semDelete (s->sema_), result), int, -1, result);
  s->sema_ = 0;
  return result;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

ACE_INLINE int
ACE_OS::sema_init (ACE_sema_t *s, u_int count, int type,
                   LPCTSTR name, void *arg, int max,
                   LPSECURITY_ATTRIBUTES sa)
{
  // ACE_TRACE ("ACE_OS::sema_init");
#if defined (ACE_HAS_POSIX_SEM)
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (max);
  ACE_UNUSED_ARG (sa);

#if !defined (ACE_LACKS_NAMED_POSIX_SEM)
  if (name)
    {
      s->name_ = ACE_OS::strdup (name);

      s->sema_ = ::sem_open (s->name_, O_CREAT,
                             ACE_DEFAULT_FILE_PERMS, count);
      return (int) s->sema_ == -1 ? -1 : 0;
    }
  else
#endif /*ACE_LACKS_NAMED_POSIX_SEM */
    {
      s->name_ = 0;
      ACE_NEW_RETURN (s->sema_, sem_t, -1);
      ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sem_init (s->sema_, type != USYNC_THREAD, count), ace_result_),
                         int, -1);
    }
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (max);
  ACE_UNUSED_ARG (sa);
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sema_init (s, count, type, arg), ace_result_),
                     int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (max);
  ACE_UNUSED_ARG (sa);
  int result = -1;

  if (ACE_OS::mutex_init (&s->lock_, type, name, arg) == 0
      && ACE_OS::cond_init (&s->count_nonzero_, type, name, arg) == 0
      && ACE_OS::mutex_lock (&s->lock_) == 0)
    {
      s->count_ = count;
      s->waiters_ = 0;

      if (ACE_OS::mutex_unlock (&s->lock_) == 0)
        result = 0;
    }

  if (result == -1)
    {
      ACE_OS::mutex_destroy (&s->lock_);
      ACE_OS::cond_destroy (&s->count_nonzero_);
    }
  return result;
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (arg);
  // Create the semaphore with its value initialized to <count> and
  // its maximum value initialized to <max>.
  *s = ::CreateSemaphore (sa, count, max, name);

  if (*s == 0)
    ACE_FAIL_RETURN (-1);
  /* NOTREACHED */
  else
    return 0;
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (max);
  ACE_UNUSED_ARG (sa);
  s->name_ = 0;
  s->sema_ = ::semCCreate (SEM_Q_FIFO, count);

  return s->sema_ ? 0 : -1;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_UNUSED_ARG (count);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (max);
  ACE_UNUSED_ARG (sa);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

ACE_INLINE int
ACE_OS::sema_post (ACE_sema_t *s)
{
  // ACE_TRACE ("ACE_OS::sema_post");
#if defined (ACE_HAS_POSIX_SEM)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sem_post (s->sema_), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sema_post (s), ace_result_), int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  int result = -1;

  if (ACE_OS::mutex_lock (&s->lock_) == 0)
    {
      // Always allow a waiter to continue if there is one.
      if (s->waiters_ > 0)
        result = ACE_OS::cond_signal (&s->count_nonzero_);
      else
        result = 0;

      s->count_++;
      ACE_OS::mutex_unlock (&s->lock_);
    }
  return result;
#elif defined (ACE_HAS_WTHREADS)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::ReleaseSemaphore (*s, 1, 0),
                                       ace_result_),
                     int, -1);
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::semGive (s->sema_), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

ACE_INLINE int
ACE_OS::sema_post (ACE_sema_t *s, size_t release_count)
{
#if defined (ACE_WIN32)
  // Win32 supports this natively.
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::ReleaseSemaphore (*s, release_count, 0),
                                       ace_result_), int, -1);
#else
  // On POSIX platforms we need to emulate this ourselves.
  for (size_t i = 0; i < release_count; i++)
    if (ACE_OS::sema_post (s) == -1)
      return -1;

  return 0;
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::sema_trywait (ACE_sema_t *s)
{
  // ACE_TRACE ("ACE_OS::sema_trywait");
#if defined (ACE_HAS_POSIX_SEM)
  // POSIX semaphores set errno to EAGAIN if trywait fails
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sem_trywait (s->sema_), ace_result_),
                     int, -1);
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  // STHREADS semaphores set errno to EBUSY if trywait fails.
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sema_trywait (s),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)

  int result = -1;

  if (ACE_OS::mutex_lock (&s->lock_) == 0)
    {
      if (s->count_ > 0)
        {
          --s->count_;
          result = 0;
        }
      else
        errno = EBUSY;

      ACE_OS::mutex_unlock (&s->lock_);
    }
  return result;
#elif defined (ACE_HAS_WTHREADS)
  int result = ::WaitForSingleObject (*s, 0);

  if (result == WAIT_OBJECT_0)
    return 0;
  else
    {
      errno = result == WAIT_TIMEOUT ? EBUSY : ::GetLastError ();
      // This is a hack, we need to find an appropriate mapping...
      return -1;
    }

#elif defined (VXWORKS)
  if (::semTake (s->sema_, NO_WAIT) == ERROR)
    if (errno == S_objLib_OBJ_TIMEOUT)
      {
        // couldn't get the semaphore
        errno = EBUSY;
        return -1;
      }
    else
      // error
      return -1;
  else
    // got the semaphore
    return 0;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

ACE_INLINE int
ACE_OS::sema_wait (ACE_sema_t *s)
{
  // ACE_TRACE ("ACE_OS::sema_wait");
#if defined (ACE_HAS_POSIX_SEM)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sem_wait (s->sema_), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sema_wait (s), ace_result_), int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  int result = 0;

  ACE_PTHREAD_CLEANUP_PUSH (&s->lock_);

  if (ACE_OS::mutex_lock (&s->lock_) != 0)
    result = -1;
  else
    {
      // Keep track of the number of waiters so that we can signal
      // them properly in <ACE_OS::sema_post>.
      s->waiters_++;

      // Wait until the semaphore count is > 0.
      while (s->count_ == 0)
        if (ACE_OS::cond_wait (&s->count_nonzero_,
                               &s->lock_) == -1)
          {
            result = -2; // -2 means that we need to release the mutex.
            break;
          }

      --s->waiters_;
    }

  if (result == 0)
    --s->count_;

  if (result != -1)
    ACE_OS::mutex_unlock (&s->lock_);
  ACE_PTHREAD_CLEANUP_POP (1);
  return result < 0 ? -1 : result;

#elif defined (ACE_HAS_WTHREADS)
  switch (::WaitForSingleObject (*s, INFINITE))
    {
    case WAIT_OBJECT_0:
      return 0;
    default:
      // This is a hack, we need to find an appropriate mapping...
      errno = ::GetLastError ();
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::semTake (s->sema_, WAIT_FOREVER), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

ACE_INLINE int
ACE_OS::sema_wait (ACE_sema_t *s, ACE_Time_Value &tv)
{
  // ACE_TRACE ("ACE_OS::sema_wait");
#if defined (ACE_HAS_POSIX_SEM)
  ACE_UNUSED_ARG (s);
  ACE_UNUSED_ARG (tv);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (s);
  ACE_UNUSED_ARG (tv);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  int result = 0;
  int error = 0;

  ACE_PTHREAD_CLEANUP_PUSH (&s->lock_);

  if (ACE_OS::mutex_lock (&s->lock_) != 0)
    result = -1;
  else
    {
      // Keep track of the number of waiters so that we can signal
      // them properly in <ACE_OS::sema_post>.
      s->waiters_++;

      // Wait until the semaphore count is > 0 or until we time out.
      while (s->count_ == 0)
        if (ACE_OS::cond_timedwait (&s->count_nonzero_,
                                    &s->lock_,
                                    &tv) == -1)
          {
            error = errno;
            result = -2; // -2 means that we need to release the mutex.
            break;
          }

      --s->waiters_;
    }

  if (result == 0)
    --s->count_;

  if (result != -1)
    ACE_OS::mutex_unlock (&s->lock_);
  ACE_PTHREAD_CLEANUP_POP (1);
  errno = error;
  return result < 0 ? -1 : result;
#elif defined (ACE_HAS_WTHREADS)
  switch (::WaitForSingleObject (*s, tv.sec () * 1000 + tv.usec () / 1000))
    {
    case WAIT_OBJECT_0:
      return 0;
    case WAIT_TIMEOUT:
      errno = ETIME;
      return -1;
    default:
      // This is a hack, we need to find an appropriate mapping...
      errno = ::GetLastError ();
      return -1;
    }
  /* NOTREACHED */
#elif defined (VXWORKS)
  int ticks_per_sec = ::sysClkRateGet ();
  int ticks = tv.sec() * ticks_per_sec +
              tv.usec () * ticks_per_sec / ACE_ONE_SECOND_IN_USECS;
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::semTake (s->sema_, ticks), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (s);
  ACE_UNUSED_ARG (tv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POSIX_SEM */
}

#if defined (ACE_LACKS_COND_T)

// NOTE: The ACE_OS::cond_* functions for some non-Unix platforms are
// defined here because they need the ACE_OS::sema_* functions above.
// However, some Unix platforms define the ACE_OS::sema_* functions
// using the ACE_OS::cond_* functions.  So, they appear before the
// ACE_OS::sema_* functions above.
ACE_INLINE int
ACE_OS::cond_destroy (ACE_cond_t *cv)
{
  // ACE_TRACE ("ACE_OS::cond_destroy");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_WTHREADS)
  ACE_OS::event_destroy (&cv->waiters_done_);
#elif defined (VXWORKS)
  ACE_OS::sema_destroy (&cv->waiters_done_);
#endif /* VXWORKS */
  ACE_OS::thread_mutex_destroy (&cv->waiters_lock_);
  return ACE_OS::sema_destroy (&cv->sema_);
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_init (ACE_cond_t *cv, int type, LPCTSTR name, void *arg)
{
// ACE_TRACE ("ACE_OS::cond_init");
#if defined (ACE_HAS_THREADS)
  cv->waiters_ = 0;
  cv->was_broadcast_ = 0;

  int result = 0;
  if (ACE_OS::sema_init (&cv->sema_, 0, type, name, arg) == -1)
    result = -1;
  else if (ACE_OS::thread_mutex_init (&cv->waiters_lock_) == -1)
    result = -1;
#if defined (VXWORKS)
  else if (ACE_OS::sema_init (&cv->waiters_done_, 0, type) == -1)
#else
  else if (ACE_OS::event_init (&cv->waiters_done_) == -1)
#endif /* VXWORKS */
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_signal (ACE_cond_t *cv)
{
// ACE_TRACE ("ACE_OS::cond_signal");
#if defined (ACE_HAS_THREADS)
  // If there aren't any waiters, then this is a no-op.  Note that
  // this function *must* be called with the <external_mutex> held
  // since other wise there is a race condition that can lead to the
  // lost wakeup bug...
  if (cv->waiters_ > 0)
    return ACE_OS::sema_post (&cv->sema_);
  else
    return 0; // No-op
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_broadcast (ACE_cond_t *cv)
{
// ACE_TRACE ("ACE_OS::cond_broadcast");
#if defined (ACE_HAS_THREADS)
  // The <external_mutex> must be locked before this call is made.

  if (cv->waiters_ == 0)
    return 0; // No-op
  else // We are broadcasting, even if there is just one waiter...
    {
      int result = 0;
      // Record the fact that we are broadcasting.  This helps the
      // cond_wait() method know how to optimize itself.
      cv->was_broadcast_ = 1;

      // Wake up all the waiters.

      if (ACE_OS::sema_post (&cv->sema_, cv->waiters_) == -1)
        result = -1;

      // Wait for all the awakened threads to acquire their part of the
      // counting semaphore.
#if defined (VXWORKS)
      else if (ACE_OS::sema_wait (&cv->waiters_done_) == -1)
#else
      else if (ACE_OS::event_wait (&cv->waiters_done_) == -1)
#endif /* VXWORKS */
        result = -1;

      cv->was_broadcast_ = 0;
      return result;
    }
#else
  ACE_UNUSED_ARG (cv);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_wait (ACE_cond_t *cv,
                   ACE_mutex_t *external_mutex)
{
  // ACE_TRACE ("ACE_OS::cond_wait");
#if defined (ACE_HAS_THREADS)
  // It's ok to increment this because the <external_mutex> must be
  // locked by the caller.
  cv->waiters_++;

  int result = 0;
  int error = 0;

#if defined (ACE_HAS_SIGNAL_OBJECT_AND_WAIT)
  if (external_mutex->type_ == USYNC_PROCESS)
    // This call will automatically release the mutex and wait on the semaphore.
    ACE_WIN32CALL (ACE_ADAPT_RETVAL (::SignalObjectAndWait (external_mutex->proc_mutex_,
                                                         cv->sema_, INFINITE, FALSE),
                                  result),
                int, -1, result);
  else
#endif /* ACE_HAS_SIGNAL_OBJECT_AND_WAIT */
    {
      // We keep the lock held just long enough to increment the count of
      // waiters by one.  Note that we can't keep it held across the call
      // to ACE_OS::sema_wait() since that will deadlock other calls to
      // ACE_OS::cond_signal().
      if (ACE_OS::mutex_unlock (external_mutex) != 0)
        return -1;

      // Wait to be awakened by a ACE_OS::cond_signal() or
      // ACE_OS::cond_broadcast().
      result = ACE_OS::sema_wait (&cv->sema_);
    }

  // Reacquire lock to avoid race conditions.
  ACE_OS::thread_mutex_lock (&cv->waiters_lock_);
  cv->waiters_--;

  int last_waiter = cv->was_broadcast_ && cv->waiters_ == 0;

  ACE_OS::thread_mutex_unlock (&cv->waiters_lock_);

#if defined (ACE_HAS_SIGNAL_OBJECT_AND_WAIT)
  if (external_mutex->type_ == USYNC_PROCESS)
    {
      if (last_waiter)

        // This call atomically signals the waiters_done_ event and waits
        // until it can acquire the mutex.  This is important to prevent
        // unfairness.
        ACE_WIN32CALL (ACE_ADAPT_RETVAL (::SignalObjectAndWait (cv->waiters_done_,
                                                             external_mutex->proc_mutex_,
                                                             INFINITE, FALSE),
                                      result),
                    int, -1, result);
      else
        // We must always regain the external mutex, even when errors
        // occur because that's the guarantee that we give to our
        // callers.
        ACE_OS::mutex_lock (external_mutex);
    }
  else
#endif /* ACE_HAS_SIGNAL_OBJECT_AND_WAIT */
  if (result != -1)
    {
      // If we're the last waiter thread during this particular
      // broadcast then let all the other threads proceed.
      if (last_waiter)
#if defined (VXWORKS)
        ACE_OS::sema_post (&cv->waiters_done_);
#else
        ACE_OS::event_signal (&cv->waiters_done_);
#endif /* VXWORKS */
    }

  // We must always regain the external mutex, even when errors
  // occur because that's the guarantee that we give to our
  // callers.
  ACE_OS::mutex_lock (external_mutex);

  // Reset errno in case mutex_lock() also fails...
  errno = error;
  return result;
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (external_mutex);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_timedwait (ACE_cond_t *cv,
                        ACE_mutex_t *external_mutex,
                        ACE_Time_Value *timeout)
{
  // ACE_TRACE ("ACE_OS::cond_timedwait");
#if defined (ACE_HAS_THREADS)
  // Handle the easy case first.
  if (timeout == 0)
    return ACE_OS::cond_wait (cv, external_mutex);
#if defined (ACE_HAS_WTHREADS) || defined (VXWORKS)

  // It's ok to increment this because the <external_mutex> must be
  // locked by the caller.
  cv->waiters_++;

  int result = 0;
  int error = 0;
  int msec_timeout;

  if (timeout->sec () == 0 && timeout->usec () == 0)
    msec_timeout = 0; // Do a "poll."
  else
    {
      // Note that we must convert between absolute time (which is
      // passed as a parameter) and relative time (which is what
      // WaitForSingleObjects() expects).
      ACE_Time_Value relative_time (*timeout - ACE_OS::gettimeofday ());

      // Watchout for situations where a context switch has caused the
      // current time to be > the timeout.
      if (relative_time < ACE_Time_Value::zero)
        msec_timeout = 0;
      else
        msec_timeout = relative_time.msec ();
    }

#if defined (ACE_HAS_SIGNAL_OBJECT_AND_WAIT)
  if (external_mutex->type_ == USYNC_PROCESS)
    // This call will automatically release the mutex and wait on the semaphore.
    result = ::SignalObjectAndWait (external_mutex->proc_mutex_,
                                    cv->sema_, msec_timeout, FALSE);
  else
#endif /* ACE_HAS_SIGNAL_OBJECT_AND_WAIT */
    {
      // We keep the lock held just long enough to increment the count
      // of waiters by one.  Note that we can't keep it held across
      // the call to WaitForSingleObject since that will deadlock
      // other calls to ACE_OS::cond_signal().
      if (ACE_OS::mutex_unlock (external_mutex) != 0)
        return -1;

      // Wait to be awakened by a ACE_OS::signal() or
      // ACE_OS::broadcast().
#if defined (ACE_WIN32)
      result = ::WaitForSingleObject (cv->sema_, msec_timeout);
#else
      // Inline the call to ACE_OS::sema_wait () because it takes an
      // ACE_Time_Value argument.  Avoid the cost of that conversion . . .
      int ticks_per_sec = ::sysClkRateGet ();
      int ticks = msec_timeout * ticks_per_sec / ACE_ONE_SECOND_IN_MSECS;
      result = ::semTake (cv->sema_.sema_, ticks);
#endif /* ACE_WIN32 */
    }

  // Reacquire lock to avoid race conditions.
  ACE_OS::thread_mutex_lock (&cv->waiters_lock_);
  cv->waiters_--;

  int last_waiter = cv->was_broadcast_ && cv->waiters_ == 0;

  ACE_OS::thread_mutex_unlock (&cv->waiters_lock_);

#if defined (ACE_WIN32)
  if (result != WAIT_OBJECT_0)
    {
      switch (result)
        {
        case WAIT_TIMEOUT:
          error = ETIME;
          break;
        default:
          error = ::GetLastError ();
          break;
        }
      result = -1;
    }
#else /* VXWORKS */
  if (result == ERROR)
    {
      switch (errno)
        {
        case S_objLib_OBJ_TIMEOUT:
          error = ETIME;
          break;
        default:
          error = errno;
          break;
        }
      result = -1;
    }
#endif /* VXWORKS */
#if defined (ACE_HAS_SIGNAL_OBJECT_AND_WAIT)
  else if (external_mutex->type_ == USYNC_PROCESS)
    {
      if (last_waiter)
        // This call atomically signals the waiters_done_ event and waits
        // until it can acquire the mutex.  This is important to prevent
        // unfairness.
        ACE_WIN32CALL (ACE_ADAPT_RETVAL (::SignalObjectAndWait (cv->waiters_done_,
                                                             external_mutex->proc_mutex_,
                                                             INFINITE, FALSE),
                                      result),
                    int, -1, result);
      else
        // We must always regain the external mutex, even when errors
        // occur because that's the guarantee that we give to our
        // callers.
        ACE_OS::mutex_lock (external_mutex);
    }
#endif /* ACE_HAS_SIGNAL_OBJECT_AND_WAIT */
  else if (last_waiter)
    // Release the signaler/broadcaster if we're the last waiter.
#if defined (ACE_WIN32)
    ACE_OS::event_signal (&cv->waiters_done_);
#else
    ACE_OS::sema_post (&cv->waiters_done_);
#endif /* ACE_WIN32 */

  // We must always regain the external mutex, even when errors occur
  // because that's the guarantee that we give to our callers.
  ACE_OS::mutex_lock (external_mutex);

  errno = error;
  return result;
#endif /* ACE_HAS_WTHREADS || ACE_HAS_VXWORKS */
#else
  ACE_UNUSED_ARG (cv);
  ACE_UNUSED_ARG (external_mutex);
  ACE_UNUSED_ARG (timeout);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

#if defined (ACE_HAS_WTHREADS)
ACE_INLINE int
ACE_OS::cond_timedwait (ACE_cond_t *cv,
                        ACE_thread_mutex_t *external_mutex,
                        ACE_Time_Value *timeout)
{
  // ACE_TRACE ("ACE_OS::cond_timedwait");
#if defined (ACE_HAS_THREADS)
  // Handle the easy case first.
  if (timeout == 0)
    return ACE_OS::cond_wait (cv, external_mutex);

  // It's ok to increment this because the <external_mutex> must be
  // locked by the caller.
  cv->waiters_++;

  int result = 0;
  int error = 0;
  int msec_timeout;

  if (timeout->sec () == 0 && timeout->usec () == 0)
    msec_timeout = 0; // Do a "poll."
  else
    {
      // Note that we must convert between absolute time (which is
      // passed as a parameter) and relative time (which is what
      // WaitForSingleObjects() expects).
      ACE_Time_Value relative_time (*timeout - ACE_OS::gettimeofday ());

      // Watchout for situations where a context switch has caused the
      // current time to be > the timeout.
      if (relative_time < ACE_Time_Value::zero)
        msec_timeout = 0;
      else
        msec_timeout = relative_time.msec ();
    }

  // We keep the lock held just long enough to increment the count of
  // waiters by one.  Note that we can't keep it held across the call
  // to WaitForSingleObject since that will deadlock other calls to
  // ACE_OS::cond_signal().
  if (ACE_OS::thread_mutex_unlock (external_mutex) != 0)
    return -1;

  // Wait to be awakened by a ACE_OS::signal() or ACE_OS::broadcast().
  result = ::WaitForSingleObject (cv->sema_, msec_timeout);

  // Reacquire lock to avoid race conditions.
  ACE_OS::thread_mutex_lock (&cv->waiters_lock_);
  cv->waiters_--;

  int last_waiter = cv->was_broadcast_ && cv->waiters_ == 0;
  ACE_OS::thread_mutex_unlock (&cv->waiters_lock_);

  if (result != WAIT_OBJECT_0)
    {
      switch (result)
        {
        case WAIT_TIMEOUT:
          error = ETIME;
          break;
        default:
          error = ::GetLastError ();
          break;
        }
      result = -1;
    }
  else if (last_waiter)
    // Release the signaler/broadcaster if we're the last waiter.
    ACE_OS::event_signal (&cv->waiters_done_);

  // We must always regain the external mutex, even when errors occur
  // because that's the guarantee that we give to our callers.
  ACE_OS::thread_mutex_lock (external_mutex);
  errno = error;
  return result;
#else
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::cond_wait (ACE_cond_t *cv,
                   ACE_thread_mutex_t *external_mutex)
{
  // ACE_TRACE ("ACE_OS::cond_wait");
#if defined (ACE_HAS_THREADS)
  // It's ok to increment this because the <external_mutex> must be
  // locked by the caller.
  cv->waiters_++;

  int result = 0;
  int error = 0;

  // We keep the lock held just long enough to increment the count of
  // waiters by one.  Note that we can't keep it held across the call
  // to ACE_OS::sema_wait() since that will deadlock other calls to
  // ACE_OS::cond_signal().
  if (ACE_OS::thread_mutex_unlock (external_mutex) != 0)
    return -1;

  // Wait to be awakened by a ACE_OS::cond_signal() or
  // ACE_OS::cond_broadcast().
  result = ::WaitForSingleObject (cv->sema_, INFINITE);

  // Reacquire lock to avoid race conditions.
  ACE_OS::thread_mutex_lock (&cv->waiters_lock_);
  cv->waiters_--;

  int last_waiter = cv->was_broadcast_ && cv->waiters_ == 0;
  ACE_OS::thread_mutex_unlock (&cv->waiters_lock_);

  if (result != WAIT_OBJECT_0)
    {
      switch (result)
        {
        case WAIT_TIMEOUT:
          error = ETIME;
          break;
        default:
          error = ::GetLastError ();
          break;
        }
    }
  else if (last_waiter)
    // Release the signaler/broadcaster if we're the last waiter.
    ACE_OS::event_signal (&cv->waiters_done_);

  // We must always regain the external mutex, even when errors
  // occur because that's the guarantee that we give to our
  // callers.
  ACE_OS::thread_mutex_lock (external_mutex);

  // Reset errno in case mutex_lock() also fails...
  errno = error;
  return result;
#else
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}
#endif /* ACE_HAS_WTHREADS */
#endif /* ACE_LACKS_COND_T */

ACE_INLINE int
ACE_OS::rw_rdlock (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rw_rdlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || !defined (ACE_LACKS_RWLOCK_T)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rw_rdlock (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_PTHREAD_CLEANUP_PUSH (&rw->lock_);
#endif /* ACE_HAS_DCETHREADS */
  int result = 0;
  if (ACE_OS::mutex_lock (&rw->lock_) == -1)
    result = -1; // -1 means didn't get the mutex.
  else
    {
      // Give preference to writers who are waiting.
      while (rw->ref_count_ < 0 || rw->num_waiting_writers_ > 0)
        {
          rw->num_waiting_readers_++;
          if (ACE_OS::cond_wait (&rw->waiting_readers_, &rw->lock_) == -1)
            {
              result = -2; // -2 means that we need to release the mutex.
              break;
            }
          rw->num_waiting_readers_--;
        }
    }
  if (result == 0)
    rw->ref_count_++;
  if (result != -1)
    ACE_OS::mutex_unlock (&rw->lock_);
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_PTHREAD_CLEANUP_POP (0);
#endif /* defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS) */
  return 0;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::rw_tryrdlock (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rw_tryrdlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || !defined (ACE_LACKS_RWLOCK_T)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rw_tryrdlock (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
  int result = -1;

  if (ACE_OS::mutex_lock (&rw->lock_) != -1)
    {
      int error = 0;

      if (rw->ref_count_ == -1 || rw->num_waiting_writers_ > 0)
        {
          error = EBUSY;
          result = -1;
        }
      else
        {
          rw->ref_count_++;
          result = 0;
        }

      ACE_OS::mutex_unlock (&rw->lock_);
      errno = error;
    }
  return result;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::rw_trywrlock (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rw_trywrlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || !defined (ACE_LACKS_RWLOCK_T)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rw_trywrlock (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
  int result = -1;

  if (ACE_OS::mutex_lock (&rw->lock_) != -1)
    {
      int error = 0;

      if (rw->ref_count_ != 0)
        {
          error = EBUSY;
          result = -1;
        }
      else
        {
          rw->ref_count_ = -1;
          result = 0;
        }

      ACE_OS::mutex_unlock (&rw->lock_);
      errno = error;
    }
  return result;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::rw_unlock (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rw_unlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || !defined (ACE_LACKS_RWLOCK_T)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rw_unlock (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
  if (ACE_OS::mutex_lock (&rw->lock_) == -1)
    return -1;

  if (rw->ref_count_ > 0) // Releasing a reader.
    rw->ref_count_--;
  else if (rw->ref_count_ == -1) // Releasing a writer.
    rw->ref_count_ = 0;
  else
    assert (!"count should not be 0!\n");

  int result;
  int error = 0;

  // Give preference to writers over readers...
  if (rw->num_waiting_writers_ > 0)
    {
      result = ACE_OS::cond_signal (&rw->waiting_writers_);
      error = errno;
    }
  else if (rw->num_waiting_readers_ > 0)
    {
      result = ACE_OS::cond_broadcast (&rw->waiting_readers_);
      error = errno;
    }
  else
    result = 0;

  ACE_OS::mutex_unlock (&rw->lock_);
  errno = error;
  return result;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::rw_wrlock (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rw_wrlock");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS) || !defined (ACE_LACKS_RWLOCK_T)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rw_wrlock (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_PTHREAD_CLEANUP_PUSH (&rw->lock_);
#endif /* defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS) */
  int result = 0;
  if (ACE_OS::mutex_lock (&rw->lock_) == -1)
    result = -1; // -1 means didn't get the mutex.
  else
    {
      while (rw->ref_count_ != 0)
        {
          rw->num_waiting_writers_++;

          if (ACE_OS::cond_wait (&rw->waiting_writers_, &rw->lock_) == -1)
            {
              result = -2; // -2 means we need to release the mutex.
              break;
            }

          rw->num_waiting_writers_--;
        }
    }
  if (result == 0)
    rw->ref_count_ = -1;
  if (result != -1)
    ACE_OS::mutex_unlock (&rw->lock_);
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_PTHREAD_CLEANUP_POP (0);
#endif /* defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS) */
  return 0;
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

#if defined (ACE_HAS_THREADS) && defined (ACE_HAS_STHREADS)
ACE_INLINE int
ACE_OS::rwlock_init (ACE_rwlock_t *rw,
                     int type,
                     LPCTSTR name,
                     void *arg)
{
  // ACE_TRACE ("ACE_OS::rwlock_init");
  type = type;
  name = name;
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rwlock_init (rw, type, arg), ace_result_), int, -1);
}
#endif /* ACE_HAS THREADS && ACE_HAS_STHREADS */

ACE_INLINE int
ACE_OS::rwlock_destroy (ACE_rwlock_t *rw)
{
  // ACE_TRACE ("ACE_OS::rwlock_destroy");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::rwlock_destroy (rw), ace_result_), int, -1);
#else /* NT, POSIX, and VxWorks don't support this natively. */
  ACE_OS::mutex_destroy (&rw->lock_);
  ACE_OS::cond_destroy (&rw->waiting_readers_);
  return ACE_OS::cond_destroy (&rw->waiting_writers_);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (rw);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::event_init (ACE_event_t *event,
                    int manual_reset,
                    int initial_state,
                    int type,
                    LPCTSTR name,
                    void *arg,
                    LPSECURITY_ATTRIBUTES sa)
{
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (arg);
  *event = ::CreateEvent (sa,
                          manual_reset,
                          initial_state,
                          name);
  if (*event == NULL)
    ACE_FAIL_RETURN (-1);
  else
    return 0;
#elif defined (ACE_HAS_THREADS)
  ACE_UNUSED_ARG (sa);
  event->manual_reset_ = manual_reset;
  event->is_signaled_ = initial_state;
  event->waiting_threads_ = 0;

  int result = ACE_OS::cond_init (&event->condition_,
                                  type,
                                  name,
                                  arg);
  if (result == 0)
    result = ACE_OS::mutex_init (&event->lock_,
                                 type,
                                 name,
                                 arg);
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_UNUSED_ARG (manual_reset);
  ACE_UNUSED_ARG (initial_state);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (arg);
  ACE_UNUSED_ARG (sa);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_destroy (ACE_event_t *event)
{
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::CloseHandle (*event), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
  int r1 = ACE_OS::mutex_destroy (&event->lock_);
  int r2 = ACE_OS::cond_destroy (&event->condition_);
  return r1 != 0 || r2 != 0 ? -1 : 0;
#else
  ACE_UNUSED_ARG (event);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_wait (ACE_event_t *event)
{
#if defined (ACE_WIN32)
  switch (::WaitForSingleObject (*event, INFINITE))
    {
    case WAIT_OBJECT_0:
      return 0;
    default:
      errno = ::GetLastError ();
      return -1;
    }
#elif defined (ACE_HAS_THREADS)
  int result = 0;
  int error = 0;

  // grab the lock first
  if (ACE_OS::mutex_lock (&event->lock_) == 0)
    {
      if (event->is_signaled_ == 1)
        // Event is currently signaled.
        {
          if (event->manual_reset_ == 0)
            // AUTO: reset state
            event->is_signaled_ = 0;
        }
      else
        // event is currently not signaled
        {
          event->waiting_threads_++;

          if (ACE_OS::cond_wait (&event->condition_,
                                 &event->lock_) != 0)
            {
              result = -1;
              error = errno;
            }
          event->waiting_threads_--;
        }

      // Now we can let go of the lock.
      ACE_OS::mutex_unlock (&event->lock_);

      if (result == -1)
        // Reset errno in case mutex_unlock() also fails...
        errno = error;
    }
  else
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_timedwait (ACE_event_t *event,
                         ACE_Time_Value *timeout)
{
#if defined (ACE_WIN32)
  DWORD result;

  if (timeout == 0)
    // Wait forever
    result = ::WaitForSingleObject (*event, INFINITE);
  else if (timeout->sec () == 0 && timeout->usec () == 0)
    // Do a "poll".
    result = ::WaitForSingleObject (*event, 0);
  else
    {
      // Wait for upto <relative_time> number of milliseconds.  Note
      // that we must convert between absolute time (which is passed
      // as a parameter) and relative time (which is what
      // WaitForSingleObjects() expects).
      ACE_Time_Value relative_time (*timeout - ACE_OS::gettimeofday ());
      result = ::WaitForSingleObject (*event, relative_time.msec ());
    }

  switch (result)
    {
    case WAIT_OBJECT_0:
      return 0;
    default:
      // This is a hack, we need to find an appropriate mapping...
      errno = ::GetLastError ();
      return -1;
    }
#elif defined (ACE_HAS_THREADS)
  int result = 0;
  int error = 0;

  // grab the lock first
  if (ACE_OS::mutex_lock (&event->lock_) == 0)
    {
      if (event->is_signaled_ == 1)
        // event is currently signaled
        {
          if (event->manual_reset_ == 0)
            // AUTO: reset state
            event->is_signaled_ = 0;
        }
      else
        // event is currently not signaled
        {
          event->waiting_threads_++;

          if (ACE_OS::cond_timedwait (&event->condition_,
                                      &event->lock_,
                                      timeout) != 0)
            {
              result = -1;
              error = errno;
            }
          event->waiting_threads_--;
        }

      // Now we can let go of the lock.
      ACE_OS::mutex_unlock (&event->lock_);

      if (result == -1)
        // Reset errno in case mutex_unlock() also fails...
        errno = error;
    }
  else
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_UNUSED_ARG (timeout);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_signal (ACE_event_t *event)
{
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::SetEvent (*event), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
  int result = 0;
  int error = 0;

  // grab the lock first
  if (ACE_OS::mutex_lock (&event->lock_) == 0)
    {
      // Manual-reset event.
      if (event->manual_reset_ == 1)
        {
          // signal event
          event->is_signaled_ = 1;
          // wakeup all
          if (ACE_OS::cond_broadcast (&event->condition_) != 0)
            {
              result = -1;
              error = errno;
            }
        }
      // Auto-reset event
      else
        {
          if (event->waiting_threads_ == 0)
            // No waiters: signal event.
            event->is_signaled_ = 1;

          // Waiters: wakeup one waiter.
          else if (ACE_OS::cond_signal (&event->condition_) != 0)
            {
              result = -1;
              error = errno;
            }
        }

      // Now we can let go of the lock.
      ACE_OS::mutex_unlock (&event->lock_);

      if (result == -1)
        // Reset errno in case mutex_unlock() also fails...
        errno = error;
    }
  else
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_pulse (ACE_event_t *event)
{
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::PulseEvent (*event), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
  int result = 0;
  int error = 0;

  // grab the lock first
  if (ACE_OS::mutex_lock (&event->lock_) == 0)
    {
      // Manual-reset event.
      if (event->manual_reset_ == 1)
        {
          // Wakeup all waiters.
          if (ACE_OS::cond_broadcast (&event->condition_) != 0)
            {
              result = -1;
              error = errno;
            }
        }
      // Auto-reset event: wakeup one waiter.
      else if (ACE_OS::cond_signal (&event->condition_) != 0)
        {
          result = -1;
          error = errno;
        }

      // Reset event.
      event->is_signaled_ = 0;

      // Now we can let go of the lock.
      ACE_OS::mutex_unlock (&event->lock_);

      if (result == -1)
        // Reset errno in case mutex_unlock() also fails...
        errno = error;
    }
  else
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::event_reset (ACE_event_t *event)
{
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::ResetEvent (*event), ace_result_), int, -1);
#elif defined (ACE_HAS_THREADS)
  int result = 0;

  // Grab the lock first.
  if (ACE_OS::mutex_lock (&event->lock_) == 0)
    {
      // Reset event.
      event->is_signaled_ = 0;

      // Now we can let go of the lock.
      ACE_OS::mutex_unlock (&event->lock_);
    }
  else
    result = -1;
  return result;
#else
  ACE_UNUSED_ARG (event);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

#if defined (ACE_WIN32)
#define ACE_SOCKCALL_RETURN(OP,TYPE,FAILVALUE) \
  do { TYPE ace_result_ = (TYPE) OP; \
      if ((ACE_SOCKET) ace_result_ == SOCKET_ERROR) { errno = ::WSAGetLastError (); return (TYPE) FAILVALUE; } else return ace_result_; \
  } while (0)
#else
#define ACE_SOCKCALL_RETURN(OP,TYPE,FAILVALUE) ACE_OSCALL_RETURN(OP,TYPE,FAILVALUE)
#endif /* ACE_WIN32 */

#if defined (ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
#if defined (ACE_MT_SAFE) && (ACE_MT_SAFE != 0)
#define ACE_NETDBCALL_RETURN(OP,TYPE,FAILVALUE,TARGET,SIZE) \
  do \
  { \
    if (ACE_OS::netdb_acquire ())  \
      return FAILVALUE; \
    else \
      { \
        TYPE ace_result_; \
        ACE_OSCALL(OP,TYPE,FAILVALUE,ace_result_); \
        if (ace_result_ != FAILVALUE) \
          ::memcpy (TARGET, ace_result_, SIZE); \
        ACE_OS::netdb_release (); \
        return ace_result_; \
      } \
  } while(0)
#else /* ! (ACE_MT_SAFE && ACE_MT_SAFE != 0) */
#define ACE_NETDBCALL_RETURN(OP,TYPE,FAILVALUE,TARGET,SIZE) \
  do \
  { \
        TYPE ace_result_; \
        ACE_OSCALL(OP,TYPE,FAILVALUE,ace_result_); \
        if (ace_result_ != FAILVALUE) \
          ::memcpy (TARGET, ace_result_, SIZE); \
        return ace_result_; \
  } while(0)
#endif /* ACE_MT_SAFE && ACE_MT_SAFE != 0 */
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */


ACE_INLINE ACE_HANDLE
ACE_OS::accept (ACE_HANDLE handle, struct sockaddr *addr,
                int *addrlen)
{
  // ACE_TRACE ("ACE_OS::accept");
  ACE_SOCKCALL_RETURN (::accept ((ACE_SOCKET) handle, addr, (ACE_SOCKET_LEN *) addrlen),
                       ACE_HANDLE, ACE_INVALID_HANDLE);
}

ACE_INLINE int
ACE_OS::bind (ACE_HANDLE handle, struct sockaddr *addr, int addrlen)
{
  // ACE_TRACE ("ACE_OS::bind");
  ACE_SOCKCALL_RETURN (::bind ((ACE_SOCKET) handle, addr, (ACE_SOCKET_LEN) addrlen), int, -1);
}

ACE_INLINE int
ACE_OS::connect (ACE_HANDLE handle, struct sockaddr *addr, int addrlen)
{
  // ACE_TRACE ("ACE_OS::connect");
  ACE_SOCKCALL_RETURN (::connect ((ACE_SOCKET) handle, addr, (ACE_SOCKET_LEN) addrlen), int, -1);
}

ACE_INLINE struct hostent *
ACE_OS::gethostbyaddr (const char *addr, int length, int type)
{
  // ACE_TRACE ("ACE_OS::gethostbyaddr");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (length);
  ACE_UNUSED_ARG (type);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::gethostbyaddr ((char *) addr, (ACE_SOCKET_LEN) length, type),
                       struct hostent *, 0);
#else
  ACE_SOCKCALL_RETURN (::gethostbyaddr (addr, (ACE_SOCKET_LEN) length, type),
                       struct hostent *, 0);
#endif /* ACE_HAS_NONCONST_GETBY */
}

// It would be really cool to add another version of select that would
// function like the one we're defending against below!
ACE_INLINE int
ACE_OS::select (int width,
                fd_set *rfds, fd_set *wfds, fd_set *efds,
                const ACE_Time_Value *timeout)
{
  // ACE_TRACE ("ACE_OS::select");
#if defined (ACE_HAS_NONCONST_SELECT_TIMEVAL)
  // We must defend against non-conformity!
  ACE_Time_Value copy;

  if (timeout != 0)
    {
      copy = *timeout;
      timeout = &copy;
    }
#endif /* ACE_HAS_NONCONST_SELECT_TIMEVAL */
  ACE_SOCKCALL_RETURN (::select (width,
                                 (ACE_FD_SET_TYPE *) rfds,
                                 (ACE_FD_SET_TYPE *) wfds,
                                 (ACE_FD_SET_TYPE *) efds,
                                 timeout == 0 ? 0 : (timeval *) *timeout) , int, -1);
}

ACE_INLINE int
ACE_OS::select (int width,
                fd_set *rfds, fd_set *wfds, fd_set *efds,
                const ACE_Time_Value &timeout)
{
  // ACE_TRACE ("ACE_OS::select");
#if defined (ACE_HAS_NONCONST_SELECT_TIMEVAL)
#define ___ACE_TIMEOUT copy
  ACE_Time_Value copy(timeout);
#else
#define ___ACE_TIMEOUT timeout
#endif /* ACE_HAS_NONCONST_SELECT_TIMEVAL */
  ACE_SOCKCALL_RETURN (::select (width,
                                 (ACE_FD_SET_TYPE *) rfds,
                                 (ACE_FD_SET_TYPE *) wfds,
                                 (ACE_FD_SET_TYPE *) efds,
                                 ___ACE_TIMEOUT) , int, -1);
#undef ___ACE_TIMEOUT
}

ACE_INLINE int
ACE_OS::recv (ACE_HANDLE handle, char *buf, int len, int flags)
{
  // ACE_TRACE ("ACE_OS::recv");
  ACE_SOCKCALL_RETURN (::recv ((ACE_SOCKET) handle, buf, len, flags), int, -1);
}

ACE_INLINE int
ACE_OS::recvfrom (ACE_HANDLE handle, char *buf, int len,
                  int flags, struct sockaddr *addr, int *addrlen)
{
  // ACE_TRACE ("ACE_OS::recvfrom");
  ACE_SOCKCALL_RETURN (::recvfrom ((ACE_SOCKET) handle, buf, (ACE_SOCKET_LEN) len, flags,
                                   addr, (ACE_SOCKET_LEN *) addrlen),
                       int, -1);
}

ACE_INLINE int
ACE_OS::send (ACE_HANDLE handle, const char *buf, int len, int flags)
{
  // ACE_TRACE ("ACE_OS::send");
#if defined (VXWORKS) || defined (HPUX)
  ACE_SOCKCALL_RETURN (::send ((ACE_SOCKET) handle, (char *) buf, len, flags), int, -1);
#else
  ACE_SOCKCALL_RETURN (::send ((ACE_SOCKET) handle, buf, len, flags), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::sendto (ACE_HANDLE handle, const char *buf, int len,
                int flags, const struct sockaddr *addr, int addrlen)
{
  // ACE_TRACE ("ACE_OS::sendto");
#if defined (VXWORKS)
  ACE_SOCKCALL_RETURN (::sendto ((ACE_SOCKET) handle, (char *) buf, len, flags,
                                 (struct sockaddr *) addr, addrlen), int, -1);
#else
  ACE_SOCKCALL_RETURN (::sendto ((ACE_SOCKET) handle, buf, len, flags,
                                 (struct sockaddr *) addr, addrlen), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE int
ACE_OS::getpeername (ACE_HANDLE handle, struct sockaddr *addr,
                     int *addrlen)
{
  // ACE_TRACE ("ACE_OS::getpeername");
  ACE_SOCKCALL_RETURN (::getpeername ((ACE_SOCKET) handle, addr, (ACE_SOCKET_LEN *) addrlen),
                       int, -1);
}

ACE_INLINE struct protoent *
ACE_OS::getprotobyname (const char *name)
{
#if defined (VXWORKS)
  ACE_UNUSED_ARG (name);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::getprotobyname ((char *) name),
                       struct protoent *, 0);
#else
  ACE_SOCKCALL_RETURN (::getprotobyname (name),
                       struct protoent *, 0);
#endif /* VXWORKS */
}

ACE_INLINE struct protoent *
ACE_OS::getprotobyname_r (const char *name,
                          struct protoent *result,
                          ACE_PROTOENT_DATA buffer)
{
#if defined (VXWORKS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (buffer);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE)
#if defined (AIX) || defined (DIGITAL_UNIX) || defined (HPUX_10)
  if (::getprotobyname_r (name, result, (struct protoent_data *) buffer) == 0)
    return result;
  else
    return 0;
#else
#if defined(ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
  ACE_UNUSED_ARG (result);
  ACE_NETDBCALL_RETURN (::getprotobyname (name),
                        struct protoent *, 0,
                        buffer, sizeof (ACE_PROTOENT_DATA));
#else
    ACE_SOCKCALL_RETURN (::getprotobyname_r (name, result, buffer, sizeof (ACE_PROTOENT_DATA)),
                       struct protoent *, 0);
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */
#endif /* defined (AIX) || defined (DIGITAL_UNIX) */
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::getprotobyname ((char *) name),
                       struct protoent *, 0);
#else
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (result);

  ACE_SOCKCALL_RETURN (::getprotobyname (name),
                       struct protoent *, 0);
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) !defined (UNIXWARE) */
}

ACE_INLINE struct protoent *
ACE_OS::getprotobynumber (int proto)
{
#if defined (VXWORKS)
  ACE_UNUSED_ARG (proto);
  ACE_NOTSUP_RETURN (0);
#else
  ACE_SOCKCALL_RETURN (::getprotobynumber (proto),
                       struct protoent *, 0);
#endif /* VXWORKS */
}

ACE_INLINE struct protoent *
ACE_OS::getprotobynumber_r (int proto,
                            struct protoent *result,
                            ACE_PROTOENT_DATA buffer)
{
#if defined (VXWORKS)
  ACE_UNUSED_ARG (proto);
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (buffer);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE)
#if defined (AIX) || defined (DIGITAL_UNIX) || defined (HPUX_10)
  if (::getprotobynumber_r (proto, result, (struct protoent_data *) buffer) == 0)
    return result;
  else
    return 0;
#else
#if defined(ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
  ACE_UNUSED_ARG (result);
  ACE_NETDBCALL_RETURN (::getprotobynumber (proto),
                        struct protoent *, 0,
                        buffer, sizeof (ACE_PROTOENT_DATA));
#else
  ACE_SOCKCALL_RETURN (::getprotobynumber_r (proto, result, buffer, sizeof (ACE_PROTOENT_DATA)),
                       struct protoent *, 0);
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */
#endif /* defined (AIX) || defined (DIGITAL_UNIX) */
#else
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (result);

  ACE_SOCKCALL_RETURN (::getprotobynumber (proto),
                       struct protoent *, 0);
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE) */
}

ACE_INLINE struct servent *
ACE_OS::getservbyname (const char *svc, const char *proto)
{
  // ACE_TRACE ("ACE_OS::getservbyname");
#if defined (ACE_LACKS_GETSERVBYNAME)
  ACE_UNUSED_ARG (svc);
  ACE_UNUSED_ARG (proto);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::getservbyname ((char *) svc, (char *) proto),
                       struct servent *, 0);
#else
  ACE_SOCKCALL_RETURN (::getservbyname (svc, proto),
                       struct servent *, 0);
#endif /* ACE_HAS_NONCONST_GETBY */
}

ACE_INLINE int
ACE_OS::getsockname (ACE_HANDLE handle,
                     struct sockaddr *addr,
                     int *addrlen)
{
  // ACE_TRACE ("ACE_OS::getsockname");

  ACE_SOCKCALL_RETURN (::getsockname ((ACE_SOCKET) handle, addr, (ACE_SOCKET_LEN *) addrlen),
                       int, -1);
}

ACE_INLINE int
ACE_OS::getsockopt (ACE_HANDLE handle,
                    int level,
                    int optname,
                    char *optval,
                    int *optlen)
{
  // ACE_TRACE ("ACE_OS::getsockopt");
  ACE_SOCKCALL_RETURN (::getsockopt ((ACE_SOCKET) handle, level, optname, optval, (ACE_SOCKET_LEN *) optlen),
                       int, -1);
}

ACE_INLINE int
ACE_OS::listen (ACE_HANDLE handle, int backlog)
{
  // ACE_TRACE ("ACE_OS::listen");
  ACE_SOCKCALL_RETURN (::listen ((ACE_SOCKET) handle, backlog), int, -1);
}

ACE_INLINE int
ACE_OS::setsockopt (ACE_HANDLE handle, int level, int optname,
                    const char *optval, int optlen)
{
  // ACE_TRACE ("ACE_OS::setsockopt");

  ACE_SOCKCALL_RETURN (::setsockopt ((ACE_SOCKET) handle, level, optname,
                                     (ACE_SOCKOPT_TYPE1) optval, optlen),
                       int, -1);
}

ACE_INLINE int
ACE_OS::shutdown (ACE_HANDLE handle, int how)
{
  // ACE_TRACE ("ACE_OS::shutdown");
  ACE_SOCKCALL_RETURN (::shutdown ((ACE_SOCKET) handle, how), int, -1);
}

ACE_INLINE ACE_HANDLE
ACE_OS::socket (int domain, int type, int proto)
{
  // ACE_TRACE ("ACE_OS::socket");
  ACE_SOCKCALL_RETURN (::socket (domain, type, proto),
                       ACE_HANDLE, ACE_INVALID_HANDLE);
}

ACE_INLINE int
ACE_OS::atoi (const char *s)
{
  // ACE_TRACE ("ACE_OS::atoi");
  ACE_OSCALL_RETURN (::atoi (s), int, -1);
}

ACE_INLINE int
ACE_OS::recvmsg (ACE_HANDLE handle, struct msghdr *msg, int flags)
{
  // ACE_TRACE ("ACE_OS::recvmsg");
#if !defined (ACE_LACKS_RECVMSG)
  ACE_SOCKCALL_RETURN (::recvmsg (handle, msg, flags), int, -1);
#else
  ACE_UNUSED_ARG (flags);
  ACE_UNUSED_ARG (msg);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_MSG */
}

ACE_INLINE int
ACE_OS::sendmsg (ACE_HANDLE handle, const struct msghdr *msg, int flags)
{
  // ACE_TRACE ("ACE_OS::sendmsg");
#if !defined (ACE_LACKS_SENDMSG)
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_SOCKCALL_RETURN (::sendmsg (handle, (struct msghdr *) msg, flags), int, -1);
#else
  ACE_SOCKCALL_RETURN (::sendmsg (handle, (ACE_SENDMSG_TYPE *) msg, flags), int, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#else
  ACE_UNUSED_ARG (flags);
  ACE_UNUSED_ARG (msg);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_MSG */
}

ACE_INLINE int
ACE_OS::fclose (FILE *fp)
{
  // ACE_TRACE ("ACE_OS::fclose");
  ACE_OSCALL_RETURN (::fclose (fp), int, -1);
}

ACE_INLINE char *
ACE_OS::fgets (char *buf, int size, FILE *fp)
{
  // ACE_TRACE ("ACE_OS::fgets");
  ACE_OSCALL_RETURN (::fgets (buf, size, fp), char *, 0);
}

ACE_INLINE int
ACE_OS::fflush (FILE *fp)
{
  // ACE_TRACE ("ACE_OS::fflush");
  ACE_OSCALL_RETURN (::fflush (fp), int, -1);
}

ACE_INLINE FILE *
ACE_OS::fopen (const char *filename, const char *mode)
{
  // ACE_TRACE ("ACE_OS::fopen");
  ACE_OSCALL_RETURN (::fopen (filename, mode), FILE *, 0);
}

ACE_INLINE size_t
ACE_OS::fread (void *ptr, size_t size, size_t nelems, FILE *fp)
{
  // ACE_TRACE ("ACE_OS::fread");
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::fread ((char *) ptr, size, nelems, fp), int, 0);
#else
  ACE_OSCALL_RETURN (::fread (ptr, size, nelems, fp), int, 0);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
}

ACE_INLINE size_t
ACE_OS::fwrite (const void *ptr, size_t size, size_t nitems, FILE *fp)
{
  // ACE_TRACE ("ACE_OS::fwrite");
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::fwrite ((const char *) ptr, size, nitems, fp), int, 0);
#else
  ACE_OSCALL_RETURN (::fwrite (ptr, size, nitems, fp), int, 0);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
}

// Accessors to PWD file.

ACE_INLINE struct passwd *
ACE_OS::getpwnam (const char *name)
{
#if !defined (ACE_LACKS_PWD_FUNCTIONS)
#if !defined (ACE_WIN32)
  return ::getpwnam (name);
#else
  ACE_UNUSED_ARG (name);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_WIN32 */
#else
  ACE_UNUSED_ARG (name);
  ACE_NOTSUP_RETURN (0);
#endif /* ! ACE_LACKS_PWD_FUNCTIONS */
}

ACE_INLINE struct passwd *
ACE_OS::getpwnam_r (const char *name, struct passwd *pwent,
                    char *buffer, int buflen)
{
#if !defined (ACE_LACKS_PWD_FUNCTIONS)
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if !defined (ACE_LACKS_PWD_REENTRANT_FUNCTIONS)
#if defined (ACE_HAS_PTHREADS_1003_DOT_1C)
  struct passwd *result;
#if defined (DIGITAL_UNIX)
  ::_Pgetpwnam_r (name, pwent, buffer, buflen, &result);
#else
  ::getpwnam_r (name, pwent, buffer, buflen, &result);
#endif /* (DIGITAL_UNIX) */
  return result;
#elif defined (AIX) || defined (HPUX_10)
  if (::getpwnam_r (name, pwent, buffer, buflen) == -1)
    return 0;
  else
    return pwent;
#else
  return ::getpwnam_r (name, pwent, buffer, buflen);
#endif /* ACE_HAS_PTHREADS_1003_DOT_1C */
#else
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (pwent);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (buflen);
  ACE_NOTSUP_RETURN (0);
#endif /* ! ACE_LACKS_PWD_REENTRANT_FUNCTIONS */
#else
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (pwent);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (buflen);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_REENTRANT_FUNCTIONS */
#else
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (pwent);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (buflen);
  ACE_NOTSUP_RETURN (0);
#endif /* ! ACE_LACKS_PWD_FUNCTIONS */
}

// DNS accessors.

ACE_INLINE struct hostent *
ACE_OS::gethostbyaddr_r (const char *addr, int length, int type,
                         hostent *result, ACE_HOSTENT_DATA buffer,
                         int *h_errnop)
{
  // ACE_TRACE ("ACE_OS::gethostbyaddr_r");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (length);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (h_errnop);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE)
#if defined (AIX) || defined (DIGITAL_UNIX) || defined (HPUX_10)
  ::memset (buffer, 0, sizeof (ACE_HOSTENT_DATA));

  if (::gethostbyaddr_r ((char *) addr, length, type, result,
                         (struct hostent_data *) buffer)== 0)
    return result;
  else
    {
      *h_errnop = h_errno;
      return (struct hostent *) 0;
    }
#else
#if defined(ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (h_errnop);
  ACE_NETDBCALL_RETURN (::gethostbyaddr (addr, (ACE_SOCKET_LEN) length, type),
                        struct hostent *, 0,
                        buffer, sizeof (ACE_HOSTENT_DATA));
#else
  ACE_SOCKCALL_RETURN (::gethostbyaddr_r (addr, length, type, result,
                                          buffer, sizeof (ACE_HOSTENT_DATA),
                                          h_errnop),
                       struct hostent *, 0);
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */
#endif /* defined (AIX) || defined (DIGITAL_UNIX) */
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::gethostbyaddr ((char *) addr, (ACE_SOCKET_LEN) length, type),
                       struct hostent *, 0);
#else
  ACE_UNUSED_ARG (h_errnop);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (result);

  ACE_SOCKCALL_RETURN (::gethostbyaddr (addr, (ACE_SOCKET_LEN) length, type),
                       struct hostent *, 0);
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE) */
}

ACE_INLINE struct hostent *
ACE_OS::gethostbyname_r (const char *name, hostent *result,
                         ACE_HOSTENT_DATA buffer,
                         int *h_errnop)
{
  // ACE_TRACE ("ACE_OS::gethostbyname_r");
#if defined (VXWORKS)
  ACE_UNUSED_ARG (name);
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (h_errnop);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE)
#if defined (DIGITAL_UNIX)
  // gethostbyname returns thread-specific storage on Digital Unix
  ACE_SOCKCALL_RETURN (::gethostbyname (name), struct hostent *, 0);
#elif defined (AIX) || defined (HPUX_10)
  ::memset (buffer, 0, sizeof (ACE_HOSTENT_DATA));

  if (::gethostbyname_r (name, result, (struct hostent_data *) buffer) == 0)
    return result;
  else
    {
      *h_errnop = h_errno;
      return (struct hostent *) 0;
    }
#else
#if defined(ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (h_errnop);
  ACE_NETDBCALL_RETURN (::gethostbyname (name),
                        struct hostent *, 0,
                        buffer, sizeof (ACE_HOSTENT_DATA));
#else
  ACE_SOCKCALL_RETURN (::gethostbyname_r (name, result, buffer,
                                          sizeof (ACE_HOSTENT_DATA), h_errnop),
                       struct hostent *, 0);
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */
#endif /* defined (AIX) || defined (DIGITAL_UNIX) */
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::gethostbyname ((char *) name), struct hostent *, 0);
#else
  ACE_UNUSED_ARG (h_errnop);
  ACE_UNUSED_ARG (buffer);
  ACE_UNUSED_ARG (result);

  ACE_SOCKCALL_RETURN (::gethostbyname (name), struct hostent *, 0);
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE) */
}

ACE_INLINE char *
ACE_OS::gets (char *str)
{
  // ACE_TRACE ("ACE_OS::gets");
  ACE_OSCALL_RETURN (::gets (str), char *, 0);
}

ACE_INLINE struct servent *
ACE_OS::getservbyname_r (const char *svc, const char *proto,
                         struct servent *result, ACE_SERVENT_DATA buf)
{
  // ACE_TRACE ("ACE_OS::getservbyname_r");
#if defined (ACE_LACKS_GETSERVBYNAME)
  ACE_UNUSED_ARG (svc);
  ACE_UNUSED_ARG (proto);
  ACE_UNUSED_ARG (result);
  ACE_UNUSED_ARG (buf);
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE)
#if defined (AIX) || defined (DIGITAL_UNIX) || defined (HPUX_10)
  ::memset (buf, 0, sizeof (ACE_SERVENT_DATA));

  if (::getservbyname_r (svc, proto, result, (struct servent_data *) buf) == 0)
    return result;
  else
    return (struct servent *) 0;
#else
#if defined(ACE_LACKS_NETDB_REENTRANT_FUNCTIONS)
  ACE_UNUSED_ARG (result);
  ACE_NETDBCALL_RETURN (::getservbyname (svc, proto),
                        struct servent *, 0,
                        buf, sizeof (ACE_SERVENT_DATA));
#else
  ACE_SOCKCALL_RETURN (::getservbyname_r (svc, proto, result, buf,
                                          sizeof (ACE_SERVENT_DATA)),
                       struct servent *, 0);
#endif /* ACE_LACKS_NETDB_REENTRANT_FUNCTIONS */
#endif /* defined (AIX) || defined (DIGITAL_UNIX) */
#elif defined (ACE_HAS_NONCONST_GETBY)
  ACE_SOCKCALL_RETURN (::getservbyname ((char *) svc, (char *) proto),
                       struct servent *, 0);
#else
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (result);

  ACE_SOCKCALL_RETURN (::getservbyname (svc, proto),
                       struct servent *, 0);
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) && !defined (UNIXWARE) */
}

ACE_INLINE long
ACE_OS::inet_addr (const char *name)
{
  // ACE_TRACE ("ACE_OS::inet_addr");
#if defined (VXWORKS)

  u_long ret = 0;
  u_int segment;
  bool valid = true;

  for (u_int i = 0; i < 4; ++i)
    {
      ret <<= 8;
      if (*name != '\0')
        {
          segment = 0;

          while (*name >= '0'  &&  *name <= '9')
            {
              segment *= 10;
              segment += *name++ - '0';
            }
          if (*name != '.' && *name != '\0')
            {
              valid = false;
              break;
            }

          ret |= segment;

          if (*name == '.')
            {
              ++name;
            }
        }
    }
  return valid ? (long) htonl (ret) : -1L;
#elif defined (ACE_HAS_NONCONST_GETBY)
  return ::inet_addr ((char *) name);
#else
  return ::inet_addr (name);
#endif /* ACE_HAS_NONCONST_GETBY */
}

#if ! defined (VXWORKS)
ACE_INLINE char *
ACE_OS::inet_ntoa (const struct in_addr addr)
{
  // ACE_TRACE ("ACE_OS::inet_ntoa");
  ACE_OSCALL_RETURN (::inet_ntoa (addr), char *, 0);
}
#endif /* ! VXWORKS */

ACE_INLINE int
ACE_OS::last_error (void)
{
  // ACE_TRACE ("ACE_OS::last_error");
#if defined (ACE_WIN32)
  return errno == 0 ? ::GetLastError () : errno;
#else
  return errno;
#endif /* ACE_HAS_WIN32 */
}

ACE_INLINE void
ACE_OS::last_error (int error)
{
  // ACE_TRACE ("ACE_OS::last_error");
#if defined (ACE_WIN32)
  ::SetLastError (error);
#else
  errno = error;
#endif /* ACE_HAS_WIN32 */
}

ACE_INLINE void
ACE_OS::perror (const char *s)
{
  // ACE_TRACE ("ACE_OS::perror");
  ::perror (s);
}

ACE_INLINE int
ACE_OS::puts (const char *s)
{
  // ACE_TRACE ("ACE_OS::puts");
  ACE_OSCALL_RETURN (::puts (s), int, -1);
}

ACE_INLINE ACE_SignalHandler
ACE_OS::signal (int signum, ACE_SignalHandler func)
{
#if !defined (ACE_HAS_TANDEM_SIGNALS) && !defined (ACE_HAS_LYNXOS_SIGNALS)
    return ::signal (signum, func);
#else
  return (ACE_SignalHandler) ::signal (signum, (void (*)(int)) func);
#endif /* !ACE_HAS_TANDEM_SIGNALS */
}

ACE_INLINE int
ACE_OS::system (const char *s)
{
  // ACE_TRACE ("ACE_OS::system");
#if !defined (CHORUS)
    // ACE_TRACE ("ACE_OS::system");
    ACE_OSCALL_RETURN (::system (s), int, -1);
#endif /* !CHORUS */
}

ACE_INLINE int
ACE_OS::thr_continue (ACE_hthread_t target_thread)
{
  // ACE_TRACE ("ACE_OS::thr_continue");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_continue (target_thread), ace_result_), int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (target_thread);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  DWORD result = ::ResumeThread (target_thread);
  if (result == ACE_SYSCALL_FAILED)
    ACE_FAIL_RETURN (-1);
  else
    return 0;
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::taskResume (target_thread), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (target_thread);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_equal (ACE_thread_t t1, ACE_thread_t t2)
{
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#if defined (pthread_equal)
  // If it's a macro we can't say "::pthread_equal"...
  return pthread_equal (t1, t2);
#else
  return ::pthread_equal (t1, t2);
#endif /* pthread_equal */
#elif defined (VXWORKS)
  return ! ACE_OS::strcmp (t1, t2);
#else /* For both STHREADS and WTHREADS... */
  // Hum, Do we need to treat WTHREAD differently?
  return t1 == t2;
#endif /* ACE_HAS_DCETHREADS */
}

ACE_INLINE int
ACE_OS::thr_cmp (ACE_hthread_t t1, ACE_hthread_t t2)
{
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#if defined (ACE_HAS_TID_T) && !defined (ACE_HAS_PTHREAD_EQUAL)
  return t1 == t2; // I hope these aren't structs!
#elif defined (pthread_equal)
  // If it's a macro we can't say "::pthread_equal"...
  return pthread_equal (t1, t2);
#else
  return ::pthread_equal (t1, t2);
#endif /* pthread_equal */
#else /* For STHREADS, WTHREADS, and VXWORKS ... */
  // Hum, Do we need to treat WTHREAD differently?
  return t1 == t2;
#endif /* ACE_HAS_DCETHREADS */
}

ACE_INLINE int
ACE_OS::thr_getconcurrency (void)
{
  // ACE_TRACE ("ACE_OS::thr_getconcurrency");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  return ::thr_getconcurrency ();
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS) || defined (VXWORKS)
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_getprio (ACE_hthread_t thr_id, int &prio)
{
  // ACE_TRACE ("ACE_OS::thr_getprio");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_getprio (thr_id, &prio), ace_result_), int, -1);
#elif (defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)) && !defined (ACE_LACKS_SETSCHED)

# if defined (ACE_HAS_DCE_DRAFT4_THREADS)
  int result;
  result = ::pthread_getprio (thr_id);
  if (result != -1)
    {
      prio = result;
      return 0;
    }
  else
    return -1;
# else

  struct sched_param param;
  int result;
  int policy = 0;

  ACE_OSCALL (ACE_ADAPT_RETVAL (::pthread_getschedparam (thr_id, &policy, &param),
                                result), int,
              -1, result);
  prio = param.sched_priority;
  return result;
# endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_WTHREADS)
  prio = ::GetThreadPriority (thr_id);
  if (prio == THREAD_PRIORITY_ERROR_RETURN)
    ACE_FAIL_RETURN (-1);
  else
    return 0;
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::taskPriorityGet (thr_id, &prio), ace_result_), int, -1);
#else
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (prio);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (prio);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}


ACE_INLINE void
ACE_OS::thr_self (ACE_hthread_t &self)
{
  // ACE_TRACE ("ACE_OS::thr_self");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS)
  // Note, don't use "::" here since the following call is often a macro.
  self = pthread_self ();
#elif defined (ACE_HAS_THREAD_SELF)
  self = ::thread_self ();
#elif defined (ACE_HAS_PTHREADS)
  // Note, don't use "::" here since the following call is often a macro.
  self = pthread_self ();
#elif defined (ACE_HAS_STHREADS)
  self = ::thr_self ();
#elif defined (ACE_HAS_WTHREADS)
  self = ::GetCurrentThread ();
#elif defined (VXWORKS)
  self = ::taskIdSelf ();
#endif /* ACE_HAS_STHREADS */
#else
  self = 1; // Might as well make it the main thread ;-)
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE ACE_thread_t
ACE_OS::thr_self (void)
{
  // ACE_TRACE ("ACE_OS::thr_self");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  // Note, don't use "::" here since the following call is often a macro.
  ACE_OSCALL_RETURN (pthread_self (), int, -1);
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (::thr_self (), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  return ::GetCurrentThreadId ();
#elif defined (VXWORKS)
  return ::taskName (::taskIdSelf ());
#endif /* ACE_HAS_STHREADS */
#else
  return 1; // Might as well make it the first thread ;-)
#endif /* ACE_HAS_THREADS */
}

# if defined (ACE_HAS_TSS_EMULATION)
ACE_INLINE
void **&
ACE_TSS_Emulation::tss_base ()
{
#if defined (VXWORKS)
  return ((void **&) taskIdCurrent->spare4);
#else
  return tss_collection_ [ACE_OS::thr_self ()];
#endif /* VXWORKS */
}

ACE_INLINE
ACE_thread_key_t
ACE_TSS_Emulation::total_keys ()
{
  return total_keys_;
}

ACE_INLINE
ACE_thread_key_t
ACE_TSS_Emulation::next_key ()
{
  return total_keys_ < ACE_TSS_THREAD_KEYS_MAX
           ? total_keys_++
           : ACE_OS::NULL_key;
}

ACE_INLINE
ACE_TSS_Emulation::ACE_TSS_DESTRUCTOR
ACE_TSS_Emulation::tss_destructor (const ACE_thread_key_t key)
{
  return tss_destructor_ [key];
}

ACE_INLINE
void
ACE_TSS_Emulation::tss_destructor (const ACE_thread_key_t key,
                                   ACE_TSS_DESTRUCTOR destructor)
{
  tss_destructor_ [key] = destructor;
}

ACE_INLINE
void *&
ACE_TSS_Emulation::ts_object (const ACE_thread_key_t key)
{
  return tss_base ()[key];
}

#endif /* ACE_HAS_TSS_EMULATION */

ACE_INLINE int
ACE_OS::thr_getspecific (ACE_thread_key_t key, void **data)
{
  // ACE_TRACE ("ACE_OS::thr_getspecific");
#if defined (ACE_HAS_THREADS)
# if defined (ACE_HAS_TSS_EMULATION)
    if (key >= ACE_TSS_Emulation::total_keys ())
      {
        errno = EINVAL;
        data = 0;
        return -1;
      }
    else
      {
        *data = ACE_TSS_Emulation::ts_object (key);
        return 0;
      }
# elif defined (ACE_HAS_STHREADS)
    ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_getspecific (key, data), ace_result_), int, -1);
# elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#   if !defined (ACE_HAS_FSU_PTHREADS) && !defined (ACE_HAS_PTHREAD_GETSPECIFIC_DATAPTR)
      // Note, don't use "::" here since the following call is often a macro.
      *data = pthread_getspecific (key);
#   elif !defined (ACE_HAS_FSU_PTHREADS) && defined (ACE_HAS_SETKIND_NP) || defined (ACE_HAS_PTHREAD_GETSPECIFIC_DATAPTR)
      ::pthread_getspecific (key, data);
#   else /* ACE_HAS_FSU_PTHREADS */
      // Is this really used anywhere?
      *data = ::pthread_getspecific (key, data);
#   endif       /*  ACE_HAS_FSU_PTHREADS */
      return 0;
# elif defined (ACE_HAS_WTHREADS)
    int error = errno;
    *data = ::TlsGetValue (key);
    if (*data == 0 && (errno = ::GetLastError ()) != NO_ERROR)
      return -1;
    else
      {
        errno = error;
        return 0;
      }
# endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (key);
  ACE_UNUSED_ARG (data);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_join (ACE_thread_t waiter_id,
                  ACE_thread_t *thr_id,
                  void **status)
{
  // ACE_TRACE ("ACE_OS::thr_join");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_join (waiter_id, thr_id, status), ace_result_),
                     int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (thr_id);
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS)
  ACE_OSCALL_RETURN (::pthread_join (waiter_id, status), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_join (waiter_id, status), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (waiter_id);
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (status);

  // This could be implemented if the DLL-Main function or the
  // task exit base class some log the threads which have exited
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (waiter_id);
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (status);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (waiter_id);
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (status);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_join (ACE_hthread_t thr_handle,
                  void **status)
{
  // ACE_TRACE ("ACE_OS::thr_join");
  thr_handle = thr_handle;
  status = status;
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_join (thr_handle, 0, status), ace_result_),
                     int, -1);
#elif (defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)) && !defined (ACE_HAS_THREAD_SELF)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS)
  ACE_OSCALL_RETURN (::pthread_join (thr_handle, status), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_join (thr_handle, status), ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_WTHREADS)
  void *local_status = 0;

  // Make sure that status is non-NULL.
  if (status == 0)
    status = &local_status;

  if (::WaitForSingleObject (thr_handle, INFINITE) == WAIT_OBJECT_0
      && ::GetExitCodeThread (thr_handle, (LPDWORD) status) != FALSE)
    {
      ::CloseHandle (thr_handle);
      return 0;
    }
  ACE_FAIL_RETURN (-1);
  /* NOTREACHED */
#elif defined (VXWORKS)
  // VxWorks could possibly support thread join with
  // ::taskSafe()/::taskUnsafe().  But, a task can only calls those
  // functions on itself.  Until there's really a need . . .
  ACE_UNUSED_ARG (thr_handle);
  ACE_UNUSED_ARG (status);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_UNUSED_ARG (thr_handle);
  ACE_UNUSED_ARG (status);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (thr_handle);
  ACE_UNUSED_ARG (status);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_setcancelstate (int new_state, int *old_state)
{
  // ACE_TRACE ("ACE_OS::thr_setcancelstate");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || (defined (ACE_HAS_PTHREADS) && defined (ACE_HAS_STHREADS))
#if defined (ACE_HAS_DCETHREADS)
  ACE_UNUSED_ARG (old_state);
  ACE_OSCALL_RETURN (::pthread_setcancel (new_state), int, -1);
#else /* ACE_HAS_DCETHREADS */
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_setcancelstate (new_state, old_state),
                                       ace_result_),
                     int, -1);
#endif /* ACE_HAS_DCETHREADS */
#elif defined (ACE_HAS_PTHREADS)
  // I didn't manage to find pthread_cancel anywhere in the MIT pthread
  // implementation. So I'll just leave this instead, and see what
  // breaks. -- jwr
  ACE_UNUSED_ARG (new_state);
  ACE_UNUSED_ARG (old_state);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (new_state);
  ACE_UNUSED_ARG (old_state);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (new_state);
  ACE_UNUSED_ARG (old_state);
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (new_state);
  ACE_UNUSED_ARG (old_state);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (new_state);
  ACE_UNUSED_ARG (old_state);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_setcanceltype (int new_type, int *old_type)
{
  // ACE_TRACE ("ACE_OS::thr_setcanceltype");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || (defined (ACE_HAS_PTHREADS) && defined (ACE_HAS_STHREADS))
#if defined (ACE_HAS_DCETHREADS)
  ACE_UNUSED_ARG (old_type);
  ACE_OSCALL_RETURN (::pthread_setcancel (new_type), int, -1);
#else /* ACE_HAS_DCETHREADS */
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_setcanceltype (new_type, old_type),
                                       ace_result_),
                     int, -1);
#endif /* ACE_HAS_DCETHREADS */
#elif defined (ACE_HAS_PTHREADS)
  // I didn't manage to find pthread_cancel anywhere int the MIT pthread
  // implementation. So I'll just leave this instead, and see what
  // breaks. -- jwr
  ACE_UNUSED_ARG (new_type);
  ACE_UNUSED_ARG (old_type);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (new_type);
  ACE_UNUSED_ARG (old_type);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (new_type);
  ACE_UNUSED_ARG (old_type);
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (new_type);
  ACE_UNUSED_ARG (old_type);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (new_type);
  ACE_UNUSED_ARG (old_type);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_cancel (ACE_thread_t thr_id)
{
  // ACE_TRACE ("ACE_OS::thr_cancel");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS) && !defined (ACE_LACKS_PTHREAD_CANCEL)
#  if defined (ACE_HAS_DCE_DRAFT4_THREADS)
  ACE_OSCALL_RETURN (::pthread_cancel (thr_id), int, -1);
#  else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_cancel (thr_id),
                                       ace_result_),
                     int, -1);
#  endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_PTHREADS)
  // I didn't manage to find pthread_cancel anywhere int the MIT
  // pthread implementation. So I'll just leave this instead, and
  // see what breaks. -- jwr
  ACE_UNUSED_ARG (thr_id);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_STHREADS)
  ACE_UNUSED_ARG (thr_id);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (thr_id);
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (thr_id);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (thr_id);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::sigwait (sigset_t *set, int *sig)
{
  // ACE_TRACE ("ACE_OS::sigwait");
  int local_sig;
  if (sig == 0)
    sig = &local_sig;
#if defined (ACE_HAS_THREADS)
#if defined (__FreeBSD__) || defined (CHORUS)
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_STHREADS) || defined (ACE_HAS_FSU_PTHREADS)
  *sig = ::sigwait (set);
  return *sig;
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#if defined (ACE_HAS_ONEARG_SIGWAIT)
  *sig = ::sigwait (set);
  return *sig;
#else /* ACE_HAS_ONEARG_SETWAIT */
#if defined (DIGITAL_UNIX)
  errno = ::__sigwaitd10 (set, sig);
#elif defined (__Lynx__)
  // Second arg is a void **, which we don't need (the selected
  // signal number is returned).
  *sig = ::sigwait (set, 0);
  return *sig;
#else
  errno = ::sigwait (set, sig);
#endif /* DIGITAL_UNIX */
  if (errno == -1)
    return -1;
  else
    return *sig;
#endif /* ACE_HAS_ONEARG_SIGWAIT */
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (set);
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  // second arg is a struct siginfo *, which we don't need (the selected
  // signal number is returned)
  // third arg is timeout:  0 means forever
  *sig = ::sigtimedwait (set, 0, 0);
  return *sig;
#endif /* __FreeBSD__ */
#else
  ACE_UNUSED_ARG (set);
  ACE_UNUSED_ARG (sig);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE void
ACE_OS::thr_testcancel (void)
{
  // ACE_TRACE ("ACE_OS::thr_testcancel");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS) || (defined (ACE_HAS_PTHREADS) && defined (ACE_HAS_STHREADS))
  ::pthread_testcancel ();
#elif defined (ACE_HAS_PTHREADS)
  // I didn't manage to find pthread_cancel anywhere int the MIT
  // pthread implementation. So I'll just leave this instead, and
  // see what breaks. -- jwr
#elif defined (ACE_HAS_STHREADS)
#elif defined (ACE_HAS_WTHREADS)
#elif defined (VXWORKS)
  // no-op:  can't use ACE_NOTSUP_RETURN because there is no return value
#endif /* ACE_HAS_STHREADS */
#else
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_sigsetmask (int how,
                        const sigset_t *nsm,
                        sigset_t *osm)
{
  // ACE_TRACE ("ACE_OS::thr_sigsetmask");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_LACKS_PTHREAD_THR_SIGSETMASK)
  // DCE threads and Solaris 2.4 have no such function.
  ACE_UNUSED_ARG (osm);
  ACE_UNUSED_ARG (nsm);
  ACE_UNUSED_ARG (how);

  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_SIGTHREADMASK)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::sigthreadmask (how, nsm, osm),
                                       ace_result_), int, -1);
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_sigsetmask (how, nsm, osm),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_PTHREAD_SIGMASK)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_sigmask (how, nsm, osm),
                                       ace_result_), int, -1);
#elif defined (ACE_HAS_PTHREADS) && !defined (ACE_HAS_FSU_PTHREADS)
  // as far as I can tell, this is now pthread_sigaction() -- jwr
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_sigaction (how, nsm, osm),
                                       ace_result_), int, -1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (osm);
  ACE_UNUSED_ARG (nsm);
  ACE_UNUSED_ARG (how);

  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  switch (how)
    {
    case SIG_BLOCK:
    case SIG_UNBLOCK:
      {
        // get the old mask
        *osm = ::sigsetmask (*nsm);
        // create a new mask:  the following assumes that sigset_t is 4 bytes,
        // which it is on VxWorks 5.2, so bit operations are done simply . . .
        ::sigsetmask (how == SIG_BLOCK ? (*osm |= *nsm) : (*osm &= ~*nsm));
        break;
      }
    case SIG_SETMASK:
      *osm = ::sigsetmask (*nsm);
      break;
    default:
      return -1;
    }

  return 0;
#else /* Should not happen. */
  ACE_UNUSED_ARG (how);
  ACE_UNUSED_ARG (nsm);
  ACE_UNUSED_ARG (osm);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_LACKS_PTHREAD_THR_SIGSETMASK */
#else
  ACE_UNUSED_ARG (how);
  ACE_UNUSED_ARG (nsm);
  ACE_UNUSED_ARG (osm);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_kill (ACE_thread_t thr_id, int signum)
{
  // ACE_TRACE ("ACE_OS::thr_kill");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_DCETHREADS)
  ACE_UNUSED_ARG (signum);
  ACE_OSCALL_RETURN (pthread_cancel (thr_id), int, -1);
#elif defined (ACE_HAS_PTHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_kill (thr_id, signum),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_kill (thr_id, signum),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (signum);
  ACE_UNUSED_ARG (thr_id);

  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_hthread_t tid;
  ACE_OSCALL (ACE_ADAPT_RETVAL (::taskNameToId (thr_id), tid),
              int, ERROR, tid);

  if (tid == ERROR)
    return -1;
  else
    ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::kill (tid, signum), ace_result_),
                       int, -1);

#else /* This should not happen! */
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (signum);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (signum);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE size_t
ACE_OS::thr_min_stack (void)
{
  // ACE_TRACE ("ACE_OS::thr_min_stack");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
#if defined (ACE_HAS_THR_MINSTACK)
  // Tandem did some weirdo mangling of STHREAD names...
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_minstack (),
                                       ace_result_),
                     int, -1);
#else
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_min_stack (),
                                       ace_result_),
                     int, -1);
#endif /* !ACE_HAS_THR_MINSTACK */
#elif defined (ACE_HAS_PTHREADS)
#if defined (ACE_HAS_IRIX62_THREADS)
  return (size_t) ACE_OS::sysconf (_SC_THREAD_STACK_MIN);
#elif defined (PTHREAD_STACK_MIN)
  return PTHREAD_STACK_MIN;
#else
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_IRIX62_THREADS */
#elif defined (ACE_HAS_DCETHREADS)
  ACE_NOTSUP_RETURN (0);
#elif defined (ACE_HAS_WTHREADS)
  ACE_NOTSUP_RETURN (0);
#elif defined (VXWORKS)
  TASK_DESC taskDesc;
  STATUS status;

  ACE_hthread_t tid;
  ACE_OS::thr_self (tid);

  ACE_OSCALL (ACE_ADAPT_RETVAL (::taskInfoGet (tid, &taskDesc),
                                status),
              STATUS, -1, status);
  return status == OK ? taskDesc.td_stackSize : 0;
#else /* Should not happen... */
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_setconcurrency (int hint)
{
  // ACE_TRACE ("ACE_OS::thr_setconcurrency");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_setconcurrency (hint),
                                       ace_result_),
                     int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (hint);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  ACE_UNUSED_ARG (hint);

  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (hint);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (hint);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_setprio (ACE_hthread_t thr_id, int prio)
{
  // ACE_TRACE ("ACE_OS::thr_setprio");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_setprio (thr_id, prio),
                                       ace_result_),
                     int, -1);
#elif (defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)) && !defined (ACE_LACKS_SETSCHED)

# if defined (ACE_HAS_DCE_DRAFT4_THREADS)
  int result;
  result = ::pthread_setprio(thr_id, prio);
  return (result == -1 ? -1 : 0);
# else
  struct sched_param param;
  int policy = 0;
  int result;

  ACE_OSCALL (ACE_ADAPT_RETVAL (::pthread_getschedparam (thr_id, &policy, &param),
                                result), // not sure if use of result here is cool, cjc
              int, -1, result);
  if (result == -1)
    return result; // error in pthread_getschedparam
  param.sched_priority = prio;
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::pthread_setschedparam (thr_id, policy, &param),
                                       result),
                     int, -1);
# endif /* ACE_HAS_DCE_DRAFT4_THREADS */
#elif defined (ACE_HAS_WTHREADS)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::SetThreadPriority (thr_id, prio),
                                       ace_result_),
                     int, -1);
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::taskPrioritySet (thr_id, prio),
                                       ace_result_),
                     int, -1);
#else
  // For example, platforms that support Pthreads but LACK_SETSCHED.
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (prio);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (thr_id);
  ACE_UNUSED_ARG (prio);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE int
ACE_OS::thr_suspend (ACE_hthread_t target_thread)
{
  // ACE_TRACE ("ACE_OS::thr_suspend");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::thr_suspend (target_thread), ace_result_), int, -1);
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
  ACE_UNUSED_ARG (target_thread);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_HAS_WTHREADS)
  if (::SuspendThread (target_thread) != ACE_SYSCALL_FAILED)
    return 0;
  else
    ACE_FAIL_RETURN (-1);
  /* NOTREACHED */
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::taskSuspend (target_thread), ace_result_), int, -1);
#endif /* ACE_HAS_STHREADS */
#else
  ACE_UNUSED_ARG (target_thread);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE void
ACE_OS::thr_yield (void)
{
  // ACE_TRACE ("ACE_OS::thr_yield");
#if defined (ACE_HAS_THREADS)
#if defined (ACE_HAS_STHREADS)
  ::thr_yield ();
#elif defined (ACE_HAS_DCETHREADS) || defined (ACE_HAS_PTHREADS)
#if defined (ACE_HAS_IRIX62_THREADS) || defined (ACE_HAS_PTHREADS_1003_DOT_1C)
  ::sched_yield ();
#elif defined (ACE_HAS_FSU_PTHREADS) || defined (ACE_HAS_YIELD_VOID_PTR)
  ::pthread_yield (NULL);
#elif defined (ACE_LACKS_PTHREAD_YIELD) || defined (ACE_HAS_THR_YIELD)
  ::thr_yield ();
#else
  ::pthread_yield ();
#endif  /*  ACE_HAS_IRIX62_THREADS */
#elif defined (ACE_HAS_WTHREADS)
  ::Sleep (0);
#elif defined (VXWORKS)
  ::taskDelay (0);
#endif /* ACE_HAS_STHREADS */
#else
  ;
#endif /* ACE_HAS_THREADS */
}

ACE_INLINE void
ACE_OS::rewind (FILE *fp)
{
  // ACE_TRACE ("ACE_OS::rewind");
  ::rewind (fp);
}

// This function returns the number of bytes in the file referenced by
// FD.

ACE_INLINE long
ACE_OS::filesize (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::filesize");
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (::GetFileSize (handle, NULL), long, -1);
#else /* !ACE_WIN32 */
  struct stat sb;

  return ACE_OS::fstat (handle, &sb) == -1 ? -1 : (long) sb.st_size;
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::writev (ACE_HANDLE handle,
                const struct iovec *iov,
                int iovcnt)
{
  // ACE_TRACE ("ACE_OS::writev");
  ACE_OSCALL_RETURN (::writev (handle, (ACE_WRITEV_TYPE *) iov, iovcnt), int, -1);
}

ACE_INLINE ssize_t
ACE_OS::readv (ACE_HANDLE handle,
               struct iovec *iov,
               int iovlen)
{
  // ACE_TRACE ("ACE_OS::readv");
  ACE_OSCALL_RETURN (::readv (handle, iov, iovlen), ssize_t, -1);
}

ACE_INLINE int
ACE_OS::poll (struct pollfd *pollfds, u_long len, ACE_Time_Value *timeout)
{
  // ACE_TRACE ("ACE_OS::poll");
#if defined (ACE_HAS_POLL)
  int to = timeout == 0 ? -1 : int (timeout->msec ());
  ACE_OSCALL_RETURN (::poll (pollfds, len, to), int, -1);
#else
  ACE_UNUSED_ARG (timeout);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (pollfds);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POLL */
}

ACE_INLINE int
ACE_OS::poll (struct pollfd *pollfds, u_long len, const ACE_Time_Value &timeout)
{
  // ACE_TRACE ("ACE_OS::poll");
#if defined (ACE_HAS_POLL)
  ACE_OSCALL_RETURN (::poll (pollfds, len, int (timeout.msec ())), int, -1);
#else
  ACE_UNUSED_ARG (timeout);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (pollfds);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_POLL */
}

ACE_INLINE int
ACE_OS::t_accept (ACE_HANDLE handle, int reshandle,
                  struct t_call *call)
{
  // ACE_TRACE ("ACE_OS::t_accept");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_accept (handle, reshandle, call), int, -1);
#else
  ACE_UNUSED_ARG (call);
  ACE_UNUSED_ARG (reshandle);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE char *
ACE_OS::t_alloc (ACE_HANDLE handle, int struct_type,
             int fields)
{
  // ACE_TRACE ("ACE_OS::t_alloc");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_alloc (handle, struct_type, fields),
                     char *, 0);
#else
  ACE_UNUSED_ARG (fields);
  ACE_UNUSED_ARG (struct_type);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_bind (ACE_HANDLE handle, struct t_bind *req,
                struct t_bind *ret)
{
  // ACE_TRACE ("ACE_OS::t_bind");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_bind (handle, req, ret), int, -1);
#else
  ACE_UNUSED_ARG (ret);
  ACE_UNUSED_ARG (req);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_close (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_close");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_close (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_connect(int fildes,
                  struct t_call *sndcall,
                  struct t_call *rcvcall)
{
  // ACE_TRACE ("ACE_OS::t_connect");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_connect (fildes, sndcall, rcvcall), int, -1);
#else
  ACE_UNUSED_ARG (fildes);
  ACE_UNUSED_ARG (sndcall);
  ACE_UNUSED_ARG (rcvcall);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE void
ACE_OS::t_error (char *errmsg)
{
  // ACE_TRACE ("ACE_OS::t_error");
#if defined (ACE_HAS_TLI)
  ::t_error (errmsg);
#else
  ACE_UNUSED_ARG (errmsg);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_free (char *ptr, int struct_type)
{
  // ACE_TRACE ("ACE_OS::t_free");
#if defined (ACE_HAS_TLI)
  if (ptr != 0)
    return 0;
  ACE_OSCALL_RETURN (::t_free (ptr, struct_type), int, -1);
#else
  ACE_UNUSED_ARG (struct_type);
  ACE_UNUSED_ARG (ptr);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_getinfo (ACE_HANDLE handle, struct t_info *info)
{
  // ACE_TRACE ("ACE_OS::t_getinfo");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_getinfo (handle, info), int, -1);
#else
  ACE_UNUSED_ARG (info);
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_getname (ACE_HANDLE handle,
               struct netbuf *namep,
               int type)
{
  // ACE_TRACE ("ACE_OS::t_getname");
#if defined (ACE_HAS_SVR4_TLI)
  ACE_OSCALL_RETURN (::t_getname (handle, namep, type), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (namep);
  ACE_UNUSED_ARG (type);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::t_getstate (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_getstate");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_getstate (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_listen (ACE_HANDLE handle, struct t_call *call)
{
  // ACE_TRACE ("ACE_OS::t_listen");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_listen (handle, call), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (call);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_look (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_look");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_look (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_open (char *path, int oflag, struct t_info *info)
{
  // ACE_TRACE ("ACE_OS::t_open");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_open (path, oflag, info), int, -1);
#else
  ACE_UNUSED_ARG (path);
  ACE_UNUSED_ARG (oflag);
  ACE_UNUSED_ARG (info);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_optmgmt (ACE_HANDLE handle,
               struct t_optmgmt *req,
               struct t_optmgmt *ret)
{
  // ACE_TRACE ("ACE_OS::t_optmgmt");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_optmgmt (handle, req, ret), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (req);
  ACE_UNUSED_ARG (ret);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_rcv (ACE_HANDLE handle,
           char *buf,
           unsigned nbytes,
           int *flags)
{
  // ACE_TRACE ("ACE_OS::t_rcv");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_rcv (handle, buf, nbytes, flags),
                     int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (nbytes);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_rcvdis (ACE_HANDLE handle, struct t_discon *discon)
{
  // ACE_TRACE ("ACE_OS::t_rcvdis");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_rcvdis (handle, discon), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (discon);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_rcvrel (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_rcvrel");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_rcvrel (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_rcvudata (ACE_HANDLE handle,
                struct t_unitdata *unitdata,
                int *flags)
{
  // ACE_TRACE ("ACE_OS::t_rcvudata");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_rcvudata (handle, unitdata, flags),
                     int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (unitdata);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_rcvuderr (ACE_HANDLE handle, struct t_uderr *uderr)
{
  // ACE_TRACE ("ACE_OS::t_rcvuderr");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_rcvuderr (handle, uderr), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (uderr);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_snd (ACE_HANDLE handle, char *buf, unsigned nbytes, int flags)
{
  // ACE_TRACE ("ACE_OS::t_snd");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_snd (handle, buf, nbytes, flags), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (nbytes);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_snddis (ACE_HANDLE handle, struct t_call *call)
{
  // ACE_TRACE ("ACE_OS::t_snddis");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_snddis (handle, call), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (call);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_sndrel (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_sndrel");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_sndrel (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_sync (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_sync");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_sync (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE int
ACE_OS::t_unbind (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::t_unbind");
#if defined (ACE_HAS_TLI)
  ACE_OSCALL_RETURN (::t_unbind (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_TLI */
}

ACE_INLINE char *
ACE_OS::compile (const char *instring, char *expbuf, char *endbuf)
{
  // ACE_TRACE ("ACE_OS::compile");
#if defined (ACE_HAS_REGEX)
  ACE_OSCALL_RETURN (::compile (instring, expbuf, endbuf), char *, 0);
#else
  ACE_UNUSED_ARG (instring);
  ACE_UNUSED_ARG (expbuf);
  ACE_UNUSED_ARG (endbuf);

  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_REGEX */
}

ACE_INLINE int
ACE_OS::close (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::close");
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::CloseHandle (handle), ace_result_), int, -1);
#else
  ACE_OSCALL_RETURN (::close (handle), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::closesocket (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::close");
#if defined (ACE_WIN32)
  ACE_SOCKCALL_RETURN (::closesocket ((SOCKET) handle), int, -1);
#else
  ACE_OSCALL_RETURN (::close (handle), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::access (const char *path, int amode)
{
  // ACE_TRACE ("ACE_OS::access");
#if defined (ACE_LACKS_ACCESS)
  ACE_UNUSED_ARG (path);
  ACE_UNUSED_ARG (amode);
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_WIN32)
  ACE_OSCALL_RETURN (::_access (path, amode), int, -1);
#else
  ACE_OSCALL_RETURN (::access (path, amode), int, -1);
#endif /* ACE_LACKS_ACCESS */
}


ACE_INLINE ACE_HANDLE
ACE_OS::creat (LPCTSTR filename, mode_t mode)
{
  // ACE_TRACE ("ACE_OS::creat");
#if defined (ACE_WIN32)
  return ACE_OS::open (filename, mode);
#else
  ACE_OSCALL_RETURN (::creat (filename, mode),
                     ACE_HANDLE, ACE_INVALID_HANDLE);
#endif /* ACE_WIN32 */
}

#if !defined (ACE_WIN32) && !defined (VXWORKS) && !defined (CHORUS)
// Don't inline on those platforms because this function contains
// string literals, and some compilers, e.g., g++, don't handle those
// efficiently in unused inline functions.
ACE_INLINE int
ACE_OS::uname (struct utsname *name)
{
  // ACE_TRACE ("ACE_OS::uname");
  ACE_OSCALL_RETURN (::uname (name), int, -1);
}
#endif /* ! ACE_WIN32 && ! VXWORKS && ! CHORUS */

ACE_INLINE int
ACE_OS::hostname (char name[], size_t maxnamelen)
{
  // ACE_TRACE ("ACE_OS::hostname");
#if defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::GetComputerNameA (name, LPDWORD (&maxnamelen)),
                                       ace_result_), int, -1);
#elif defined (VXWORKS)
  ACE_OSCALL_RETURN (::gethostname (name, maxnamelen), int, -1);
#else /* !ACE_WIN32 */
  struct utsname host_info;

  if (ACE_OS::uname (&host_info) == -1)
    return -1;
  else
    {
      ACE_OS::strncpy (name, host_info.nodename, maxnamelen);
      return 0;
    }
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::msgctl (int msqid, int cmd, struct msqid_ds *val)
{
  // ACE_TRACE ("ACE_OS::msgctl");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::msgctl (msqid, cmd, val), int, -1);
#else
  ACE_UNUSED_ARG (msqid);
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (val);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::msgget (key_t key, int msgflg)
{
  // ACE_TRACE ("ACE_OS::msgget");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::msgget (key, msgflg), int, -1);
#else
  ACE_UNUSED_ARG (key);
  ACE_UNUSED_ARG (msgflg);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::msgrcv (int int_id, void *buf, size_t len,
                long type, int flags)
{
  // ACE_TRACE ("ACE_OS::msgrcv");
#if defined (ACE_HAS_SYSV_IPC)
#if defined (ACE_LACKS_POSIX_PROTOTYPES) || defined (ACE_LACKS_SOME_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::msgrcv (int_id, (msgbuf *) buf, len, type, flags),
                     int, -1);
#else
  ACE_OSCALL_RETURN (::msgrcv (int_id, buf, len, type, flags),
                     int, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#else
  ACE_UNUSED_ARG (int_id);
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::msgsnd (int int_id, const void *buf, size_t len, int flags)
{
  // ACE_TRACE ("ACE_OS::msgsnd");
#if defined (ACE_HAS_SYSV_IPC)
#if defined (ACE_LACKS_POSIX_PROTOTYPES) || defined (ACE_HAS_NONCONST_MSGSND) || defined (ACE_LACKS_POSIX_SOME_PROTOTYPES)
  ACE_OSCALL_RETURN (::msgsnd (int_id, (msgbuf *) buf, len, flags), int, -1);
#else
  ACE_OSCALL_RETURN (::msgsnd (int_id, buf, len, flags), int, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES || ACE_HAS_NONCONST_MSGSND */
#else
  ACE_UNUSED_ARG (int_id);
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE u_int
ACE_OS::alarm (u_int secs)
{
  // ACE_TRACE ("ACE_OS::alarm");

#if defined (ACE_WIN32) || defined (VXWORKS) || defined (CHORUS)
  ACE_UNUSED_ARG (secs);

  ACE_NOTSUP_RETURN (0);
#else
  return ::alarm (secs);
#endif /* ACE_WIN32 || VXWORKS || CHORUS */
}

ACE_INLINE u_int
ACE_OS::ualarm (u_int usecs, u_int interval)
{
  // ACE_TRACE ("ACE_OS::ualarm");

#if defined (ACE_HAS_UALARM)
  return ::ualarm (usecs, interval);
#elif !defined (ACE_LACKS_UNIX_SIGNALS)
  ACE_UNUSED_ARG (interval);
  return ::alarm (usecs * ACE_ONE_SECOND_IN_USECS);
#else
  ACE_UNUSED_ARG (usecs);
  ACE_UNUSED_ARG (interval);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_UALARM */
}

ACE_INLINE u_int
ACE_OS::ualarm (const ACE_Time_Value &tv,
                const ACE_Time_Value &tv_interval)
{
  // ACE_TRACE ("ACE_OS::ualarm");

#if defined (ACE_HAS_UALARM)
  u_int usecs = (tv.sec () * ACE_ONE_SECOND_IN_USECS) + tv.usec ();
  u_int interval = (tv_interval.sec () * ACE_ONE_SECOND_IN_USECS) + tv_interval.usec ();
  return ::ualarm (usecs, interval);
#elif !defined (ACE_LACKS_UNIX_SIGNALS)
  ACE_UNUSED_ARG (tv_interval);
  return ::alarm (tv.sec ());
#else
  ACE_UNUSED_ARG (tv_interval);
  ACE_UNUSED_ARG (tv);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_UALARM */
}

ACE_INLINE int
ACE_OS::dlclose (ACE_SHLIB_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::dlclose");
#if defined (ACE_HAS_SVR4_DYNAMIC_LINKING)

#if !defined (ACE_HAS_AUTOMATIC_INIT_FINI)
  // SunOS4 does not automatically call _fini()!
  void *ptr;

  ACE_OSCALL (::dlsym (handle, "_fini"), void *, 0, ptr);

  if (ptr != 0)
    (*((int (*)(void)) ptr)) (); // Call _fini hook explicitly.
#endif /* ACE_HAS_AUTOMATIC_INIT_FINI */
  ACE_OSCALL_RETURN (::dlclose (handle), int, -1);
#elif defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::FreeLibrary (handle), ace_result_), int, -1);
#elif defined (__hpux)
# if __cplusplus >= 199707L
  ACE_OSCALL_RETURN (::shl_unload(handle), int, -1);
# else
  ACE_OSCALL_RETURN (::cxxshl_unload(handle), int, -1);
# endif  /* aC++ vs. Hp C++ */
#else
  ACE_UNUSED_ARG (handle);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SVR4_DYNAMIC_LINKING */
}

ACE_INLINE char *
ACE_OS::dlerror (void)
{
  // ACE_TRACE ("ACE_OS::dlerror");
#if defined (ACE_HAS_SVR4_DYNAMIC_LINKING)
  ACE_OSCALL_RETURN ((char *)::dlerror (), char *, 0);
#elif defined (__hpux)
  ACE_OSCALL_RETURN (::strerror(errno), char *, 0);
#else
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_SVR4_DYNAMIC_LINKING */
}

ACE_INLINE ACE_SHLIB_HANDLE
ACE_OS::dlopen (ACE_DL_TYPE filename, int mode)
{
  // ACE_TRACE ("ACE_OS::dlopen");
#if defined (ACE_HAS_SVR4_DYNAMIC_LINKING)
  void *handle;
  ACE_OSCALL (::dlopen (filename, mode), void *, 0, handle);
#if !defined (ACE_HAS_AUTOMATIC_INIT_FINI)
  // Some systems (e.g., SunOS4) do not automatically call _init(), so
  // we'll have to call it manually.

  void *ptr;

  ACE_OSCALL (::dlsym (handle, "_init"), void *, 0, ptr);

  if (ptr != 0 && (*((int (*)(void)) ptr)) () == -1) // Call _init hook explicitly.
    return 0;
#endif /* ACE_HAS_AUTOMATIC_INIT_FINI */
  return handle;
#elif defined (ACE_WIN32)
  ACE_UNUSED_ARG (mode);

  ACE_WIN32CALL_RETURN (::LoadLibraryA (filename), ACE_SHLIB_HANDLE, 0);
#elif defined (__hpux)

# if __cplusplus >= 199707L
  ACE_OSCALL_RETURN (::shl_load(filename, mode, 0L), ACE_SHLIB_HANDLE, 0);
# else
  ACE_OSCALL_RETURN (::cxxshl_load(filename, mode, 0L), ACE_SHLIB_HANDLE, 0);
# endif  /* aC++ vs. Hp C++ */

#else
  ACE_UNUSED_ARG (filename);
  ACE_UNUSED_ARG (mode);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_SVR4_DYNAMIC_LINKING */
}

ACE_INLINE void *
ACE_OS::dlsym (ACE_SHLIB_HANDLE handle, ACE_DL_TYPE symbolname)
{
  // ACE_TRACE ("ACE_OS::dlsym");
#if defined (ACE_HAS_SVR4_DYNAMIC_LINKING)
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::dlsym (handle, (char*) symbolname), void *, 0);
#elif defined (ACE_USES_ASM_SYMBOL_IN_DLSYM)
  int l = strlen(symbolname) + 2;
  char* asm_symbolname;
  ACE_NEW_RETURN(asm_symbolname, char[l], 0);
  ACE_OS::strcpy (asm_symbolname, "_") ;
  ACE_OS::strcpy (asm_symbolname + 1, symbolname) ;
  void* ace_result;
  ACE_OSCALL (::dlsym (handle, asm_symbolname), void *, 0,
              ace_result);
  delete[] asm_symbolname;
  return ace_result;
#else
  ACE_OSCALL_RETURN (::dlsym (handle, symbolname), void *, 0);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#elif defined (ACE_WIN32)
  ACE_WIN32CALL_RETURN (::GetProcAddress (handle, symbolname), void *, 0);
#elif defined (__hpux)

  void *value;
  int status;
  shl_t _handle = handle;
  ACE_OSCALL (::shl_findsym(&_handle, symbolname, TYPE_UNDEFINED, &value), int, -1, status);
  return status == 0 ? value : NULL;

#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (symbolname);
  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_SVR4_DYNAMIC_LINKING */
}

ACE_INLINE void
ACE_OS::exit (int status)
{
  // ACE_TRACE ("ACE_OS::exit");
#if defined (ACE_WIN32)
  ::ExitProcess ((UINT) status);
#else
  ::exit (status);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::step (const char *str, char *expbuf)
{
  // ACE_TRACE ("ACE_OS::step");
#if defined (ACE_HAS_REGEX)
  ACE_OSCALL_RETURN (::step (str, expbuf), int, -1);
#else
  ACE_UNUSED_ARG (str);
  ACE_UNUSED_ARG (expbuf);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_REGEX */
}

ACE_INLINE long
ACE_OS::sysinfo (int cmd, char *buf, long count)
{
  // ACE_TRACE ("ACE_OS::sysinfo");
#if defined (ACE_HAS_SYSINFO)
  ACE_OSCALL_RETURN (::sysinfo (cmd, buf, count), long, -1);
#else
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (count);

  ACE_NOTSUP_RETURN (0);
#endif /* ACE_HAS_SYSINFO */
}

ACE_INLINE ssize_t
ACE_OS::write (ACE_HANDLE handle, const void *buf, size_t nbyte)
{
  // ACE_TRACE ("ACE_OS::write");
#if defined (ACE_WIN32)
  DWORD bytes_written; // This is set to 0 byte WriteFile.

  if (::WriteFile (handle, buf, nbyte, &bytes_written, 0))
    return (ssize_t) bytes_written;
  else
    ACE_FAIL_RETURN (-1);
#else
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::write (handle, (const char *) buf, nbyte), ssize_t, -1);
#elif defined (ACE_HAS_CHARPTR_SOCKOPT)
  ACE_OSCALL_RETURN (::write (handle, (char *) buf, nbyte), ssize_t, -1);
#else
  ACE_OSCALL_RETURN (::write (handle, buf, nbyte), ssize_t, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#endif /* ACE_WIN32 */
}

ACE_INLINE ssize_t
ACE_OS::write (ACE_HANDLE handle, const void *buf, size_t nbyte,
               ACE_OVERLAPPED *overlapped)
{
  // ACE_TRACE ("ACE_OS::write");
  overlapped = overlapped;
#if defined (ACE_WIN32)
  DWORD bytes_written; // This is set to 0 byte WriteFile.

  if (::WriteFile (handle, buf, nbyte, &bytes_written, overlapped))
    return (ssize_t) bytes_written;
  else
    return -1;
#else
  return ACE_OS::write (handle, buf, nbyte);
#endif /* ACE_WIN32 */
}

ACE_INLINE ssize_t
ACE_OS::read (ACE_HANDLE handle, void *buf, size_t len)
{
  // ACE_TRACE ("ACE_OS::read");
#if defined (ACE_WIN32)
  DWORD ok_len;
  if (::ReadFile (handle, buf, len, &ok_len, 0))
    return (ssize_t) ok_len;
  else
    ACE_FAIL_RETURN (-1);
#else
#if defined (ACE_LACKS_POSIX_PROTOTYPES) || defined (ACE_HAS_CHARPTR_SOCKOPT)
  ACE_OSCALL_RETURN (::read (handle, (char *) buf, len), ssize_t, -1);
#else
  ACE_OSCALL_RETURN (::read (handle, buf, len), ssize_t, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#endif /* ACE_WIN32 */
}

ACE_INLINE ssize_t
ACE_OS::read (ACE_HANDLE handle, void *buf, size_t len,
              ACE_OVERLAPPED *overlapped)
{
  // ACE_TRACE ("ACE_OS::read");
  overlapped = overlapped;
#if defined (ACE_WIN32)
  DWORD ok_len;
  return ::ReadFile (handle, buf, len, &ok_len, overlapped) ? (ssize_t) ok_len : -1;
#else
  return ACE_OS::read (handle, buf, len);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::getmsg (ACE_HANDLE handle,
                struct strbuf *ctl,
                struct strbuf *data,
                int *flags)
{
  // ACE_TRACE ("ACE_OS::getmsg");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::getmsg (handle, ctl, data, flags), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (ctl);
  ACE_UNUSED_ARG (data);
  ACE_UNUSED_ARG (flags);

  // I'm not sure how to implement this correctly.
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::getpmsg (ACE_HANDLE handle,
                 struct strbuf *ctl,
                 struct strbuf *data,
                 int *band,
                 int *flags)
{
  // ACE_TRACE ("ACE_OS::getpmsg");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::getpmsg (handle, ctl, data, band, flags), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (ctl);
  ACE_UNUSED_ARG (data);
  ACE_UNUSED_ARG (band);
  ACE_UNUSED_ARG (flags);

  // I'm not sure how to implement this correctly.
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::getrusage (int who, struct rusage *ru)
{
  // ACE_TRACE ("ACE_OS::getrusage");

#if defined (ACE_HAS_SYSCALL_GETRUSAGE)
  // This nonsense is necessary for HP/UX...
  ACE_OSCALL_RETURN (::syscall (SYS_GETRUSAGE, who, ru), int, -1);
#elif defined (ACE_HAS_GETRUSAGE)
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (who);

  FILETIME dummy_1, dummy_2;
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::GetProcessTimes (::GetCurrentProcess(),
                                                          &dummy_1,   // start
                                                          &dummy_2,     // exited
                                                          &ru->ru_stime,
                                                          &ru->ru_utime),
                                       ace_result_),
                     int, -1);
#else
  ACE_OSCALL_RETURN (::getrusage (who, ru), int, -1);
#endif /* ACE_WIN32 */
#else
  who = who;
  ru = ru;
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSCALL_GETRUSAGE */
}

ACE_INLINE int
ACE_OS::isastream (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::isastream");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::isastream (handle), int, -1);
#else
  ACE_UNUSED_ARG (handle);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE void *
ACE_OS::mmap (void *addr,
              size_t len,
              int prot,
              int flags,
              ACE_HANDLE file_handle,
              off_t off,
              ACE_HANDLE *file_mapping,
              LPSECURITY_ATTRIBUTES sa)
{
  // ACE_TRACE ("ACE_OS::mmap");
#if defined (ACE_WIN32)
  int nt_flags = 0;
  ACE_HANDLE local_handle = ACE_INVALID_HANDLE;

  // Ensure that file_mapping is non-zero.
  if (file_mapping == 0)
    file_mapping = &local_handle;

  if (ACE_BIT_ENABLED (flags, MAP_PRIVATE))
    {
      prot = PAGE_WRITECOPY;
      nt_flags = FILE_MAP_COPY;
    }
  else if (ACE_BIT_ENABLED (flags, MAP_SHARED))
    {
      if (ACE_BIT_ENABLED (prot, PAGE_READONLY))
        nt_flags = FILE_MAP_READ;
      if (ACE_BIT_ENABLED (prot, PAGE_READWRITE))
        nt_flags = FILE_MAP_WRITE;
    }

  // Only create a new handle if we didn't have a valid one passed in.
  if (*file_mapping == ACE_INVALID_HANDLE)
    *file_mapping = ::CreateFileMapping (file_handle, sa,
                                         prot, 0, len, 0);
  if (*file_mapping == 0)
    ACE_FAIL_RETURN (MAP_FAILED);

  void *addr_mapping = ::MapViewOfFileEx (*file_mapping, nt_flags, 0,
                                          off, len, addr);

  // Only close this down if we used the temporary.
  if (file_mapping == &local_handle)
    ::CloseHandle (*file_mapping);

  if (addr_mapping == 0)
    ACE_FAIL_RETURN (MAP_FAILED);

  else if (ACE_BIT_ENABLED (flags, MAP_FIXED)
           && addr_mapping != addr)
    {
      errno = EINVAL;
      return MAP_FAILED;
    }
  else
    return addr_mapping;
#elif !defined (ACE_LACKS_MMAP)
  ACE_UNUSED_ARG (sa);
  file_mapping = file_mapping;
  ACE_OSCALL_RETURN ((void *) ::mmap ((ACE_MMAP_TYPE) addr, len,
                                      prot, flags, file_handle, off),
                     void *, MAP_FAILED);
#else
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (prot);
  ACE_UNUSED_ARG (flags);
  ACE_UNUSED_ARG (file_handle);
  ACE_UNUSED_ARG (off);
  ACE_UNUSED_ARG (file_mapping);
  ACE_UNUSED_ARG (sa);
  ACE_NOTSUP_RETURN (MAP_FAILED);
#endif /*ACE_WIN32 */
}

// Implements simple read/write control for pages.  Affects a page if
// part of the page is referenced.  Currently PROT_READ, PROT_WRITE,
// and PROT_RDWR has been mapped in OS.h.  This needn't have anything
// to do with a mmap region.

ACE_INLINE int
ACE_OS::mprotect (void *addr, size_t len, int prot)
{
  // ACE_TRACE ("ACE_OS::mprotect");
#if defined (ACE_WIN32)
  DWORD dummy; // Sigh!
  return ::VirtualProtect(addr, len, prot, &dummy) ? 0 : -1;
#elif !defined (ACE_LACKS_MPROTECT)
  ACE_OSCALL_RETURN (::mprotect ((ACE_MMAP_TYPE) addr, len, prot), int, -1);
#else
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (prot);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::msync (void *addr, size_t len, int sync)
{
  // ACE_TRACE ("ACE_OS::msync");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (sync);

  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::FlushViewOfFile (addr, len), ace_result_), int, -1);
#elif !defined (ACE_LACKS_MSYNC)
  ACE_OSCALL_RETURN (::msync ((ACE_MMAP_TYPE) addr, len, sync), int, -1);
#else
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (sync);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::munmap (void *addr, size_t len)
{
  // ACE_TRACE ("ACE_OS::munmap");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (len);

  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::UnmapViewOfFile (addr), ace_result_), int, -1);
#elif !defined (ACE_LACKS_MMAP)
  ACE_OSCALL_RETURN (::munmap ((ACE_MMAP_TYPE) addr, len), int, -1);
#else
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::madvise (caddr_t addr, size_t len, int advice)
{
  // ACE_TRACE ("ACE_OS::madvise");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (advice);

  ACE_NOTSUP_RETURN (-1);
#elif !defined (ACE_LACKS_MADVISE)
  ACE_OSCALL_RETURN (::madvise (addr, len, advice), int, -1);
#else
  ACE_UNUSED_ARG (addr);
  ACE_UNUSED_ARG (len);
  ACE_UNUSED_ARG (advice);
  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::putmsg (ACE_HANDLE handle, const struct strbuf *ctl,
                const struct strbuf *data, int flags)
{
  // ACE_TRACE ("ACE_OS::putmsg");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::putmsg (handle,
                               (ACE_STRBUF_TYPE) ctl,
                               (ACE_STRBUF_TYPE) data,
                               flags), int, -1);
#else
  ACE_UNUSED_ARG (flags);
  if (ctl == 0 && data == 0)
    {
      errno = EINVAL;
      return 0;
    }
  // Handle the two easy cases.
  else if (ctl != 0)
    return ACE_OS::write (handle, ctl->buf, ctl->len);
  else if (data != 0)
    return ACE_OS::write (handle, data->buf, data->len);
  else
    {
      // This is the hard case.
      char *buf;
      ACE_NEW_RETURN (buf, char [ctl->len + data->len], -1);
      ACE_OS::memcpy (buf, ctl->buf, ctl->len);
      ACE_OS::memcpy (buf + ctl->len, data->buf, data->len);
      int result = ACE_OS::write (handle, buf, ctl->len + data->len);
      delete [] buf;
      return result;
    }
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::putpmsg (ACE_HANDLE handle,
                 const struct strbuf *ctl,
                 const struct strbuf *data,
                 int band,
                 int flags)
{
  // ACE_TRACE ("ACE_OS::putpmsg");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::putpmsg (handle,
                                (ACE_STRBUF_TYPE) ctl,
                                (ACE_STRBUF_TYPE) data,
                                band, flags), int, -1);
#else
  ACE_UNUSED_ARG (flags);
  ACE_UNUSED_ARG (band);
  return ACE_OS::putmsg (handle, ctl, data, flags);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::semctl (int int_id, int semnum, int cmd, semun value)
{
  // ACE_TRACE ("ACE_OS::semctl");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::semctl (int_id, semnum, cmd, value), int, -1);
#else
  ACE_UNUSED_ARG (int_id);
  ACE_UNUSED_ARG (semnum);
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (value);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::semget (key_t key, int nsems, int flags)
{
  // ACE_TRACE ("ACE_OS::semget");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::semget (key, nsems, flags), int, -1);
#else
  ACE_UNUSED_ARG (key);
  ACE_UNUSED_ARG (nsems);
  ACE_UNUSED_ARG (flags);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::semop (int int_id, struct sembuf *sops, size_t nsops)
{
  // ACE_TRACE ("ACE_OS::semop");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::semop (int_id, sops, nsops), int, -1);
#else
  ACE_UNUSED_ARG (int_id);
  ACE_UNUSED_ARG (sops);
  ACE_UNUSED_ARG (nsops);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE void *
ACE_OS::shmat (int int_id, void *shmaddr, int shmflg)
{
  // ACE_TRACE ("ACE_OS::shmat");
#if defined (ACE_HAS_SYSV_IPC)
#if defined (ACE_LACKS_POSIX_PROTOTYPES) || defined (ACE_LACKS_SOME_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::shmat (int_id, (char *)shmaddr, shmflg), void *, (void *) -1);
#else
  ACE_OSCALL_RETURN (::shmat (int_id, shmaddr, shmflg), void *, (void *) -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#else
  ACE_UNUSED_ARG (int_id);
  ACE_UNUSED_ARG (shmaddr);
  ACE_UNUSED_ARG (shmflg);

  ACE_NOTSUP_RETURN ((void *) -1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::shmctl (int int_id, int cmd, struct shmid_ds *buf)
{
  // ACE_TRACE ("ACE_OS::shmctl");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::shmctl (int_id, cmd, buf), int, -1);
#else
  ACE_UNUSED_ARG (buf);
  ACE_UNUSED_ARG (cmd);
  ACE_UNUSED_ARG (int_id);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::shmdt (void *shmaddr)
{
  // ACE_TRACE ("ACE_OS::shmdt");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::shmdt ((char *) shmaddr), int, -1);
#else
  ACE_UNUSED_ARG (shmaddr);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE int
ACE_OS::shmget (key_t key, int size, int flags)
{
  // ACE_TRACE ("ACE_OS::shmget");
#if defined (ACE_HAS_SYSV_IPC)
  ACE_OSCALL_RETURN (::shmget (key, size, flags), int, -1);
#else
  ACE_UNUSED_ARG (flags);
  ACE_UNUSED_ARG (size);
  ACE_UNUSED_ARG (key);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_SYSV_IPC */
}

ACE_INLINE ACE_HANDLE
ACE_OS::open (const char *filename,
              int mode,
              int perms,
              LPSECURITY_ATTRIBUTES sa)
{
  // ACE_TRACE ("ACE_OS::open");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (perms);
  // Warning: This function ignores _O_APPEND

  DWORD access = GENERIC_READ;
  if (ACE_BIT_ENABLED (mode, O_WRONLY))
    access = GENERIC_WRITE;
  else if (ACE_BIT_ENABLED (mode, O_RDWR))
    access = GENERIC_READ | GENERIC_WRITE;

  DWORD creation = OPEN_EXISTING;

  if ((mode & (_O_CREAT | _O_EXCL)) == (_O_CREAT | _O_EXCL))
    creation = CREATE_NEW;
  else if ((mode & (_O_CREAT | _O_TRUNC)) == (_O_CREAT | _O_TRUNC))
    creation = CREATE_ALWAYS;
  else if (ACE_BIT_ENABLED (mode, _O_CREAT))
    creation = OPEN_ALWAYS;
  else if (ACE_BIT_ENABLED (mode, _O_TRUNC))
    creation = TRUNCATE_EXISTING;

  DWORD flags = 0;

  if (ACE_BIT_ENABLED (mode, _O_TEMPORARY))
    flags |= FILE_FLAG_DELETE_ON_CLOSE;

  if (ACE_BIT_ENABLED (mode, FILE_FLAG_WRITE_THROUGH))
    flags |= FILE_FLAG_WRITE_THROUGH;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_OVERLAPPED))
    flags |= FILE_FLAG_OVERLAPPED;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_NO_BUFFERING))
    flags |= FILE_FLAG_NO_BUFFERING;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_RANDOM_ACCESS))
    flags |= FILE_FLAG_RANDOM_ACCESS;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_SEQUENTIAL_SCAN))
    flags |= FILE_FLAG_SEQUENTIAL_SCAN;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_DELETE_ON_CLOSE))
    flags |= FILE_FLAG_DELETE_ON_CLOSE;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_BACKUP_SEMANTICS))
    flags |= FILE_FLAG_BACKUP_SEMANTICS;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_POSIX_SEMANTICS))
    flags |= FILE_FLAG_POSIX_SEMANTICS;

  ACE_HANDLE h = ::CreateFileA (filename, access,
                                FILE_SHARE_READ | FILE_SHARE_WRITE,
                                sa, creation,
                                flags,
                                0);

  if (h == ACE_INVALID_HANDLE)
    ACE_FAIL_RETURN (h);
  else
    return h;
#else
  ACE_UNUSED_ARG (sa);
  ACE_OSCALL_RETURN (::open (filename, mode, perms), ACE_HANDLE, -1);
#endif /* ACE_WIN32 */
}


ACE_INLINE double
ACE_OS::difftime (time_t t1, time_t t0)
{
#if defined (ACE_DIFFTIME)
  return ACE_DIFFTIME (t1, t0);
#else
  return ::difftime (t1, t0);
#endif /* ACE_DIFFTIME */
}


ACE_INLINE char *
ACE_OS::ctime (const time_t *t)
{
  // ACE_TRACE ("ACE_OS::ctime");
#if defined (ACE_HAS_BROKEN_CTIME)
  ACE_OSCALL_RETURN (::asctime (::localtime (t)), char *, 0);
#else
  ACE_OSCALL_RETURN (::ctime (t), char *, 0);
#endif    /* ACE_HAS_BROKEN_CTIME) */
}

ACE_INLINE char *
ACE_OS::ctime_r (const time_t *t, char *buf, int buflen)
{
  // ACE_TRACE ("ACE_OS::ctime_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if defined (ACE_HAS_2_PARAM_ASCTIME_R_AND_CTIME_R)
  char *result;
#if defined (DIGITAL_UNIX)
  ACE_OSCALL (::_Pctime_r (t, buf), char *, 0, result);
#else
  ACE_OSCALL (::ctime_r (t, buf), char *, 0, result);
#endif /* DIGITAL_UNIX */
  ::strncpy (buf, result, buflen);
  return buf;
#else

# if defined (ACE_CTIME_R_RETURNS_INT)
  return (::ctime_r(t, buf, buflen) == -1 ? 0 : buf);
# else
  ACE_OSCALL_RETURN (::ctime_r (t, buf, buflen), char *, 0);
# endif /* ACE_CTIME_R_RETURNS_INT */

#endif /* defined (ACE_HAS_2_PARAM_ASCTIME_R_AND_CTIME_R) */
#else
  char *result;
  ACE_OSCALL (::ctime (t), char *, 0, result);
  ::strncpy (buf, result, buflen);
  return buf;
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) */
}

ACE_INLINE struct tm *
ACE_OS::localtime (const time_t *t)
{
  // ACE_TRACE ("ACE_OS::localtime");
  ACE_OSCALL_RETURN (::localtime (t), struct tm *, 0);
}

ACE_INLINE struct tm *
ACE_OS::localtime_r (const time_t *t, struct tm *res)
{
  // ACE_TRACE ("ACE_OS::localtime_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if defined (DIGITAL_UNIX)
  ACE_OSCALL_RETURN (::_Plocaltime_r(t, res), struct tm *, 0);
#elif defined (HPUX_10)
  return (::localtime_r(t, res) == 0 ? res : (struct tm *)0);
#else
  ACE_OSCALL_RETURN (::localtime_r (t, res), struct tm *, 0);
#endif /* DIGITAL_UNIX */
#else
  ACE_UNUSED_ARG (res);

  ACE_OSCALL_RETURN (::localtime (t), struct tm *, 0);
#endif /* ACE_HAS_REENTRANT_FUNCTIONS */
}

ACE_INLINE struct tm *
ACE_OS::gmtime (const time_t *t)
{
  // ACE_TRACE ("ACE_OS::localtime");
  ACE_OSCALL_RETURN (::gmtime (t), struct tm *, 0);
}

ACE_INLINE struct tm *
ACE_OS::gmtime_r (const time_t *t, struct tm *res)
{
  // ACE_TRACE ("ACE_OS::localtime_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if defined (DIGITAL_UNIX)
  ACE_OSCALL_RETURN (::_Pgmtime_r (t, res), struct tm *, 0);
#elif defined (HPUX_10)
  return (::gmtime_r (t, res) == 0 ? res : (struct tm *) 0);
#else
  ACE_OSCALL_RETURN (::gmtime_r (t, res), struct tm *, 0);
#endif /* DIGITAL_UNIX */
#else
  struct tm *result;
  ACE_OSCALL (::gmtime (t), struct tm *, 0, result) ;
  if (result != 0)
    *res = *result ;
  return result ;
#endif /* ACE_HAS_REENTRANT_FUNCTIONS */
}

ACE_INLINE char *
ACE_OS::asctime (const struct tm *t)
{
  // ACE_TRACE ("ACE_OS::asctime");
  ACE_OSCALL_RETURN (::asctime (t), char *, 0);
}

ACE_INLINE char *
ACE_OS::asctime_r (const struct tm *t, char *buf, int buflen)
{
  // ACE_TRACE ("ACE_OS::asctime_r");
#if defined (ACE_HAS_REENTRANT_FUNCTIONS)
#if defined (ACE_HAS_2_PARAM_ASCTIME_R_AND_CTIME_R)
  char *result;
#if defined (DIGITAL_UNIX)
  ACE_OSCALL (::_Pasctime_r (t, buf), char *, 0, result);
#else
  ACE_OSCALL (::asctime_r (t, buf), char *, 0, result);
#endif /* DIGITAL_UNIX */
  ::strncpy (buf, result, buflen);
  return buf;
#else
# if defined (HPUX_10)
  return (::asctime_r(t, buf, buflen) == 0 ? buf : (char *)0);
# else
  ACE_OSCALL_RETURN (::asctime_r (t, buf, buflen), char *, 0);
# endif /* HPUX_10 */
#endif /* ACE_HAS_2_PARAM_ASCTIME_R_AND_CTIME_R */
#else
  char *result;
  ACE_OSCALL (::asctime (t), char *, 0, result);
  ::strncpy (buf, result, buflen);
  return buf;
#endif /* defined (ACE_HAS_REENTRANT_FUNCTIONS) */
}

ACE_INLINE size_t
ACE_OS::strftime (char *s, size_t maxsize, const char *format,
                  const struct tm *timeptr)
{
  return ::strftime (s, maxsize, format, timeptr);
}

ACE_INLINE int
ACE_OS::flock_init (ACE_OS::ace_flock_t *lock,
                    int flags,
                    LPCTSTR name,
                    mode_t perms)
{
  // ACE_TRACE ("ACE_OS::flock_init");
#if defined (ACE_WIN32)
  // Once initialized, these values are never changed.
  lock->overlapped_.Internal = 0;
  lock->overlapped_.InternalHigh = 0;
  lock->overlapped_.OffsetHigh = 0;
  lock->overlapped_.hEvent = INVALID_HANDLE_VALUE;
#endif /* ACE_WIN32 */
  lock->handle_ = ACE_INVALID_HANDLE;

  if (name != 0)
    {
      ACE_OSCALL (ACE_OS::open (name, flags, perms),
                  ACE_HANDLE,
                  ACE_INVALID_HANDLE,
                  lock->handle_);
      return lock->handle_ == ACE_INVALID_HANDLE ? -1 : 0;
    }
  else
    return 0;
}

ACE_INLINE int
ACE_OS::flock_wrlock (ACE_OS::ace_flock_t *lock, short whence, off_t start, off_t len)
{
  // ACE_TRACE ("ACE_OS::flock_wrlock");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (whence);
  lock->overlapped_.Offset = start;
  if (len == 0)
    len = ::GetFileSize (lock->handle_, NULL);
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::LockFileEx (lock->handle_, LOCKFILE_EXCLUSIVE_LOCK, 0, len, 0, &lock->overlapped_),
                                       ace_result_), int, -1);
#elif defined (ACE_LACKS_FILELOCKS)
  ACE_UNUSED_ARG (lock);
  ACE_UNUSED_ARG (whence);
  ACE_UNUSED_ARG (start);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#else
  lock->lock_.l_whence = whence;
  lock->lock_.l_start = start;
  lock->lock_.l_len = len;
  lock->lock_.l_type = F_WRLCK;         // set write lock
  // block, if no access
  ACE_OSCALL_RETURN (::fcntl (lock->handle_, F_SETLKW, &lock->lock_), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::flock_rdlock (ACE_OS::ace_flock_t *lock, short whence, off_t start, off_t len)
{
  // ACE_TRACE ("ACE_OS::flock_rdlock");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (whence);
  lock->overlapped_.Offset = start;
  if (len == 0)
    len = ::GetFileSize (lock->handle_, NULL);
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::LockFileEx (lock->handle_, 0, 0, len, 0, &lock->overlapped_),
                                       ace_result_), int, -1);
#elif defined (ACE_LACKS_FILELOCKS)
  ACE_UNUSED_ARG (lock);
  ACE_UNUSED_ARG (whence);
  ACE_UNUSED_ARG (start);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#else
  lock->lock_.l_whence = whence;
  lock->lock_.l_start = start;
  lock->lock_.l_len = len;
  lock->lock_.l_type = F_RDLCK;         // set read lock
  // block, if no access
  ACE_OSCALL_RETURN (::fcntl (lock->handle_, F_SETLKW, &lock->lock_), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::flock_trywrlock (ACE_OS::ace_flock_t *lock, short whence, off_t start, off_t len)
{
  // ACE_TRACE ("ACE_OS::ace_flock_trywrlock");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (whence);
  lock->overlapped_.Offset = start;
  if (len == 0)
    len = ::GetFileSize (lock->handle_, NULL);
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::LockFileEx (lock->handle_, LOCKFILE_FAIL_IMMEDIATELY | LOCKFILE_EXCLUSIVE_LOCK, 0, len, 0, &lock->overlapped_),
                                       ace_result_), int, -1);
#elif defined (ACE_LACKS_FILELOCKS)
  ACE_UNUSED_ARG (lock);
  ACE_UNUSED_ARG (whence);
  ACE_UNUSED_ARG (start);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#else
  lock->lock_.l_whence = whence;
  lock->lock_.l_start = start;
  lock->lock_.l_len = len;
  lock->lock_.l_type = F_WRLCK;         // set write lock

  int result = 0;
  // Does not block, if no access, returns -1 and set errno = EBUSY;
  ACE_OSCALL (::fcntl (lock->handle_, F_SETLK, &lock->lock_), int, -1, result);

  if (result == -1 && (errno == EACCES || errno == EAGAIN))
    errno = EBUSY;

  return result;
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::flock_tryrdlock (ACE_OS::ace_flock_t *lock, short whence, off_t start, off_t len)
{
  // ACE_TRACE ("ACE_OS::ace_flock_tryrdlock");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (whence);
  lock->overlapped_.Offset = start;
  if (len == 0)
    len = ::GetFileSize (lock->handle_, NULL);
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::LockFileEx (lock->handle_, LOCKFILE_FAIL_IMMEDIATELY, 0, len, 0, &lock->overlapped_),
                                       ace_result_), int, -1);
#elif defined (ACE_LACKS_FILELOCKS)
  ACE_UNUSED_ARG (lock);
  ACE_UNUSED_ARG (whence);
  ACE_UNUSED_ARG (start);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#else
  lock->lock_.l_whence = whence;
  lock->lock_.l_start = start;
  lock->lock_.l_len = len;
  lock->lock_.l_type = F_RDLCK;         // set read lock

  int result = 0;
  // Does not block, if no access, returns -1 and set errno = EBUSY;
  ACE_OSCALL (::fcntl (lock->handle_, F_SETLK, &lock->lock_), int, -1, result);

  if (result == -1 && (errno == EACCES || errno == EAGAIN))
    errno = EBUSY;

  return result;
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::flock_unlock (ACE_OS::ace_flock_t *lock, short whence, off_t start, off_t len)
{
  // ACE_TRACE ("ACE_OS::flock_unlock");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (whence);
  lock->overlapped_.Offset = start;
  if (len == 0)
    len = ::GetFileSize (lock->handle_, NULL);
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::UnlockFileEx (lock->handle_, 0, len, 0, &lock->overlapped_),
                                       ace_result_), int, -1);
#elif defined (ACE_LACKS_FILELOCKS)
  ACE_UNUSED_ARG (lock);
  ACE_UNUSED_ARG (whence);
  ACE_UNUSED_ARG (start);
  ACE_UNUSED_ARG (len);
  ACE_NOTSUP_RETURN (-1);
#else
  lock->lock_.l_whence = whence;
  lock->lock_.l_start = start;
  lock->lock_.l_len = len;
  lock->lock_.l_type = F_UNLCK;   // Unlock file.

  // release lock
  ACE_OSCALL_RETURN (::fcntl (lock->handle_, F_SETLK, &lock->lock_), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::flock_destroy (ACE_OS::ace_flock_t *lock)
{
  // ACE_TRACE ("ACE_OS::flock_destroy");
  if (lock->handle_ != ACE_INVALID_HANDLE)
    {
      ACE_OS::flock_unlock (lock);
      ACE_OS::close (lock->handle_);
      lock->handle_ = ACE_INVALID_HANDLE;
    }
  return 0;
}

ACE_INLINE int
ACE_OS::execv (const char *path, char *const argv[])
{
  // ACE_TRACE ("ACE_OS::execv");
#if defined (ACE_LACKS_EXEC)
  ACE_UNUSED_ARG (path);
  ACE_UNUSED_ARG (argv);

  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_WIN32)
  return ::_execv (path, (const char *const *) argv);
#elif defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::execv (path, (const char **) argv), int, -1);
#else
  ACE_OSCALL_RETURN (::execv (path, argv), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::execve (const char *path, char *const argv[], char *const envp[])
{
  // ACE_TRACE ("ACE_OS::execve");
#if defined (ACE_LACKS_EXEC)
  ACE_UNUSED_ARG (path);
  ACE_UNUSED_ARG (argv);
  ACE_UNUSED_ARG (envp);

  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_WIN32)
  return ::_execve (path, (const char *const *) argv, (const char *const *) envp);
#elif defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::execve (path, (const char **) argv, (char **) envp), int, -1);
#else
  ACE_OSCALL_RETURN (::execve (path, argv, envp), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::execvp (const char *file, char *const argv[])
{
  // ACE_TRACE ("ACE_OS::execvp");
#if defined (ACE_LACKS_EXEC)
  ACE_UNUSED_ARG (file);
  ACE_UNUSED_ARG (argv);

  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_WIN32)
  return ::_execvp (file, (const char *const *) argv);
#elif defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::execvp (file, (const char **) argv), int, -1);
#else
  ACE_OSCALL_RETURN (::execvp (file, argv), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE FILE *
ACE_OS::fdopen (ACE_HANDLE handle, const char *mode)
{
  // ACE_TRACE ("ACE_OS::fdopen");
#if defined (ACE_WIN32)
  // kernel file handle -> FILE* conversion...
  // Options: _O_APPEND, _O_RDONLY and _O_TEXT are lost

  FILE *file = 0;

  int crt_handle = ::_open_osfhandle ((long) handle, 0);

  if (crt_handle != -1)
    {
      file = ::_fdopen (crt_handle, mode);

      if (!file)
        ::_close (crt_handle);
    }

  return file;
#else
  ACE_OSCALL_RETURN (::fdopen (handle, mode), FILE *, 0);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::ftruncate (ACE_HANDLE handle, off_t offset)
{
  // ACE_TRACE ("ACE_OS::ftruncate");
#if defined (ACE_WIN32)
  if (::SetFilePointer (handle, offset, NULL, FILE_BEGIN) != -1)
    ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::SetEndOfFile (handle), ace_result_), int, -1);
  else
    ACE_FAIL_RETURN (-1);
  /* NOTREACHED */
#else
  ACE_OSCALL_RETURN (::ftruncate (handle, offset), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::getrlimit (int resource, struct rlimit *rl)
{
  // ACE_TRACE ("ACE_OS::getrlimit");

#if defined (ACE_WIN32) || defined (ACE_LACKS_RLIMIT)
  ACE_UNUSED_ARG (resource);
  ACE_UNUSED_ARG (rl);

  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::getrlimit (resource, rl), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::setrlimit (int resource, ACE_SETRLIMIT_TYPE *rl)
{
  // ACE_TRACE ("ACE_OS::setrlimit");

#if defined (ACE_WIN32) || defined (ACE_LACKS_RLIMIT)
  ACE_UNUSED_ARG (resource);
  ACE_UNUSED_ARG (rl);

  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::setrlimit (resource, rl), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::socketpair (int domain, int type,
                    int protocol, ACE_HANDLE sv[2])
{
  // ACE_TRACE ("ACE_OS::socketpair");
#if defined (ACE_WIN32) || defined (ACE_LACKS_SOCKETPAIR)
  ACE_UNUSED_ARG (domain);
  ACE_UNUSED_ARG (type);
  ACE_UNUSED_ARG (protocol);
  ACE_UNUSED_ARG (sv);

  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::socketpair (domain, type, protocol, sv),
                     int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE ACE_HANDLE
ACE_OS::dup (ACE_HANDLE handle)
{
  // ACE_TRACE ("ACE_OS::dup");
#if defined (ACE_WIN32)
  ACE_HANDLE new_fd;
  if (::DuplicateHandle(::GetCurrentProcess (),
                        handle,
                        ::GetCurrentProcess(),
                        &new_fd,
                        0,
                        TRUE,
                        DUPLICATE_SAME_ACCESS))
    return new_fd;
  else
    ACE_FAIL_RETURN (ACE_INVALID_HANDLE);
  /* NOTREACHED */
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (handle);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::dup (handle), ACE_HANDLE, ACE_INVALID_HANDLE);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::dup2 (ACE_HANDLE oldhandle, ACE_HANDLE newhandle)
{
  // ACE_TRACE ("ACE_OS::dup2");
#if defined (ACE_WIN32) || defined (VXWORKS)
  // msvcrt has _dup2 ?!
  ACE_UNUSED_ARG (oldhandle);
  ACE_UNUSED_ARG (newhandle);

  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::dup2 (oldhandle, newhandle), int, -1);
#endif /* ACE_WIN32 */
}

#if ! defined (ACE_WIN32) && ! defined (ACE_HAS_LONGLONG_T)
ACE_INLINE
ACE_U_LongLong::ACE_U_LongLong (const u_long lo, const u_long hi)
  : hi_ (hi), lo_ (lo)
{
}

ACE_INLINE u_long
ACE_U_LongLong::hi (void) const
{
  return hi_;
}

ACE_INLINE u_long
ACE_U_LongLong::lo (void) const
{
  return lo_;
}

ACE_INLINE void
ACE_U_LongLong::hi (const u_long hi)
{
  hi_ = hi;
}

ACE_INLINE void
ACE_U_LongLong::lo (const u_long lo)
{
  lo_ = lo;
}

ACE_INLINE
ACE_U_LongLong::~ACE_U_LongLong (void)
{
}

ACE_INLINE int
ACE_U_LongLong::operator== (const ACE_U_LongLong &ll) const
{
  return hi_ == ll.hi_  &&  lo_ == ll.lo_;
}

ACE_INLINE int
ACE_U_LongLong::operator!= (const ACE_U_LongLong &ll) const
{
  return ! (*this == ll);
}

ACE_INLINE int
ACE_U_LongLong::operator< (const ACE_U_LongLong &ll) const
{
  return hi_ < ll.hi_ ? 1
                      : hi_ > ll.hi_ ? 0
                                     : lo_ < ll.lo_;
}

ACE_INLINE int
ACE_U_LongLong::operator<= (const ACE_U_LongLong &ll) const
{
  return hi_ < ll.hi_ ? 1
                      : hi_ > ll.hi_ ? 0
                                     : lo_ <= ll.lo_;
}

ACE_INLINE int
ACE_U_LongLong::operator> (const ACE_U_LongLong &ll) const
{
  return hi_ > ll.hi_ ? 1
                      : hi_ < ll.hi_ ? 0
                                     : lo_ > ll.lo_;
}

ACE_INLINE int
ACE_U_LongLong::operator>= (const ACE_U_LongLong &ll) const
{
  return hi_ > ll.hi_ ? 1
                      : hi_ < ll.hi_ ? 0
                                     : lo_ >= ll.lo_;
}

ACE_INLINE
ACE_U_LongLong::ACE_U_LongLong (const ACE_U_LongLong &ll)
  : hi_ (ll.hi_),
    lo_ (ll.lo_)
{
}

ACE_INLINE ACE_U_LongLong &
ACE_U_LongLong::operator= (const ACE_U_LongLong &ll)
{
  hi_ = ll.hi_;
  lo_ = ll.lo_;
  return *this;
}

ACE_INLINE ACE_U_LongLong
ACE_U_LongLong::operator+ (const ACE_U_LongLong &ll) const
{
  ACE_U_LongLong ret (lo_ + ll.lo_, hi_ + ll.hi_);
  if (ret.lo_ < ll.lo_) /* carry */ ++ret.hi_;
  return ret;
}

ACE_INLINE ACE_U_LongLong
ACE_U_LongLong::operator- (const ACE_U_LongLong &ll) const
{
  ACE_U_LongLong ret (lo_ - ll.lo_, hi_ - ll.hi_);
  if (lo_ < ll.lo_) /* borrow */ --ret.hi_;
  return ret;
}

ACE_INLINE u_long
ACE_U_LongLong::operator/ (const u_long ul) const
{
  return hi_ / ul * ULONG_MAX + lo_ / ul;
}

ACE_INLINE ACE_U_LongLong &
ACE_U_LongLong::operator+= (const ACE_U_LongLong &ll)
{
  hi_ += ll.hi_;
  lo_ += ll.lo_;
  if (lo_ < ll.lo_) /* carry */ ++hi_;
  return *this;
}

ACE_INLINE ACE_U_LongLong &
ACE_U_LongLong::operator-= (const ACE_U_LongLong &ll)
{
  hi_ -= ll.hi_;
  if (lo_ < ll.lo_) /* borrow */ --hi_;
  lo_ -= ll.lo_;
  return *this;
}
#endif /* ! ACE_WIN32 && ! ACE_HAS_LONGLONG_T */

ACE_INLINE ACE_hrtime_t
ACE_OS::gethrtime (void)
{
  // ACE_TRACE ("ACE_OS::gethrtime");
#if defined (ACE_HAS_HI_RES_TIMER)
  return ::gethrtime ();
#elif defined (ACE_HAS_AIX_HI_RES_TIMER)
  timebasestruct_t tb;

  ::read_real_time(&tb, TIMEBASE_SZ);
  ::time_base_to_time(&tb, TIMEBASE_SZ);

  return tb.tb_high * ACE_ONE_SECOND_IN_NSECS + tb.tb_low;
#elif defined (linux)
# if defined (ACE_HAS_PENTIUM)
  ACE_hrtime_t now;

  // See comments about the RDTSC Pentium instruction for the ACE_WIN32
  // version of ACE_OS::gethrtime (), below.
  //
  // Read the high-res tick counter directly into memory variable "now".
  // The A constraint signifies a 64-bit int.
  asm volatile ("rdtsc" : "=A" (now) : : "memory");

  return now;
# elif defined (__alpha)
  ACE_hrtime_t now;

  // The following statement is based on code published by:
  // Mosberger, David, "How to Make Your Applications Fly, Part 1",
  // Linux Journal Issue 42, October 1997, page 50.
  // It reads the high-res tick counter directly into memory variable "now".
  asm volatile ("rpcc %0" : "=r" (now) : : "memory");

  return now;
# else
  const ACE_Time_Value now = ACE_OS::gettimeofday ();
  return now.msec () * 1000000L /* Turn millseconds into nanoseconds */;
# endif /* ACE_HAS_PENTIUM || __alpha */
#elif defined (ACE_WIN32) && defined (ACE_HAS_PENTIUM)
  // Issue the RDTSC assembler instruction to get the number of clock
  // ticks since system boot.  RDTSC is only available on Pentiums and
  // higher.  Thanks to Wayne Vucenic <wvucenic@netgate.net> for
  // pointing us to intel's RDTSC instruction.  See
  // http://www.sandpile.org/80x86/rdtsc.shtml for a description of
  // the RDTSC instruction.  Or see Frank van Gilluwe's "The
  // Undocumented PC" published by Adisson Wesley Developers Press.

  unsigned long least;
  unsigned long most;

  __asm {
    //      __asm               rdtsc
    // VC++ doesn't know the opcode for rdtsc (OFh, 31h), so we'll
    // emit the opcode manually.
      __asm             _emit           0xf
      __asm             _emit           0x31
      __asm             mov             least,eax
      __asm             mov             most,edx
      }

  return ACE_MAKE_QWORD (least, most);
#elif defined (ACE_HAS_POWERPC) && defined (ghs)
  // PowerPC w/ GreenHills compiler on VxWorks

  u_long most;
  u_long least;
  ACE_OS::readPPCTimeBase (most, least);
  return ACE_U_LongLong (least, most);

#elif defined (ACE_HAS_CLOCK_GETTIME)
  // e.g., VxWorks (besides POWERPC && GreenHills) . . .
  struct timespec ts;

  ACE_OS::clock_gettime (CLOCK_REALTIME, &ts);

  return ts.tv_sec * ACE_ONE_SECOND_IN_NSECS + ts.tv_nsec;
#else
  const ACE_Time_Value now = ACE_OS::gettimeofday ();
  return now.msec () * 1000000L /* Turn millseconds into nanoseconds */;
#endif /* ACE_HAS_HI_RES_TIMER */
}

ACE_INLINE int
ACE_OS::fdetach (const char *file)
{
  // ACE_TRACE ("ACE_OS::fdetach");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::fdetach (file), int, -1);
#else
  ACE_UNUSED_ARG (file);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE int
ACE_OS::fattach (int handle, const char *path)
{
  // ACE_TRACE ("ACE_OS::fattach");
#if defined (ACE_HAS_STREAM_PIPES)
  ACE_OSCALL_RETURN (::fattach (handle, path), int, -1);
#else
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (path);

  ACE_NOTSUP_RETURN (-1);
#endif /* ACE_HAS_STREAM_PIPES */
}

ACE_INLINE pid_t
ACE_OS::fork (void)
{
  // ACE_TRACE ("ACE_OS::fork");
#if defined (ACE_LACKS_FORK)
  ACE_NOTSUP_RETURN (pid_t (-1));
#else
  ACE_OSCALL_RETURN (::fork (), pid_t, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE pid_t
ACE_OS::getpid (void)
{
  // ACE_TRACE ("ACE_OS::getpid");
#if defined (ACE_WIN32)
  return ::GetCurrentProcessId ();
#elif defined (VXWORKS)
  // getpid() is not supported:  just one process anyways
  return 0;
#elif defined (CHORUS)
  return (pid_t) (::agetId ());
#else
  ACE_OSCALL_RETURN (::getpid (), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE pid_t
ACE_OS::getpgid (pid_t pid)
{
  // ACE_TRACE ("ACE_OS::getpgid");
#if defined (ACE_LACKS_GETPGID)
  ACE_UNUSED_ARG (pid);
  ACE_NOTSUP_RETURN (-1);
#elif defined (VXWORKS)
  // getpid() is not supported, only one process anyway.
  ACE_UNUSED_ARG (pid);
  return 0;
#else
  ACE_OSCALL_RETURN (::getpgid (pid), pid_t, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE off_t
ACE_OS::lseek (ACE_HANDLE handle, off_t offset, int whence)
{
  // ACE_TRACE ("ACE_OS::lseek");

#if defined (ACE_WIN32)
#if SEEK_SET != FILE_BEGIN || SEEK_CUR != FILE_CURRENT || SEEK_END != FILE_END
#error Windows NT is evil AND rude!
  switch (whence)
    {
    case SEEK_SET:
      whence = FILE_BEGIN;
      break;
    case SEEK_CUR:
      whence = FILE_CURRENT;
      break;
    case SEEK_END:
      whence = FILE_END;
      break;
    default:
      errno = EINVAL;
      return -1; // rather safe than sorry
    }
#endif  /* SEEK_SET != FILE_BEGIN || SEEK_CUR != FILE_CURRENT || SEEK_END != FILE_END */
  DWORD result = ::SetFilePointer (handle, offset, NULL, whence);
  if (result == ACE_SYSCALL_FAILED)
    ACE_FAIL_RETURN (-1);
  else
    return result;
#else
  ACE_OSCALL_RETURN (::lseek (handle, offset, whence), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE pid_t
ACE_OS::wait (int *stat_loc)
{
  // ACE_TRACE ("ACE_OS::wait");
#if defined (ACE_WIN32) || defined (VXWORKS)
  ACE_UNUSED_ARG (stat_loc);

  ACE_NOTSUP_RETURN (0);
#else
#if !defined (AIX)
#if defined (ACE_HAS_UNION_WAIT)
  ACE_OSCALL_RETURN (::wait ((union wait *) stat_loc), pid_t, -1);
#else
  ACE_OSCALL_RETURN (::wait (stat_loc), pid_t, -1);
#endif /* ACE_HAS_UNION_WAIT */
#else
  ACE_OSCALL_RETURN (::wait ((union wait *) stat_loc), pid_t, -1);
#endif /* defined (AIX) */
#endif /* defined (ACE_WIN32) */
}

ACE_INLINE pid_t
ACE_OS::waitpid (pid_t pid, int *stat_loc, int options)
{
  // ACE_TRACE ("ACE_OS::waitpid");
#if defined (ACE_WIN32) || defined (VXWORKS)
  ACE_UNUSED_ARG (pid);
  ACE_UNUSED_ARG (stat_loc);
  ACE_UNUSED_ARG (options);

  ACE_NOTSUP_RETURN (0);
#else
  ACE_OSCALL_RETURN (::waitpid (pid, stat_loc, options),
                     pid_t, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::ioctl (ACE_HANDLE handle, int cmd, void *val)
{
  // ACE_TRACE ("ACE_OS::ioctl");

#if defined (ACE_WIN32)
  ACE_SOCKET sock = (ACE_SOCKET) handle;
  ACE_SOCKCALL_RETURN (::ioctlsocket (sock, cmd, (u_long *) val), int, -1);
#elif defined (VXWORKS)
  // This may not work very well...
  ACE_OSCALL_RETURN (ACE_ADAPT_RETVAL (::ioctl (handle, cmd, (int) val), ace_result_),
                     int, -1);
#else
  ACE_OSCALL_RETURN (::ioctl (handle, cmd, val), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::kill (pid_t pid, int signum)
{
  // ACE_TRACE ("ACE_OS::kill");
#if defined (ACE_WIN32) || defined (CHORUS)
  ACE_UNUSED_ARG (pid);
  ACE_UNUSED_ARG (signum);
  ACE_NOTSUP_RETURN (-1);
#else
  ACE_OSCALL_RETURN (::kill (pid, signum), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::sigaction (int signum,
                   const struct sigaction *nsa,
                   struct sigaction *osa)
{
  // ACE_TRACE ("ACE_OS::sigaction");
#if defined (ACE_WIN32)
  struct sigaction sa;

  if (osa == 0)
    osa = &sa;

  osa->sa_handler = ::signal (signum, nsa->sa_handler);
  return osa->sa_handler == SIG_ERR ? -1 : 0;
#elif defined (CHORUS)
  ACE_NOTSUP_RETURN (-1);
#elif defined (ACE_LACKS_POSIX_PROTOTYPES) || defined(ACE_LACKS_SOME_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::sigaction (signum, (struct sigaction*) nsa, osa), int, -1);
#else
  ACE_OSCALL_RETURN (::sigaction (signum, nsa, osa), int, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
}

ACE_INLINE char *
ACE_OS::getcwd (char *buf, size_t size)
{
  // ACE_TRACE ("ACE_OS::getcwd");
#if defined (ACE_WIN32)
  return ::_getcwd (buf, size);
#else
  ACE_OSCALL_RETURN (::getcwd (buf, size), char *, 0);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::sleep (u_int seconds)
{
  // ACE_TRACE ("ACE_OS::sleep");
#if defined (ACE_WIN32)
  ::Sleep (seconds * ACE_ONE_SECOND_IN_MSECS);
  return 0;
#elif defined (ACE_HAS_CLOCK_GETTIME)
  struct timespec rqtp;
  // Initializer doesn't work with Green Hills 1.8.7
  rqtp.tv_sec = seconds;
  rqtp.tv_nsec = 0L;
  ACE_OSCALL_RETURN (::nanosleep (&rqtp, 0), int, -1);
#else
  ACE_OSCALL_RETURN (::sleep (seconds), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::sleep (const ACE_Time_Value &tv)
{
  // ACE_TRACE ("ACE_OS::sleep");
#if defined (ACE_WIN32)
  ::Sleep (tv.msec ());
  return 0;
#elif defined (ACE_HAS_POLL) && !defined (ACE_POLL_IS_BROKEN)
  ACE_OSCALL_RETURN (::poll (0, 0, tv.msec ()), int, -1);
#else
  ACE_OSCALL_RETURN (::select (0, 0, 0, 0, (timeval *) &tv), int, -1);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::nanosleep (const struct timespec *requested,
                   struct timespec *remaining)
{
  // ACE_TRACE ("ACE_OS::nanosleep");
#if defined (ACE_HAS_CLOCK_GETTIME)
  // ::nanosleep () is POSIX 1003.1b.  So is ::clock_gettime ().  So,
  // if ACE_HAS_CLOCK_GETTIME is defined, then ::nanosleep () should
  // be available on the platform.  On Solaris 2.x, both functions
  // require linking with -lposix4.
  return ::nanosleep ((ACE_TIMESPEC_PTR) requested, remaining);
#else
  ACE_UNUSED_ARG (remaining);

  // Convert into seconds and microseconds.
#if ! defined(ACE_HAS_BROKEN_TIMESPEC_MEMBERS)
  ACE_Time_Value tv (requested->tv_sec,
                     requested->tv_nsec * 1000);
#else
  ACE_Time_Value tv (requested->ts_sec,
                     requested->ts_nsec * 1000);
#endif /* ACE_HAS_BROKEN_TIMESPEC_MEMBERS */
  return ACE_OS::sleep (tv);
#endif /* ACE_HAS_CLOCK_GETTIME */
}

ACE_INLINE int
ACE_OS::mkdir (const char *path, mode_t mode)
{
  // ACE_TRACE ("ACE_OS::mkdir");
#if defined (ACE_WIN32)
  ACE_UNUSED_ARG (mode);

  ACE_OSCALL_RETURN (::_mkdir (path), int, -1);
#elif defined (VXWORKS)
  ACE_UNUSED_ARG (mode);
  ACE_OSCALL_RETURN (::mkdir ((char *) path), int, -1);
#else
  ACE_OSCALL_RETURN (::mkdir (path, mode), int, -1);
#endif /* VXWORKS */
}

ACE_INLINE char *
ACE_OS::getenv (const char *symbol)
{
  // ACE_TRACE ("ACE_OS::getenv");
  ACE_OSCALL_RETURN (::getenv (symbol), char *, 0);
}

ACE_INLINE
ACE_Str_Buf::ACE_Str_Buf (void *b, int l, int max)
{
  this->maxlen = max;
  this->len = l;
  this->buf = (char *) b;
}

ACE_INLINE
ACE_Str_Buf::ACE_Str_Buf (strbuf &sb)
{
  this->maxlen = sb.maxlen;
  this->len = sb.len;
  this->buf = sb.buf;
}

#if defined (ACE_HAS_UNICODE)

ACE_INLINE wchar_t *
ACE_OS::strpbrk (const wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::wcspbrk");
  return ::wcspbrk (s, t);
}

ACE_INLINE wchar_t *
ACE_OS::strcat (wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::strcat");
  return ::wcscat (s, t);
}

ACE_INLINE wchar_t *
ACE_OS::strchr (const wchar_t *s, wint_t c)
{
  // ACE_TRACE ("ACE_OS::strchr");
  return ::wcschr (s, c);
}

ACE_INLINE wchar_t *
ACE_OS::strrchr (const wchar_t *s, wint_t c)
{
  // ACE_TRACE ("ACE_OS::strrchr");
  return ::wcsrchr (s, c);
}

ACE_INLINE int
ACE_OS::strcmp (const wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::strcmp");
  return ::wcscmp (s, t);
}

ACE_INLINE wchar_t *
ACE_OS::strcpy (wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::strcpy");
  return ::wcscpy (s, t);
}

ACE_INLINE wint_t
ACE_OS::tolower (wint_t c)
{
  // ACE_TRACE ("ACE_OS::tolower");
  return ::towlower (c);
}

ACE_INLINE int
ACE_OS::strcasecmp (const wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::strcasecmp");

#if !defined (ACE_WIN32)
  // Handles most of what the BSD version does, but does not indicate
  // lexicographic ordering if the strings are unequal.  Just
  // indicates equal (ignoring case) by return value == 0, else not
  // equal.
  int result = 0;

  if (ACE_OS::strlen (s) != ACE_OS::strlen (t))
    result = 1;
   else
     {
       for (;
            *s != '\0' && *t != '\0';
            ++s; ++t)
         if (ACE_OS::tolower (*s) != ACE_OS::tolower (*t))
           {
             result = ((ACE_OS::tolower (*s) < ACE_OS::tolower (*t)) ? -1 : 1);
             break;
           }
     }

   return result; // == 0 for match, else 1

#else /* ACE_WIN32 */
  return ::_wcsicmp (s, t);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::strncasecmp (const wchar_t *s, const wchar_t *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strcasecmp");

#if !defined (ACE_WIN32)
  // Handles most of what the BSD version does, but does not indicate
  // lexicographic ordering if the strings are unequal.  Just
  // indicates equal (ignoring case) by return value == 0, else not
  // equal.
  int result = 0;

  while (*s != '\0' && *t != '\0' && len != 0)
    {
      if (ACE_OS::tolower (*s) != ACE_OS::tolower (*t))
        {
          result = ((ACE_OS::tolower (*s) < ACE_OS::tolower (*t)) ? -1 : 1);
          break;
        }

      ++s; ++t; --len;
    }
  }

  return result; // == 0 for match, else 1

#else /* ACE_WIN32 */
  return ::_wcsnicmp (s, t, len);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::strncmp (const wchar_t *s, const wchar_t *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncmp");
  return ::wcsncmp (s, t, len);
}

ACE_INLINE size_t
ACE_OS::strlen (const wchar_t *s)
{
  // ACE_TRACE ("ACE_OS::strlen");
  return ::wcslen (s);
}

ACE_INLINE wchar_t *
ACE_OS::strncpy (wchar_t *s, const wchar_t *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncpy");
  return ::wcsncpy (s, t, len);
}

ACE_INLINE wchar_t *
ACE_OS::strncat (wchar_t *s, const wchar_t *t, size_t len)
{
  // ACE_TRACE ("ACE_OS::strncat");
  return ::wcsncat (s, t, len);
}

ACE_INLINE wchar_t *
ACE_OS::strtok (wchar_t *s, const wchar_t *tokens)
{
  // ACE_TRACE ("ACE_OS::strtok");
  return ::wcstok (s, tokens);
}

ACE_INLINE long
ACE_OS::strtol (const wchar_t *s, wchar_t **ptr, int base)
{
  // ACE_TRACE ("ACE_OS::strtol");
  return ::wcstol (s, ptr, base);
}

/*
ACE_INLINE int
ACE_OS::isspace (wint_t c)
{
ACE_OSCALL_RETURN (::iswspace (c), int, -1);
}
*/
#if defined (ACE_WIN32)

ACE_INLINE wchar_t *
ACE_OS::strstr (const wchar_t *s, const wchar_t *t)
{
  // ACE_TRACE ("ACE_OS::strstr");
  return ::wcsstr (s, t);
}

ACE_INLINE wchar_t *
ACE_OS::strdup (const wchar_t *s)
{
  // ACE_TRACE ("ACE_OS::strdup");
  return ::wcsdup (s);
}

ACE_INLINE int
ACE_OS::vsprintf (wchar_t *buffer, const wchar_t *format, va_list argptr)
{
  return ::vswprintf (buffer, format, argptr);
}

ACE_INLINE int
ACE_OS::hostname (wchar_t *name, size_t maxnamelen)
{
  // ACE_TRACE ("ACE_OS::hostname");
  ACE_WIN32CALL_RETURN (ACE_ADAPT_RETVAL (::GetComputerNameW (name, LPDWORD (&maxnamelen)),
                                       ace_result_), int, -1);
}

ACE_INLINE ACE_HANDLE
ACE_OS::open (const wchar_t *filename,
              int mode,
              int perms,
              LPSECURITY_ATTRIBUTES sa)
{
  ACE_UNUSED_ARG (perms);
  // ACE_TRACE ("ACE_OS::open");
  // Warning: This function ignores _O_APPEND
  DWORD access = GENERIC_READ;
  if (ACE_BIT_ENABLED (mode, O_WRONLY))
    access = GENERIC_WRITE;
  else if (ACE_BIT_ENABLED (mode, O_RDWR))
    access = GENERIC_READ | GENERIC_WRITE;

  DWORD creation = OPEN_EXISTING;

  if ((mode & (_O_CREAT | _O_EXCL)) == (_O_CREAT | _O_EXCL))
    creation = CREATE_NEW;
  else if ((mode & (_O_CREAT | _O_TRUNC)) == (_O_CREAT | _O_TRUNC))
    creation = CREATE_ALWAYS;
  else if (ACE_BIT_ENABLED (mode, _O_CREAT))
    creation = OPEN_ALWAYS;
  else if (ACE_BIT_ENABLED (mode, _O_TRUNC))
    creation = TRUNCATE_EXISTING;

  DWORD flags = 0;

  if (ACE_BIT_ENABLED (mode, _O_TEMPORARY))
    flags |= FILE_FLAG_DELETE_ON_CLOSE;

  if (ACE_BIT_ENABLED (mode, FILE_FLAG_WRITE_THROUGH))
    flags |= FILE_FLAG_WRITE_THROUGH;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_OVERLAPPED))
    flags |= FILE_FLAG_OVERLAPPED;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_NO_BUFFERING))
    flags |= FILE_FLAG_NO_BUFFERING;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_RANDOM_ACCESS))
    flags |= FILE_FLAG_RANDOM_ACCESS;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_SEQUENTIAL_SCAN))
    flags |= FILE_FLAG_SEQUENTIAL_SCAN;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_DELETE_ON_CLOSE))
    flags |= FILE_FLAG_DELETE_ON_CLOSE;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_BACKUP_SEMANTICS))
    flags |= FILE_FLAG_BACKUP_SEMANTICS;
  if (ACE_BIT_ENABLED (mode, FILE_FLAG_POSIX_SEMANTICS))
    flags |= FILE_FLAG_POSIX_SEMANTICS;

  ACE_HANDLE h = ::CreateFileW (filename, access,
                                FILE_SHARE_READ | FILE_SHARE_WRITE,
                                sa, creation,
                                flags,
                                0);

  if (h == ACE_INVALID_HANDLE)
    ACE_FAIL_RETURN (h);
  else
    return h;
}

ACE_INLINE int
ACE_OS::unlink (const wchar_t *path)
{
  // ACE_TRACE ("ACE_OS::unlink");
  ACE_OSCALL_RETURN (::_wunlink (path), int, -1);
}

ACE_INLINE ACE_SHLIB_HANDLE
ACE_OS::dlopen (ACE_WIDE_DL_TYPE filename, int mode)
{
  // ACE_TRACE ("ACE_OS::dlopen");
  ACE_UNUSED_ARG (mode);

  ACE_WIN32CALL_RETURN (::LoadLibraryW (filename), ACE_SHLIB_HANDLE, 0);
}

ACE_INLINE wchar_t *
ACE_OS::getenv (const wchar_t *symbol)
{
  // ACE_TRACE ("ACE_OS::getenv");
  ACE_OSCALL_RETURN (::_wgetenv (symbol), wchar_t *, 0);
}

ACE_INLINE int
ACE_OS::access (const wchar_t *path, int amode)
{
  // ACE_TRACE ("ACE_OS::access");
  ACE_OSCALL_RETURN (::_waccess (path, amode), int, -1);
}

ACE_INLINE FILE *
ACE_OS::fopen (const wchar_t *filename, const wchar_t *mode)
{
  ACE_OSCALL_RETURN (::_wfopen (filename, mode), FILE *, 0);
}

ACE_INLINE int
ACE_OS::stat (const wchar_t *file, struct stat *stp)
{
  // ACE_TRACE ("ACE_OS::stat");
  ACE_OSCALL_RETURN (::_wstat (file, (struct _stat *) stp), int, -1);
}

ACE_INLINE int
ACE_OS::system (const wchar_t *command)
{
  ACE_OSCALL_RETURN (::_wsystem (command), int, -1);
}

ACE_INLINE wchar_t *
ACE_OS::mktemp (wchar_t *s)
{
  // ACE_TRACE ("ACE_OS::mktemp");
  return ::_wmktemp (s);
}

ACE_INLINE int
ACE_OS::mkdir (const wchar_t *path, mode_t mode)
{
  // ACE_TRACE ("ACE_OS::mkdir");
  ACE_UNUSED_ARG (mode);

  ACE_OSCALL_RETURN (::_wmkdir (path), int, -1);
}

ACE_INLINE int
ACE_OS::chdir (const wchar_t *path)
{
  // ACE_TRACE ("ACE_OS::chdir");
  ACE_OSCALL_RETURN (::_wchdir (path), int, -1);
}

#endif /* ACE_WIN32 */
#endif /* ACE_HAS_UNICODE */

#if defined (ACE_LACKS_COND_T)
ACE_INLINE long
ACE_cond_t::waiters (void) const
{
  return this->waiters_;
}
#endif /* ACE_LACKS_COND_T */

#if 0
ACE_INLINE int
ACE_OS::thr_continue (const ACE_Thread_ID &thr_id)
{
  // ACE_TRACE ("ACE_OS::thr_continue");
  return ACE_OS::thr_continue (thr_id.id ());
}

ACE_INLINE int
ACE_OS::thr_create (ACE_THR_FUNC func,
                    void *args,
                    long flags,
                    ACE_Thread_ID *thr_id,
                    long priority,
                    void *stack,
                    size_t stacksize);
{
  // ACE_TRACE ("ACE_OS::thr_create");
  ACE_thread_t thread_id;
  ACE_hthread_t thread_handle;

  int result = ACE_OS::thr_create (func, args, flags,
                                   &thread_id, &thread_handle,
                                   priority, stack, stacksize);
  if (result == -1)
    return -1;
  else if (thr_id != 0)
    {
      thr_id->id (thread_id);
      thr_id->handle (thread_handle);
      return result;
    }
}

ACE_INLINE int
ACE_OS::thr_getprio (const ACE_Thread_ID &thr_id, int &prio)
{
  // ACE_TRACE ("ACE_OS::thr_getprio");
  return ACE_OS::thr_getprio (thr_id.handle (), prio);
}

ACE_INLINE int
ACE_OS::thr_join (const ACE_Thread_ID &thr_id, void **status)
{
#if defined (ACE_WIN32)
  return ACE_OS::thr_join (thr_id.handle (), status);
#else
  return ACE_OS::thr_join (thr_id.id (), status);
#endif /* ACE_WIN32 */
}

ACE_INLINE int
ACE_OS::thr_cancel (const ACE_Thread_ID &thr_id)
{
  return ACE_OS::thr_cancel (thr_id.id ());
}

ACE_INLINE int
ACE_OS::thr_kill (const ACE_Thread_ID &thr_id, int signum)
{
  return ACE_OS::thr_kill (thr_id.id (), signum);
}

ACE_INLINE ACE_Thread_ID
ACE_OS::thr_self (void)
{
  ACE_hthread_t thr_handle;
  ACE_OS::thr_self (thr_handle);
  ACE_thread_t thr_id = ACE_OS::thr_self ();

  return ACE_Thread_ID (thr_id, thr_handle);
}

ACE_INLINE int
ACE_OS::thr_setprio (const ACE_Thread_ID &thr_id, int prio)
{
  // ACE_TRACE ("ACE_OS::thr_getprio");
  return ACE_OS::thr_setprio (thr_id.handle (), prio);
}

ACE_INLINE int
ACE_OS::thr_suspend (const ACE_Thread_ID &thr_id)
{
  return ACE_OS::thr_suspend (thr_id.handle ());
}

#endif /* 0 */

ACE_INLINE int
ACE_OS::sigaddset (sigset_t *s, int signum)
{
  // ACE_TRACE ("ACE_OS::sigaddset");
#if !defined (ACE_LACKS_SIGSET)
  ACE_OSCALL_RETURN (::sigaddset (s, signum), int, -1);
#else
  if (s == NULL) {
    errno = EFAULT ;
    return -1 ;
  }
  if (signum < 1 || signum >= NSIG) {
    errno = EINVAL ;
    return -1 ;                 // Invalid signum, return error
  }
  *s |= (1 << (signum - 1)) ;
  return 0 ;
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE int
ACE_OS::sigdelset (sigset_t *s, int signum)
{
#if !defined (ACE_LACKS_SIGSET)
  ACE_OSCALL_RETURN (::sigdelset (s, signum), int, -1);
#else
  if (s == NULL) {
    errno = EFAULT ;
    return -1 ;
  }
  if (signum < 1 || signum >= NSIG) {
    errno = EINVAL ;
    return -1 ;                 // Invalid signum, return error
  }
  *s &= ~(1 << (signum - 1)) ;
  return 0 ;
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE int
ACE_OS::sigemptyset (sigset_t *s)
{
#if !defined (ACE_LACKS_SIGSET)
  ACE_OSCALL_RETURN (::sigemptyset (s), int, -1);
#else
  if (s == NULL) {
    errno = EFAULT ;
    return -1 ;
  }
  *s = 0 ;
  return 0 ;
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE int
ACE_OS::sigfillset (sigset_t *s)
{
#if !defined (ACE_LACKS_SIGSET)
  ACE_OSCALL_RETURN (::sigfillset (s), int, -1);
#else
  if (s == NULL) {
    errno = EFAULT ;
    return -1 ;
  }
  *s = ~(sigset_t) 0 ;
  return 0 ;
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE int
ACE_OS::sigismember (sigset_t *s, int signum)
{
#if !defined (ACE_LACKS_SIGSET)
  ACE_OSCALL_RETURN (::sigismember (s, signum), int, -1);
#else
  if (s == NULL) {
    errno = EFAULT ;
    return -1 ;
  }
  if (signum < 1 || signum >= NSIG) {
    errno = EINVAL ;
    return -1 ;                 // Invalid signum, return error
  }
  return ((*s & (1 << (signum - 1))) != 0) ;
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE int
ACE_OS::sigprocmask (int how, const sigset_t *nsp, sigset_t *osp)
{
#if !defined (ACE_LACKS_SIGSET)
#if defined (ACE_LACKS_POSIX_PROTOTYPES)
  ACE_OSCALL_RETURN (::sigprocmask (how, (int*) nsp, osp), int, -1);
#else
  ACE_OSCALL_RETURN (::sigprocmask (how, nsp, osp), int, -1);
#endif /* ACE_LACKS_POSIX_PROTOTYPES */
#else
  ACE_UNUSED_ARG (how);
  ACE_UNUSED_ARG (nsp);
  ACE_UNUSED_ARG (osp);
  ACE_NOTSUP_RETURN (-1);
#endif /* !ACE_LACKS_SIGSET */
}

ACE_INLINE void *
ACE_OS::sbrk (int brk)
{
  // ACE_TRACE ("ACE_OS::sbrk");

#if defined (ACE_LACKS_SBRK)
  ACE_UNUSED_ARG (brk);
  ACE_NOTSUP_RETURN (0);
#else
  ACE_OSCALL_RETURN (::sbrk (brk), void *, 0);
#endif /* VXWORKS */
}

ACE_INLINE ACE_Thread_Manager *
ACE_Thread_Adapter::thr_mgr (void)
{
  return this->thr_mgr_;
}

ACE_INLINE ACE_THR_C_FUNC
ACE_Thread_Adapter::entry_point (void)
{
  return this->entry_point_;
}
