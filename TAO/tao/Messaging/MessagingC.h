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

#ifndef _TAO_IDL_ORIG_MESSAGINGC_H_
#define _TAO_IDL_ORIG_MESSAGINGC_H_

#include /**/ "ace/pre.h"


#include "ace/config-all.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

#ifndef TAO_MESSAGING_SAFE_INCLUDE
#error "You should not include MessagingC.h directly, use Messaging.h"
#endif /* !TAO_MESSAGING_SAFE_INCLUDE */

#include "messaging_export.h"
#include "tao/Valuetype/ValueBase.h"
#include "tao/Valuetype/Valuetype_Adapter_Impl.h"
#include "tao/Valuetype/ValueFactory.h"
#include "tao/ORB.h"
#include "tao/SystemException.h"
#include "tao/Environment.h"
#include "tao/Object.h"
#include "tao/Valuetype/Value_VarOut_T.h"
#include "tao/Objref_VarOut_T.h"

#include "tao/PollableC.h"
#include "tao/Messaging/Messaging_SyncScope_PolicyC.h"
#include "tao/Messaging/Messaging_RT_PolicyC.h"
#include "tao/Messaging/Messaging_No_ImplC.h"
#include "tao/OctetSeqC.h"

#if defined (TAO_EXPORT_MACRO)
#undef TAO_EXPORT_MACRO
#endif
#define TAO_EXPORT_MACRO TAO_Messaging_Export

#if defined(_MSC_VER)
#pragma warning(push)
#pragma warning(disable:4250)
#endif /* _MSC_VER */

#if defined (__BORLANDC__)
#pragma option push -w-rvl -w-rch -w-ccc -w-inl
#endif /* __BORLANDC__ */

// TAO_IDL - Generated from 
// be\be_visitor_root/root_ch.cpp:62

namespace TAO
{
  class Collocation_Proxy_Broker;
  template<typename T> class Narrow_Utils;
}

// TAO_IDL - Generated from
// be\be_visitor_module/module_ch.cpp:48

namespace Messaging
{
  
  // TAO_IDL - Generated from
  // be\be_valuetype.cpp:524
  
  

#if !defined (_MESSAGING_EXCEPTIONHOLDER__VAR_OUT_CH_)
#define _MESSAGING_EXCEPTIONHOLDER__VAR_OUT_CH_
  
  class ExceptionHolder;
  typedef
    TAO_Value_Var_T<
        ExceptionHolder
      >
    ExceptionHolder_var;
  
  typedef
    TAO_Value_Out_T<
        ExceptionHolder
      >
    ExceptionHolder_out;

#endif /* end #if !defined */
  
  // TAO_IDL - Generated from
  // be\be_visitor_valuetype/valuetype_ch.cpp:56

#if !defined (_MESSAGING_EXCEPTIONHOLDER_CH_)
#define _MESSAGING_EXCEPTIONHOLDER_CH_
  
  class TAO_Messaging_Export ExceptionHolder
    : public virtual CORBA::ValueBase
  {
  public:
    typedef ExceptionHolder_var _var_type;
    
    static ExceptionHolder* _downcast (CORBA::ValueBase *);
    
    // (TAO extensions or internals)
    static CORBA::Boolean _tao_unmarshal (
        TAO_InputCDR &,
        ExceptionHolder *&
      );
    
    virtual const char* _tao_obv_repository_id (void) const;
    
    static const char* _tao_obv_static_repository_id (void);
    
    static void _tao_any_destructor (void *);
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:469
    
    virtual void is_system_exception (CORBA::Boolean) = 0;
    virtual CORBA::Boolean is_system_exception (void) const = 0;
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:469
    
    virtual void byte_order (CORBA::Boolean) = 0;
    virtual CORBA::Boolean byte_order (void) const = 0;
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:542
    
    virtual void marshaled_exception (const CORBA::OctetSeq &) = 0;
    virtual const CORBA::OctetSeq &marshaled_exception (void) const = 0;
    virtual CORBA::OctetSeq &marshaled_exception (void) = 0;
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/valuetype_ch.cpp:246
  
  protected:
    ExceptionHolder (void);
    
    virtual ~ExceptionHolder (void);
    
    virtual CORBA::Boolean _tao_marshal_v (TAO_OutputCDR &) const;
    virtual CORBA::Boolean _tao_unmarshal_v (TAO_InputCDR &);
    
  private:
    ExceptionHolder (const ExceptionHolder &);
    void operator= (const ExceptionHolder &);
    
  protected:
    virtual CORBA::Boolean
    _tao_marshal__Messaging_ExceptionHolder (TAO_OutputCDR &) const = 0;
    
    virtual CORBA::Boolean
    _tao_unmarshal__Messaging_ExceptionHolder (TAO_InputCDR &) = 0;
  };

#endif /* end #if !defined */

#if !defined (_MESSAGING_EXCEPTIONHOLDER___INIT_CH_)
#define _MESSAGING_EXCEPTIONHOLDER___INIT_CH_
  
  // TAO_IDL - Generated from
  // be\be_visitor_valuetype/valuetype_init_ch.cpp:72
  
  class TAO_Messaging_Export ExceptionHolder_init : public virtual CORBA::ValueFactoryBase
  {
  public:
    ExceptionHolder_init (void);
    
    static ExceptionHolder_init* _downcast (CORBA::ValueFactoryBase *);
    
    virtual CORBA::ValueBase *
    create_for_unmarshal (
        ACE_ENV_SINGLE_ARG_DECL_WITH_DEFAULTS
      );
    
    // TAO-specific extensions
  public:
    virtual const char* tao_repository_id (void);
  
  protected:
    virtual ~ExceptionHolder_init (void);
  };

#endif /* end #if !defined */
  
  // TAO_IDL - Generated from
  // be\be_visitor_typecode/typecode_decl.cpp:44
  
  extern TAO_Messaging_Export ::CORBA::TypeCode_ptr const _tc_ExceptionHolder;
  
  // TAO_IDL - Generated from
  // be\be_interface.cpp:598

#if !defined (_MESSAGING_REPLYHANDLER__VAR_OUT_CH_)
#define _MESSAGING_REPLYHANDLER__VAR_OUT_CH_
  
  class ReplyHandler;
  typedef ReplyHandler *ReplyHandler_ptr;
  
  typedef
    TAO_Objref_Var_T<
        ReplyHandler
      >
    ReplyHandler_var;
  
  typedef
    TAO_Objref_Out_T<
        ReplyHandler
      >
    ReplyHandler_out;

#endif /* end #if !defined */
  
  // TAO_IDL - Generated from
  // be\be_visitor_interface/interface_ch.cpp:54

#if !defined (_MESSAGING_REPLYHANDLER_CH_)
#define _MESSAGING_REPLYHANDLER_CH_
  
  class TAO_Messaging_Export ReplyHandler
    : public virtual CORBA::Object
  {
  public:
    friend class TAO::Narrow_Utils<ReplyHandler>;
    typedef ReplyHandler_ptr _ptr_type;
    typedef ReplyHandler_var _var_type;
    
    // The static operations.
    static ReplyHandler_ptr _duplicate (ReplyHandler_ptr obj);
    
    static void _tao_release (ReplyHandler_ptr obj);
    
    static ReplyHandler_ptr _narrow (
        CORBA::Object_ptr obj
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );
    
    static ReplyHandler_ptr _unchecked_narrow (
        CORBA::Object_ptr obj
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );
    
    static ReplyHandler_ptr _nil (void)
    {
      return static_cast<ReplyHandler_ptr> (0);
    }
    
    static void _tao_any_destructor (void *);
    
    // TAO_IDL - Generated from
    // be\be_visitor_interface/interface_ch.cpp:210
    
    virtual CORBA::Boolean _is_a (
        const char *type_id
        ACE_ENV_ARG_DECL_WITH_DEFAULTS
      );
    
    virtual const char* _interface_repository_id (void) const;
    virtual CORBA::Boolean marshal (TAO_OutputCDR &cdr);
  private:
    TAO::Collocation_Proxy_Broker *the_TAO_ReplyHandler_Proxy_Broker_;
  
  protected:
    // Concrete interface only.
    ReplyHandler (void);
    
    // These methods travese the inheritance tree and set the
    // parents piece of the given class in the right mode.
    virtual void Messaging_ReplyHandler_setup_collocation (void);
    
    // Concrete non-local interface only.
    ReplyHandler (
        IOP::IOR *ior,
        TAO_ORB_Core *orb_core = 0
      );
    
    // Non-local interface only.
    ReplyHandler (
        TAO_Stub *objref,
        CORBA::Boolean _tao_collocated = 0,
        TAO_Abstract_ServantBase *servant = 0,
        TAO_ORB_Core *orb_core = 0
      );
    
    virtual ~ReplyHandler (void);
  
  private:
    // Private and unimplemented for concrete interfaces.
    ReplyHandler (const ReplyHandler &);
    
    void operator= (const ReplyHandler &);
  };

#endif /* end #if !defined */
  
  // TAO_IDL - Generated from
  // be\be_visitor_typecode/typecode_decl.cpp:44
  
  extern TAO_Messaging_Export ::CORBA::TypeCode_ptr const _tc_ReplyHandler;

// TAO_IDL - Generated from
// be\be_visitor_module/module_ch.cpp:66

} // module Messaging

// Proxy Broker Factory function pointer declarations.

// TAO_IDL - Generated from
// be\be_visitor_root/root.cpp:139

extern TAO_Messaging_Export
TAO::Collocation_Proxy_Broker *
(*Messaging__TAO_ReplyHandler_Proxy_Broker_Factory_function_pointer) (
    CORBA::Object_ptr obj
  );

// TAO_IDL - Generated from
// be\be_visitor_valuetype/obv_module.cpp:55

namespace OBV_Messaging
{
  
  // TAO_IDL - Generated from
  // be\be_visitor_valuetype/valuetype_obv_ch.cpp:58

#if !defined (_MESSAGING_EXCEPTIONHOLDER___OBV_CH_)
#define _MESSAGING_EXCEPTIONHOLDER___OBV_CH_
  
  // OBV_ class
  class TAO_Messaging_Export ExceptionHolder
    : public virtual Messaging::ExceptionHolder,
      public virtual CORBA::DefaultValueRefCountBase
  {
  public:
    ExceptionHolder (void);
    virtual ~ExceptionHolder (void);
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:469
    
    virtual void is_system_exception (CORBA::Boolean);
    virtual CORBA::Boolean is_system_exception (void) const;
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:469
    
    virtual void byte_order (CORBA::Boolean);
    virtual CORBA::Boolean byte_order (void) const;
    
    // TAO_IDL - Generated from
    // be\be_visitor_valuetype/field_ch.cpp:542
    
    virtual void marshaled_exception (const CORBA::OctetSeq &);
    virtual const CORBA::OctetSeq &marshaled_exception (void) const;
    virtual CORBA::OctetSeq &marshaled_exception (void);
    
  protected:
    virtual CORBA::Boolean
    _tao_marshal__Messaging_ExceptionHolder (TAO_OutputCDR &) const;
    
    virtual CORBA::Boolean
    _tao_unmarshal__Messaging_ExceptionHolder (TAO_InputCDR &);
    
    CORBA::Boolean _tao_marshal_state (TAO_OutputCDR &) const;
    CORBA::Boolean _tao_unmarshal_state (TAO_InputCDR &);
  
  private:
    CORBA::Boolean _pd_is_system_exception;
    CORBA::Boolean _pd_byte_order;
    CORBA::OctetSeq _pd_marshaled_exception;
  };

#endif /* end #if !defined */
}

// TAO_IDL - Generated from
// be\be_visitor_traits.cpp:61

// Traits specializations.
namespace TAO
{

#if !defined (_MESSAGING_EXCEPTIONHOLDER__TRAITS_CH_)
#define _MESSAGING_EXCEPTIONHOLDER__TRAITS_CH_
  
  template<>
  struct TAO_Messaging_Export Value_Traits<Messaging::ExceptionHolder>
  {
    static void add_ref (Messaging::ExceptionHolder *);
    static void remove_ref (Messaging::ExceptionHolder *);
    static void release (Messaging::ExceptionHolder *);
  };

#endif /* end #if !defined */

#if !defined (_MESSAGING_REPLYHANDLER__TRAITS_CH_)
#define _MESSAGING_REPLYHANDLER__TRAITS_CH_
  
  template<>
  struct TAO_Messaging_Export Objref_Traits< ::Messaging::ReplyHandler>
  {
    static ::Messaging::ReplyHandler_ptr duplicate (
        ::Messaging::ReplyHandler_ptr
      );
    static void release (
        ::Messaging::ReplyHandler_ptr
      );
    static ::Messaging::ReplyHandler_ptr nil (void);
    static CORBA::Boolean marshal (
        ::Messaging::ReplyHandler_ptr p,
        TAO_OutputCDR & cdr
      );
  };

#endif /* end #if !defined */
}

// TAO_IDL - Generated from
// be\be_visitor_valuetype/any_op_ch.cpp:54

TAO_Messaging_Export void operator<<= (CORBA::Any &, Messaging::ExceptionHolder *); // copying
TAO_Messaging_Export void operator<<= (CORBA::Any &, Messaging::ExceptionHolder **); // non-copying
TAO_Messaging_Export CORBA::Boolean operator>>= (const CORBA::Any &, Messaging::ExceptionHolder *&);

// TAO_IDL - Generated from
// be\be_visitor_interface/any_op_ch.cpp:52

TAO_Messaging_Export void operator<<= (CORBA::Any &, Messaging::ReplyHandler_ptr); // copying
TAO_Messaging_Export void operator<<= (CORBA::Any &, Messaging::ReplyHandler_ptr *); // non-copying
TAO_Messaging_Export CORBA::Boolean operator>>= (const CORBA::Any &, Messaging::ReplyHandler_ptr &);

// TAO_IDL - Generated from
// be\be_valuetype.cpp:431

namespace CORBA
{
  extern TAO_Messaging_Export void add_ref (Messaging::ExceptionHolder *);
  extern TAO_Messaging_Export void remove_ref (Messaging::ExceptionHolder *);
}

// TAO_IDL - Generated from
// be\be_visitor_valuetype/cdr_op_ch.cpp:61

TAO_Messaging_Export CORBA::Boolean operator<< (TAO_OutputCDR &, const Messaging::ExceptionHolder *);
TAO_Messaging_Export CORBA::Boolean operator>> (TAO_InputCDR &, Messaging::ExceptionHolder *&);

// TAO_IDL - Generated from
// be\be_visitor_interface/cdr_op_ch.cpp:55

TAO_Messaging_Export CORBA::Boolean operator<< (TAO_OutputCDR &, const Messaging::ReplyHandler_ptr );
TAO_Messaging_Export CORBA::Boolean operator>> (TAO_InputCDR &, Messaging::ReplyHandler_ptr &);

// TAO_IDL - Generated from
// be\be_codegen.cpp:955

#if defined (__ACE_INLINE__)
#include "MessagingC.inl"
#endif /* defined INLINE */

#if defined(_MSC_VER)
#pragma warning(pop)
#endif /* _MSC_VER */

#if defined (__BORLANDC__)
#pragma option pop
#endif /* __BORLANDC__ */

#include /**/ "ace/post.h"

#endif /* ifndef */


