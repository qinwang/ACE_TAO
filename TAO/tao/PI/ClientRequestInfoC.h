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

// TAO_IDL - Generated from
// be\be_codegen.cpp:153

#ifndef _TAO_IDL_ORIG_CLIENTREQUESTINFOC_H_
#define _TAO_IDL_ORIG_CLIENTREQUESTINFOC_H_

#include /**/ "ace/pre.h"


#include "ace/config-all.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

#include "tao/PI/pi_export.h"
#include "tao/AnyTypeCode/TypeCode_Constants.h"
#include "tao/AnyTypeCode/Any.h"
#include "tao/AnyTypeCode/TypeCode.h"
#include "tao/ORB.h"
#include "tao/SystemException.h"
#include "tao/Environment.h"
#include "tao/Object.h"
#include "tao/Objref_VarOut_T.h"

#include "tao/PI/RequestInfoC.h"
#include "tao/orb_typesC.h"
#include "tao/Policy_ForwardC.h"

#if defined (TAO_EXPORT_MACRO)
#undef TAO_EXPORT_MACRO
#endif
#define TAO_EXPORT_MACRO TAO_PI_Export

#if defined(_MSC_VER)
#pragma warning(push)
#pragma warning(disable:4250)
#endif /* _MSC_VER */

#if defined (__BORLANDC__)
#pragma option push -w-rvl -w-rch -w-ccc -w-inl
#endif /* __BORLANDC__ */

// TAO_IDL - Generated from
// be\be_visitor_module/module_ch.cpp:48

namespace PortableInterceptor
{

  // TAO_IDL - Generated from
  // be\be_interface.cpp:598

#if !defined (_PORTABLEINTERCEPTOR_CLIENTREQUESTINFO__VAR_OUT_CH_)
#define _PORTABLEINTERCEPTOR_CLIENTREQUESTINFO__VAR_OUT_CH_

  class ClientRequestInfo;
  typedef ClientRequestInfo *ClientRequestInfo_ptr;

  typedef
    TAO_Objref_Var_T<
        ClientRequestInfo
      >
    ClientRequestInfo_var;

  typedef
    TAO_Objref_Out_T<
        ClientRequestInfo
      >
    ClientRequestInfo_out;

#endif /* end #if !defined */

  // TAO_IDL - Generated from
  // be\be_visitor_interface/interface_ch.cpp:54

#if !defined (_PORTABLEINTERCEPTOR_CLIENTREQUESTINFO_CH_)
#define _PORTABLEINTERCEPTOR_CLIENTREQUESTINFO_CH_

  class TAO_PI_Export ClientRequestInfo
    : public virtual ::PortableInterceptor::RequestInfo
  {
  public:
    typedef ClientRequestInfo_ptr _ptr_type;
    typedef ClientRequestInfo_var _var_type;

    // The static operations.
    static ClientRequestInfo_ptr _duplicate (ClientRequestInfo_ptr obj);

    static void _tao_release (ClientRequestInfo_ptr obj);

    static ClientRequestInfo_ptr _narrow (
        CORBA::Object_ptr obj
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );

    static ClientRequestInfo_ptr _unchecked_narrow (
        CORBA::Object_ptr obj
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );

    static ClientRequestInfo_ptr _nil (void)
    {
      return static_cast<ClientRequestInfo_ptr> (0);
    }

    static void _tao_any_destructor (void *);

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual CORBA::Object_ptr target (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual CORBA::Object_ptr effective_target (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual ::IOP::TaggedProfile * effective_profile (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual CORBA::Any * received_exception (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual char * received_exception_id (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual ::IOP::TaggedComponent * get_effective_component (
        ::IOP::ComponentId id
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual ::IOP::TaggedComponentSeq * get_effective_components (
        ::IOP::ComponentId id
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual ::CORBA::Policy_ptr get_request_policy (
        ::CORBA::PolicyType type
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_operation/operation_ch.cpp:46

    virtual void add_request_service_context (
        const ::IOP::ServiceContext & service_context,
        ::CORBA::Boolean replace
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
      )) = 0;

    // TAO_IDL - Generated from
    // be\be_visitor_interface/interface_ch.cpp:210

    virtual CORBA::Boolean _is_a (
        const char *type_id
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );

    virtual const char* _interface_repository_id (void) const;
    virtual CORBA::Boolean marshal (TAO_OutputCDR &cdr);

  protected:
    // Abstract or local interface only.
    ClientRequestInfo (void);

    virtual ~ClientRequestInfo (void);

  private:
    // Private and unimplemented for concrete interfaces.
    ClientRequestInfo (const ClientRequestInfo &);

    void operator= (const ClientRequestInfo &);
  };

#endif /* end #if !defined */

  // TAO_IDL - Generated from
  // be\be_visitor_typecode/typecode_decl.cpp:44

  extern TAO_PI_Export ::CORBA::TypeCode_ptr const _tc_ClientRequestInfo;

// TAO_IDL - Generated from
// be\be_visitor_module/module_ch.cpp:66

} // module PortableInterceptor

// TAO_IDL - Generated from
// be\be_visitor_traits.cpp:61

// Traits specializations.
namespace TAO
{

#if !defined (_PORTABLEINTERCEPTOR_CLIENTREQUESTINFO__TRAITS_CH_)
#define _PORTABLEINTERCEPTOR_CLIENTREQUESTINFO__TRAITS_CH_

  template<>
  struct TAO_PI_Export Objref_Traits< ::PortableInterceptor::ClientRequestInfo>
  {
    static ::PortableInterceptor::ClientRequestInfo_ptr duplicate (
        ::PortableInterceptor::ClientRequestInfo_ptr
      );
    static void release (
        ::PortableInterceptor::ClientRequestInfo_ptr
      );
    static ::PortableInterceptor::ClientRequestInfo_ptr nil (void);
    static CORBA::Boolean marshal (
        ::PortableInterceptor::ClientRequestInfo_ptr p,
        TAO_OutputCDR & cdr
      );
  };

#endif /* end #if !defined */
}

// TAO_IDL - Generated from
// be\be_visitor_interface/any_op_ch.cpp:52

TAO_PI_Export void operator<<= (CORBA::Any &, PortableInterceptor::ClientRequestInfo_ptr); // copying
TAO_PI_Export void operator<<= (CORBA::Any &, PortableInterceptor::ClientRequestInfo_ptr *); // non-copying
TAO_PI_Export CORBA::Boolean operator>>= (const CORBA::Any &, PortableInterceptor::ClientRequestInfo_ptr &);

// TAO_IDL - Generated from
// be\be_codegen.cpp:955

#if defined(_MSC_VER)
#pragma warning(pop)
#endif /* _MSC_VER */

#if defined (__BORLANDC__)
#pragma option pop
#endif /* __BORLANDC__ */

#include /**/ "ace/post.h"

#endif /* ifndef */


