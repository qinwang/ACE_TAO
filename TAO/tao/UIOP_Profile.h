// This may look like C, but it's really -*- C++ -*-
// $Id$

// ============================================================================
//
// = LIBRARY
//     TAO
//
// = FILENAME
//     UIOP_Profile.h
//
// = DESCRIPTION
//     Unix Domain Socket (UIOP) profile specific processing
//
// = AUTHOR
//     Fred Kuhns <fredk@cs.wustl.edu>
//     Ossama Othman <othman@cs.wustl.edu>
//
// ============================================================================

#ifndef TAO_UIOP_PROFILE_H
#define TAO_UIOP_PROFILE_H
#include "ace/pre.h"

#include "tao/Profile.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

# if TAO_HAS_UIOP == 1

#include "tao/Object_KeyC.h"
#include "tao/UIOP_Connect.h"
#include "tao/UIOP_Endpoint.h"

#include "ace/UNIX_Addr.h"
#include "ace/Synch.h"

//class TAO_UIOP_Client_Connection_Handler;

// TAO UIOP_Profile concrete Profile definitions
class TAO_Export TAO_UIOP_Profile : public TAO_Profile
{
  // = TITLE
  //   This class defines the protocol specific attributes required
  //   for locating ORBs over local IPC.
  //
  // = DESCRIPTION
  //   This class defines the UIOP profile.
public:
  static const char object_key_delimiter_;
  virtual char object_key_delimiter (void) const;
  // The object key delimiter that UIOP uses or expects.

  static const char *prefix (void);
  // Return the char string prefix.

  TAO_UIOP_Profile (const ACE_UNIX_Addr &addr,
                    const TAO_ObjectKey &object_key,
                    const TAO_GIOP_Version &version,
                    TAO_ORB_Core *orb_core);
  // Profile constructor, same as above except the object_key has
  // already been marshaled.  (actually, no marshalling for this protocol)

  TAO_UIOP_Profile (const char *rendezvous_point,
                    const TAO_ObjectKey &object_key,
                    const ACE_UNIX_Addr &addr,
                    const TAO_GIOP_Version &version,
                    TAO_ORB_Core *orb_core);
  // Profile constructor

  TAO_UIOP_Profile (const char *string,
                    TAO_ORB_Core *orb_core,
                    CORBA::Environment &ACE_TRY_ENV =
                      TAO_default_environment ());
  // Create object using a string ior.

  TAO_UIOP_Profile (TAO_ORB_Core *orb_core);
  // Profile constructor, default.

  ~TAO_UIOP_Profile (void);
  // Destructor is to be called only through <_decr_refcnt>.

  virtual TAO_Endpoint *endpoint (void);
  //

  void add_endpoint (TAO_UIOP_Endpoint *endp);
  //

  int parse_string (const char *string,
                    CORBA::Environment &ACE_TRY_ENV =
                      TAO_default_environment ());
  // Initialize this object using the given input string.

  char * to_string (CORBA::Environment &ACE_TRY_ENV =
                      TAO_default_environment ());
  // Return a string representation for this profile.
  // client must deallocate memory.

  int decode (TAO_InputCDR& cdr);
  // Initialize this object using the given CDR octet string.

  virtual int encode (TAO_OutputCDR &stream) const;
  // Encode this profile in a stream, i.e. marshal it.

  virtual const TAO_ObjectKey &object_key (void) const;
  // @@ deprecated. return a reference to the Object Key.

  TAO_ObjectKey *_key (void) const;
  // Return a pointer to the Object Key.  The caller owns the memory
  // allocated for the returned key.

  CORBA::Boolean is_equivalent (const TAO_Profile *other_profile);
  // Return true if this profile is equivalent to other_profile.  Two
  // profiles are equivalent iff their key, rendezvous point, object_key
  // and version are the same.

  CORBA::ULong hash (CORBA::ULong max,
                     CORBA::Environment &ACE_TRY_ENV =
                       TAO_default_environment ());
  // Return a hash value for this object.

  IOP::TaggedProfile &create_tagged_profile (void);
  // Please see the Profile.h for the documentation of this method

private:

  void create_profile_body (TAO_OutputCDR &cdr) const;
  // Create an encapsulation of the struct ProfileBody in <cdr>

  int encode_endpoints (void);
  // Encodes endpoints from this profile into a tagged component.

  int decode_endpoints (void);
  // Decodes endpoints of this profile from a tagged component.

  TAO_UIOP_Endpoint endpoint_;
  //

  size_t count_;
  // Number of endpoints this profile contains.

  int endpoints_encoded_;
  // Flag indicating whether endpoints have already been encoded,
  // saving us from repeatedly encoding them over and over.

  TAO_ObjectKey object_key_;
  // object_key associated with this profile.

  TAO_MProfile *forward_to_;
  // list of profiles which we should try forwarding on.

  IOP::TaggedProfile tagged_profile_;
  // Our tagged profile info
};

#if defined (__ACE_INLINE__)
# include "tao/UIOP_Profile.i"
#endif /* __ACE_INLINE__ */

# endif  /* TAO_HAS_UIOP == 1 */

#include "ace/post.h"
#endif  /* TAO_UIOP_PROFILE_H */
