/* -*- C++ -*- */
// $Id$

// Miscellaneous static methods used throughout ACE.

inline u_int
ACE::major_version (void)
{
  return ACE_MAJOR_VERSION;
}

inline u_int
ACE::minor_version (void)
{
  return ACE_MINOR_VERSION;
}

inline u_int
ACE::beta_version (void)
{
  return ACE_BETA_VERSION;
}

inline ssize_t
ACE::send (ACE_HANDLE handle, const void *buf, size_t len)
{
  ACE_TRACE ("ACE::send");

#if defined (ACE_WIN32)
  return ACE_OS::send (handle, (const char *) buf, len);
#else
  return ACE_OS::write (handle, (const char *) buf, len);
#endif /* ACE_WIN32 */
}

inline ssize_t
ACE::send (ACE_HANDLE handle, const void *buf, size_t len, int flags)
{
  ACE_TRACE ("ACE::send");
  return ACE_OS::send (handle, (const char *) buf, len, flags);
}

inline ssize_t
ACE::recv (ACE_HANDLE handle, void *buf, size_t len)
{
  ACE_TRACE ("ACE::recv");
#if defined (ACE_WIN32)
    return ACE_OS::recv (handle, (char *) buf, len);
#else
    return ACE_OS::read (handle, (char *) buf, len);
#endif /* ACE_WIN32 */
}

inline ssize_t
ACE::recv (ACE_HANDLE handle, void *buf, size_t len, int flags)
{
  ACE_TRACE ("ACE::recv");

  return ACE_OS::recv (handle, (char *) buf, len, flags);
}

inline char *
ACE::strecpy (char *s, const char *t)
{
  ACE_TRACE ("ACE::strecpy");
  register char *dscan = s;
  register const char *sscan = t;

  while ((*dscan++ = *sscan++) != '\0')
    continue;

  return dscan - 1;
}

// Split a string up into 'token'-delimited pieces, ala Perl's "split".

inline char *
ACE::strsplit_r (char *str,
                 const char *token,
                 char *&next_start)
{
  char *tok_loc;
  char *ret = 0;

  if (str != 0)
    next_start = str;

  if (next_start != 0)
    {
      tok_loc = strstr (next_start, token);

      if (tok_loc != 0)
        {
          // Return the beginning of the string.
          ret = next_start;         

          // Insure its terminated.
          *tok_loc = '\0';          
          next_start = tok_loc + strlen (token);
        }
      else
        {
          ret = next_start;
          next_start = (char *)0;
        }
    }

  return ret;
}

// Return flags currently associated with handle.

inline int
ACE::get_flags (ACE_HANDLE handle)
{
  ACE_TRACE ("ACE::get_flags");

#if defined (ACE_LACKS_FCNTL)
  // ACE_OS::fcntl is not supported, e.g., on VxWorks.  It
  // would be better to store ACE's notion of the flags
  // associated with the handle, but this works for now.
  ACE_UNUSED_ARG (handle);
  return 0;
#else
  return ACE_OS::fcntl (handle, F_GETFL, 0);
#endif /* ACE_LACKS_FCNTL */
}

inline u_long
ACE::log2 (u_long num)
{
  u_long log = 0;

  for (;
       num > 0;
       log++)
    num >>= 1;

  return log;
}

inline char 
ACE::nibble2hex (u_int n)
{
  return ACE::hex_chars_[n & 0x0f];
}

inline u_char 
ACE::hex2byte (char c)
{
  if (isdigit (c))
    return (u_char) (c - '0');
  else if (islower (c))
    return (u_char) (10 + c - 'a');
  else
    return (u_char) (10 + c - 'A');
}
