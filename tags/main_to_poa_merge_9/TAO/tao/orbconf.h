// This may look like C, but it's really -*- C++ -*-
// @ (#) $Id$

// ============================================================================
//
// = LIBRARY
//     TAO
//
// = FILENAME
//     default_server.h
//
// = DESCRIPTION
//     Build configuration file for the Inter-ORB Engine, and application
//     level code using it via <corba.hh>
//
// = AUTHOR
//     Copyright 1995 by Sun Microsystems, Inc.
//
//     TAO-specific changes by Chris Cleeland and Douglas C. Schmidt
//
// ============================================================================

#if !defined (TAO_ORB_CONFIG_H)
#define	TAO_ORB_CONFIG_H

#include "ace/OS.h"

// The default size of TAO's server object table.
#if !defined (TAO_DEFAULT_SERVER_OBJECT_TABLE_SIZE)
#define TAO_DEFAULT_SERVER_OBJECT_TABLE_SIZE 64
#endif /* TAO_DEFAULT_SERVER_OBJECT_TABLE_SIZE */

// The default UDP multicast port number for locating the TAO Naming
// Service.
#if !defined (TAO_DEFAULT_NAME_SERVER_REQUEST_PORT)
#define TAO_DEFAULT_NAME_SERVER_REQUEST_PORT 10013
#endif /* TAO_DEFAULT_NAME_SERVER_REQUEST_PORT */

// The default UDP port number for replying to a location request to
// the TAO Naming Service.
#if !defined (TAO_DEFAULT_NAME_SERVER_REPLY_PORT)
#define TAO_DEFAULT_NAME_SERVER_REPLY_PORT 10014
#endif /* TAO_DEFAULT_NAME_SERVER_REPLY_PORT */

// The default timeout receiving the location request to
// the TAO Naming Service.
#if !defined (TAO_DEFAULT_NAME_SERVER_TIMEOUT)
#define TAO_DEFAULT_NAME_SERVER_TIMEOUT 5
#endif /* TAO_DEFAULT_NAME_SERVER_TIMEOUT */

// The default starting port number for TAO servers.
#if !defined (TAO_DEFAULT_SERVER_PORT)
#define TAO_DEFAULT_SERVER_PORT 10015
#endif /* TAO_DEFAULT_SERVER_PORT */

// TAO's max buffer size
#if !defined (TAO_MAXBUFSIZE)
#define TAO_MAXBUFSIZE 1024
#endif /* TAO_MAXBUFSIZE */

// This controls the alignment for TAO structs.
#define TAO_ALIGNMENT_MAGIC_NUMBER 64

// BC++ seems to have a different convention for detecting Win32 than
// VC++.

#if defined (__WIN32__)
#	define _WIN32
#endif	/* BC++ convention */

// Define to `int' if <sys/types.h> doesn't define.
/* #undef pid_t */

// Define if your processor does not store words with the most significant
// byte first.
#if defined (i386) || defined (__i386) || defined (_M_IX86) || defined (vax) || defined (__alpha)
#  define TAO_ENCAP_BYTE_ORDER 1  /* little endian encapsulation byte order has
                                     the value = 1 */
#else
#  define TAO_WORDS_BIGENDIAN 1
#  define TAO_ENCAP_BYTE_ORDER 0  /* big endian encapsulation byte order has
                                     the value = 1 */
#endif

#if UINT_MAX == 65535UL
# define SIZEOF_INT 2
#elif UINT_MAX == 4294967295UL
# define SIZEOF_INT 4
#elif UINT_MAX == 18446744073709551615UL
# define SIZEOF_INT 8
#else
# error: unsupported int size, must be updated for this platform!
#endif /* UINT_MAX */

#if ULONG_MAX == 65535UL
# define SIZEOF_LONG 2
#elif ULONG_MAX == 4294967295UL
# define SIZEOF_LONG 4
#elif ULONG_MAX == 18446744073709551615UL
# define SIZEOF_LONG 8
#else
# error: unsupported long size, must be updated for this platform!
#endif /* ULONG_MAX */

// The number of bytes in a void *.
#define SIZEOF_VOID_P SIZEOF_LONG

// The number of bytes in a long long.
#if !defined (_WIN32) && !defined (VXWORKS)
#define SIZEOF_LONG_LONG 8
#endif /* !defined (_WIN32) && !defined (VXWORKS) */

// The number of bytes in a long double.
#if defined (linux) || defined (ACE_NETBSD) || defined (__FreeBSD__) || defined(CHORUS)
#  define SIZEOF_LONG_DOUBLE 12
#elif defined (_WIN32) || defined (VXWORKS) || defined (M_UNIX)
#  define SIZEOF_LONG_DOUBLE 8
#else
#  define SIZEOF_LONG_DOUBLE 16
#endif /* linux */

// The number of bytes in a bool.
#define SIZEOF_BOOL 0

// Define as the return type of signal handlers (int or void).
#define RETSIGTYPE void

// Define if you don't have vprintf but do have _doprnt.
/* #undef HAVE_DOPRNT */

// Define if you have the vprintf function.
#define HAVE_VPRINTF 1

// Avoid namespace pollution that's common on older UNIXes...
#if defined (minor)
#undef minor
#endif /* minor */

#if defined (major)
#undef major
#endif /* major*/

// For Win16, near/far pointers reflect same/other segment addressing.
// Of course, ACE doesn't support Win16, so why bother?

// For now, we simply set the default to empty definition and let
// places that it fails bubble up.
#define _FAR

// Assume DOS/Windows if "configure" didn't get run.

#if !defined (SIZEOF_LONG) || defined (_WIN32)
//#	if defined (_WIN32) || defined (linux)
//#		define	SIZEOF_INT	4
//#	else	// Win16
//#		define	SIZEOF_INT	2
//#	endif	// Win32/Win16

#  if !defined (linux) && !defined (_WIN32)
typedef	unsigned long pid_t;
#  endif /* !defined (linux) && !defined (_WIN32) */

// "C4355: 'this' : used in base member initializer list"
#  pragma warning (disable:4355) /* disable C4355 warning */

#endif /* !defined (SIZEOF_LONG) || defined (_WIN32) */

#endif	/* TAO_ORB_CONFIG_H */
