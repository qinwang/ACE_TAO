// -*- C++ -*-
//
// $Id$

// ****  Code generated by the The ACE ORB (TAO) IDL Compiler ****
// TAO and the TAO IDL Compiler have been developed by:
//       Center for Distributed Object Computing
//       Washington University
//       St. Louis, MO
//       USA
//       http://www.cs.wustl.edu/~schmidt/doc-center.html
// and
//       Distributed Object Computing Laboratory
//       University of California at Irvine
//       Irvine, CA
//       USA
//       http://doc.ece.uci.edu/
//
// Information about TAO is available at:
//     http://www.cs.wustl.edu/~schmidt/TAO.html


// TAO_IDL - Generated from
// be/be_visitor_interface/interface_ci.cpp:67

#if !defined (_IOP_CODEC___CI_)
#define _IOP_CODEC___CI_

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::Codec>::to_object (
    CORBA::Object_ptr &_tao_elem
  ) const
{
  _tao_elem = CORBA::Object::_duplicate (this->value_);
  return 1;
}

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::Codec>::marshal_value (TAO_OutputCDR &)
{
  return 0;
}

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::Codec>::demarshal_value (TAO_InputCDR &)
{
  return 0;
}

#endif /* end #if !defined */

// TAO_IDL - Generated from
// be/be_structure.cpp:194

// *************************************************************
// Inline operations for class IOP::Encoding_var
// *************************************************************

ACE_INLINE
IOP::Encoding_var::Encoding_var (void)
  : ptr_ (0)
{}

ACE_INLINE
IOP::Encoding_var::Encoding_var (Encoding *p)
  : ptr_ (p)
{}

ACE_INLINE
IOP::Encoding_var::Encoding_var (const ::IOP::Encoding_var &p)
{
  if (p.ptr_)
    {
      ACE_NEW (this->ptr_, ::IOP::Encoding (*p.ptr_));
    }
  else
    {
      this->ptr_ = 0;
    }
}

// Fixed-size types only.
ACE_INLINE
IOP::Encoding_var::Encoding_var (const ::IOP::Encoding &p)
{
  ACE_NEW (this->ptr_, ::IOP::Encoding (p));
}

ACE_INLINE
IOP::Encoding_var::~Encoding_var (void)
{
  delete this->ptr_;
}

ACE_INLINE
IOP::Encoding_var &
IOP::Encoding_var::operator= (Encoding *_tao_struct_var)
{
  delete this->ptr_;
  this->ptr_ = _tao_struct_var;
  return *this;
}

ACE_INLINE
::IOP::Encoding_var &
IOP::Encoding_var::operator= (const ::IOP::Encoding_var &_tao_struct_var)
{
  if (this != &_tao_struct_var)
    {
      if (_tao_struct_var.ptr_ == 0)
        {
          delete this->ptr_;
          this->ptr_ = 0;
        }
      else
        {
          Encoding *deep_copy = 0;
          ACE_NEW_RETURN (
              deep_copy,
              Encoding (*_tao_struct_var.ptr_),
              *this
            );
          
          if (deep_copy != 0)
            {
              Encoding *tmp = deep_copy;
              deep_copy = this->ptr_;
              this->ptr_ = tmp;
              delete deep_copy;
            }
        }
    }
  
  return *this;
}

// fixed-size types only
ACE_INLINE IOP::Encoding_var &
IOP::Encoding_var::operator= (const ::IOP::Encoding &p)
{
  if (this->ptr_ != &p)
  {
    delete this->ptr_;
    ACE_NEW_RETURN (
        this->ptr_,
        ::IOP::Encoding (p),
        *this
      );
  }
  
  return *this;
}

ACE_INLINE const ::IOP::Encoding *
IOP::Encoding_var::operator-> (void) const
{
  return this->ptr_;
}

ACE_INLINE ::IOP::Encoding *
IOP::Encoding_var::operator-> (void)
{
  return this->ptr_;
}

ACE_INLINE
IOP::Encoding_var::operator const ::IOP::Encoding &() const // cast
{
  return *this->ptr_;
}

ACE_INLINE
IOP::Encoding_var::operator ::IOP::Encoding &() // cast 
{
  return *this->ptr_;
}

ACE_INLINE
IOP::Encoding_var::operator ::IOP::Encoding &() const // cast 
{
  return *this->ptr_;
}

ACE_INLINE const ::IOP::Encoding &
IOP::Encoding_var::in (void) const
{
  return *this->ptr_;
}

ACE_INLINE ::IOP::Encoding &
IOP::Encoding_var::inout (void)
{
  return *this->ptr_;
}

// mapping for fixed size 
ACE_INLINE ::IOP::Encoding &
IOP::Encoding_var::out (void)
{
  return *this->ptr_;
}

ACE_INLINE ::IOP::Encoding
IOP::Encoding_var::_retn (void)
{
  return *this->ptr_;
}

ACE_INLINE ::IOP::Encoding *
IOP::Encoding_var::ptr (void) const
{
  return this->ptr_;
}

// TAO_IDL - Generated from
// be/be_visitor_interface/interface_ci.cpp:67

#if !defined (_IOP_CODECFACTORY___CI_)
#define _IOP_CODECFACTORY___CI_

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::CodecFactory>::to_object (
    CORBA::Object_ptr &_tao_elem
  ) const
{
  _tao_elem = CORBA::Object::_duplicate (this->value_);
  return 1;
}

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::CodecFactory>::marshal_value (TAO_OutputCDR &)
{
  return 0;
}

template<>
CORBA::Boolean
TAO::Any_Impl_T<IOP::CodecFactory>::demarshal_value (TAO_InputCDR &)
{
  return 0;
}

#endif /* end #if !defined */

// TAO_IDL - Generated from
// be/be_visitor_structure/cdr_op_ci.cpp:71

ACE_INLINE
CORBA::Boolean operator<< (
    TAO_OutputCDR &strm,
    const IOP::Encoding &_tao_aggregate
  )
{
  if (
    (strm << _tao_aggregate.format) &&
    (strm << CORBA::Any::from_octet (_tao_aggregate.major_version)) &&
    (strm << CORBA::Any::from_octet (_tao_aggregate.minor_version))
   )
    {
      return 1;
    }
  else
    {
      return 0;
    }
}

ACE_INLINE
CORBA::Boolean operator>> (
    TAO_InputCDR &strm,
    IOP::Encoding &_tao_aggregate
  )
{
  if (
    (strm >> _tao_aggregate.format) &&
    (strm >> CORBA::Any::to_octet (_tao_aggregate.major_version)) &&
    (strm >> CORBA::Any::to_octet (_tao_aggregate.minor_version))
   )
    {
      return 1;
    }
  else
    {
      return 0;
    }
}

