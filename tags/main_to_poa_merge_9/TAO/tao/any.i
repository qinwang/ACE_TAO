// This may look like C, but it's really -*- C++ -*-

ACE_INLINE void *
CORBA_Any::operator new (size_t, const void *p)
{
  return (void *) p;
}

ACE_INLINE void *
CORBA_Any::operator new (size_t s)
{
  return ::operator new (s);
}

ACE_INLINE void
CORBA_Any::operator delete (void *p)
{
  ::operator delete (p);
}

// insertion from special types

// @@ Andy, please take a look at this method and make sure it's what
// you intended.  I couldn't find it defined anywhere.  --cjc
ACE_INLINE void
CORBA_Any::replace (CORBA::TypeCode_ptr type,
                    const void *value,
                    CORBA::Boolean orb_owns_data)
{
  CORBA_Environment e;
  this->replace (type, value, orb_owns_data, e);
}

// insertion operators

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::Short s)
{
  replace (CORBA::_tc_short, new CORBA::Short (s), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::UShort s)
{
  replace (CORBA::_tc_ushort, new CORBA::UShort (s), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::Long l)
{
  replace (CORBA::_tc_long, new CORBA::Long (l), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::ULong l)
{
  replace (CORBA::_tc_ulong, new CORBA::ULong (l), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::Float f)
{
  replace (CORBA::_tc_float, new CORBA::Float (f), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (CORBA::Double d)
{
  replace (CORBA::_tc_double, new CORBA::Double (d), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (const CORBA_Any& a)
{
  replace (CORBA::_tc_any, new CORBA_Any (a), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (const char* s)
{
  replace (CORBA::_tc_string, CORBA::string_dup (s), CORBA::B_TRUE);
}

// implementing the special types
ACE_INLINE
CORBA_Any::from_boolean::from_boolean (CORBA::Boolean b)
  : val_ (b)
{
}

ACE_INLINE
CORBA_Any::to_boolean::to_boolean (CORBA::Boolean &b)
  : ref_ (b)
{
}

ACE_INLINE
CORBA_Any::from_octet::from_octet (CORBA::Octet o)
  : val_ (o)
{
}

ACE_INLINE
CORBA_Any::to_octet::to_octet (CORBA::Octet &o)
  : ref_ (o)
{
}

ACE_INLINE
CORBA_Any::from_char::from_char (CORBA::Char c)
  : val_ (c)
{
}

ACE_INLINE
CORBA_Any::to_char::to_char (CORBA::Char &c)
  : ref_ (c)
{
}

ACE_INLINE
CORBA_Any::from_string::from_string (char *s, CORBA::ULong b, CORBA::Boolean nocopy)
  : val_ (s),
    bound_ (b),
    nocopy_ (nocopy)
{
}

ACE_INLINE
CORBA_Any::to_string::to_string (char *&s, CORBA::ULong b)
  : ref_ (s),
    bound_ (b)
{
}

ACE_INLINE void
CORBA_Any::operator<<= (from_boolean b)
{
  replace (CORBA::_tc_boolean, new CORBA::Boolean (b.val_), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (from_octet o)
{
  replace (CORBA::_tc_octet, new CORBA::Octet (o.val_), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (from_char c)
{
  replace (CORBA::_tc_char, new CORBA::Char (c.val_), CORBA::B_TRUE);
}

ACE_INLINE void
CORBA_Any::operator<<= (from_string s)
{
  if (s.nocopy_)
    replace (CORBA::_tc_string,  s.val_, CORBA::B_TRUE);
  else
    replace (CORBA::_tc_string, CORBA::string_dup (s.val_), CORBA::B_TRUE);
}

// extraction: these are safe and hence we have to check that the typecode of
// the Any is equal to the one we are trying to extract into

ACE_INLINE CORBA::Boolean
CORBA_Any::operator>>= (CORBA::Short &s) const
{
  CORBA::Environment env;

  if (type_->equal (CORBA::_tc_short, env))
    {
      s = *(CORBA::Short *) value_;
      return CORBA::B_TRUE;
    }
  else
    return CORBA::B_FALSE;
}


// ----------------------------------------------------------------------
// CORBA_Any_var type
// ----------------------------------------------------------------------

ACE_INLINE 
CORBA_Any_var::CORBA_Any_var (void)
  : ptr_ (0)
{
}

ACE_INLINE 
CORBA_Any_var::CORBA_Any_var (CORBA_Any *p)
  : ptr_ (p)
{
}

ACE_INLINE
CORBA_Any_var::CORBA_Any_var (const CORBA_Any_var& r)
  : ptr_ (new CORBA::Any (*r.ptr_))
{
}

ACE_INLINE 
CORBA_Any_var::~CORBA_Any_var (void)
{
  delete this->ptr_;
}

ACE_INLINE
CORBA_Any_var::operator CORBA_Any *&()
{
  return this->ptr_;
}

ACE_INLINE
CORBA_Any_var::operator const CORBA_Any *() const
{
  return this->ptr_;
}

ACE_INLINE CORBA::Any *
CORBA_Any_var::operator-> (void)
{
  return this->ptr_;
}

ACE_INLINE const CORBA_Any &
CORBA_Any_var::in (void) const
{
  return *this->ptr_;
}

ACE_INLINE CORBA_Any &
CORBA_Any_var::inout (void)
{
  return *this->ptr_;
}

ACE_INLINE CORBA_Any *&
CORBA_Any_var::out (void)
{
  delete this->ptr_;
  this->ptr_ = 0;
  return this->ptr_;
}

ACE_INLINE CORBA_Any *
CORBA_Any_var::_retn (void)
{
  CORBA_Any *temp = this->ptr_;
  this->ptr_ = 0;
  return temp;
}

// ----------------------------------------------------------------------
// CORBA_Any_out type
// ----------------------------------------------------------------------

ACE_INLINE
CORBA_Any_out::CORBA_Any_out (CORBA_Any *&s)
  : ptr_ (s)
{
  this->ptr_ = 0;
}

ACE_INLINE
CORBA_Any_out::CORBA_Any_out (CORBA_Any_var &s)
  : ptr_ (s.out ()) 
{
}

ACE_INLINE
CORBA_Any_out::CORBA_Any_out (CORBA_Any_out &s)
  : ptr_ (s.ptr_)
{
}

ACE_INLINE CORBA_Any_out &
CORBA_Any_out::operator= (CORBA_Any_out &s)
{
  this->ptr_ = s.ptr_;
  return *this;
}

ACE_INLINE CORBA_Any_out &
CORBA_Any_out::operator= (CORBA_Any *s)
{
  this->ptr_ = s;
  return *this;
}

ACE_INLINE CORBA_Any_out &
CORBA_Any_out::operator= (const CORBA_Any *s)
{
  this->ptr_ = new CORBA::Any (*s);
  return *this;
}

ACE_INLINE
CORBA_Any_out::operator CORBA_Any *&()
{
  return this->ptr_;
}

ACE_INLINE CORBA_Any *&
CORBA_Any_out::ptr (void)
{
  return this->ptr_;
}

