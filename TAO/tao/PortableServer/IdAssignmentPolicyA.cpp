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
// and
//       Institute for Software Integrated Systems
//       Vanderbilt University
//       Nashville, TN
//       USA
//       http://www.isis.vanderbilt.edu/
//
// Information about TAO is available at:
//     http://www.cs.wustl.edu/~schmidt/TAO.html

#include "tao/AnyTypeCode/Null_RefCount_Policy.h"
#include "tao/AnyTypeCode/TypeCode_Constants.h"
#include "tao/AnyTypeCode/Alias_TypeCode_Static.h"
#include "tao/AnyTypeCode/Enum_TypeCode_Static.h"
#include "tao/AnyTypeCode/Objref_TypeCode_Static.h"
#include "IdAssignmentPolicyA.h"
#include "tao/CDR.h"
#include "tao/AnyTypeCode/Any.h"
#include "tao/AnyTypeCode/Any_Impl_T.h"
#include "tao/AnyTypeCode/Any_Basic_Impl_T.h"

// TAO_IDL - Generated from
// be\be_visitor_typecode/enum_typecode.cpp:34

static char const * const _tao_enumerators_PortableServer_IdAssignmentPolicyValue[] =
  {
    "USER_ID",
    "SYSTEM_ID"
    
  };

static TAO::TypeCode::Enum<char const *,
                           char const * const *,
                           TAO::Null_RefCount_Policy>
  _tao_tc_PortableServer_IdAssignmentPolicyValue (
    "IDL:omg.org/PortableServer/IdAssignmentPolicyValue:2.3",
    "IdAssignmentPolicyValue",
    _tao_enumerators_PortableServer_IdAssignmentPolicyValue,
    2);
  
namespace PortableServer
{
  ::CORBA::TypeCode_ptr const _tc_IdAssignmentPolicyValue =
    &_tao_tc_PortableServer_IdAssignmentPolicyValue;
}



// TAO_IDL - Generated from
// be\be_visitor_typecode/objref_typecode.cpp:76

static TAO::TypeCode::Objref<char const *,
                             TAO::Null_RefCount_Policy>
  _tao_tc_PortableServer_IdAssignmentPolicy (
    CORBA::tk_local_interface,
    "IDL:omg.org/PortableServer/IdAssignmentPolicy:2.3",
    "IdAssignmentPolicy");
  
namespace PortableServer
{
  ::CORBA::TypeCode_ptr const _tc_IdAssignmentPolicy =
    &_tao_tc_PortableServer_IdAssignmentPolicy;
}



// TAO_IDL - Generated from
// be\be_visitor_enum/any_op_cs.cpp:52

void operator<<= (
    CORBA::Any &_tao_any,
    PortableServer::IdAssignmentPolicyValue _tao_elem
  )
{
  TAO::Any_Basic_Impl_T<PortableServer::IdAssignmentPolicyValue>::insert (
      _tao_any,
      PortableServer::_tc_IdAssignmentPolicyValue,
      _tao_elem
    );
}

CORBA::Boolean operator>>= (
    const CORBA::Any &_tao_any,
    PortableServer::IdAssignmentPolicyValue &_tao_elem
  )
{
  return
    TAO::Any_Basic_Impl_T<PortableServer::IdAssignmentPolicyValue>::extract (
        _tao_any,
        PortableServer::_tc_IdAssignmentPolicyValue,
        _tao_elem 
      );
}
