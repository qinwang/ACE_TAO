// -*- C++ -*-
// $Id$

/**
 * Code generated by the The ACE ORB (TAO) IDL Compiler v1.8.3
 * TAO and the TAO IDL Compiler have been developed by:
 *       Center for Distributed Object Computing
 *       Washington University
 *       St. Louis, MO
 *       USA
 *       http://www.cs.wustl.edu/~schmidt/doc-center.html
 * and
 *       Distributed Object Computing Laboratory
 *       University of California at Irvine
 *       Irvine, CA
 *       USA
 * and
 *       Institute for Software Integrated Systems
 *       Vanderbilt University
 *       Nashville, TN
 *       USA
 *       http://www.isis.vanderbilt.edu/
 *
 * Information about TAO is available at:
 *     http://www.cs.wustl.edu/~schmidt/TAO.html
 **/
#ifndef CIAO_READGET_TEST_SENDER_EXEC_CB6ML7_H_
#define CIAO_READGET_TEST_SENDER_EXEC_CB6ML7_H_

#include /**/ "ace/pre.h"

#include "ReadGet_Test_SenderEC.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

#include /**/ "Sender_exec_export.h"
#include "tao/LocalObject.h"

namespace CIAO_ReadGet_Test_Sender_Impl
{
  class Sender_exec_i;

  /**
   * ConnectorStatusListener_exec_i
   */
  class SENDER_EXEC_Export ConnectorStatusListener_exec_i
    : public virtual ::CCM_DDS::CCM_ConnectorStatusListener,
      public virtual ::CORBA::LocalObject
  {
  public:
    ConnectorStatusListener_exec_i (Sender_exec_i &callback);
    virtual ~ConnectorStatusListener_exec_i (void);

    virtual
    void on_inconsistent_topic (::DDS::Topic_ptr the_topic,
                                const DDS::InconsistentTopicStatus & status);
    virtual
    void on_requested_incompatible_qos (::DDS::DataReader_ptr the_reader,
                                        const DDS::RequestedIncompatibleQosStatus & status);
    virtual
    void on_sample_rejected (::DDS::DataReader_ptr the_reader,
                             const DDS::SampleRejectedStatus & status);
    virtual
      void on_offered_deadline_missed (::DDS::DataWriter_ptr the_writer,
                                       const DDS::OfferedDeadlineMissedStatus & status);
    virtual
    void on_offered_incompatible_qos (::DDS::DataWriter_ptr the_writer,
                                      const DDS::OfferedIncompatibleQosStatus & status);
    virtual
      void on_unexpected_status (::DDS::Entity_ptr the_entity,
                                 ::DDS::StatusKind status_kind);
  private:
    Sender_exec_i &callback_;
    bool started_;
  };

  /**
   * Write Handler
   */
  class WriteHandler :
    public ACE_Event_Handler
  {
  public:
    WriteHandler (Sender_exec_i &callback);
    virtual int handle_exception (ACE_HANDLE fc = ACE_INVALID_HANDLE);
  private:
    Sender_exec_i &callback_;
  };

  /**
   * Provider Executor Implementation Class: restart_writer_exec_i
   */

  class restart_writer_exec_i
    : public virtual ::CCM_ReadGetRestarter,
      public virtual ::CORBA::LocalObject
  {
  public:
    restart_writer_exec_i (
      ::ReadGet_Test::CCM_Sender_Context_ptr ctx,
      Sender_exec_i & callback);
    virtual ~restart_writer_exec_i (void);

    //@{
    /** Operations and attributes from ReadGetRestarter. */

    virtual
    void restart_write (void);
    //@}

  private:
    ::ReadGet_Test::CCM_Sender_Context_var ciao_context_;
    Sender_exec_i &callback_;
  };

  /**
   * Component Executor Implementation Class: Sender_exec_i
   */

  class Sender_exec_i
    : public virtual Sender_Exec,
      public virtual ::CORBA::LocalObject
  {
  public:
    Sender_exec_i (void);
    virtual ~Sender_exec_i (void);

    //@{
    /** Supported operations and attributes. */

    //@}

    //@{
    /** Component attributes and port operations. */
    virtual ::CCM_DDS::CCM_ConnectorStatusListener_ptr
    get_connector_status (void);

    virtual ::CCM_ReadGetRestarter_ptr
    get_restart_writer (void);

    virtual ::CORBA::UShort keys (void);

    virtual void keys (::CORBA::UShort keys);
    //@}

    //@{
    /** Operations from Components::SessionComponent. */
    virtual void set_session_context (::Components::SessionContext_ptr ctx);
    virtual void configuration_complete (void);
    virtual void ccm_activate (void);
    virtual void ccm_passivate (void);
    virtual void ccm_remove (void);
    //@}

    //@{
    /** User defined public operations. */
    void get_started (void);
    void start (void);
    void restart (void);

    //@}

  private:
    ::ReadGet_Test::CCM_Sender_Context_var ciao_context_;

    //@{
    /** Component attributes. */
    ::CCM_ReadGetRestarter_var ciao_restart_writer_;

    ::CORBA::UShort keys_;
    //@}

    //@{
    /** User defined members. */
    ::CORBA::UShort iterations_;
    ::CORBA::UShort run_;
    WriteHandler *wh_;
    //@}

    //@{
    /** User defined private operations. */

    //@}

    /// Get the ACE_Reactor
    ACE_Reactor* reactor (void);
  };

  extern "C" SENDER_EXEC_Export ::Components::EnterpriseComponent_ptr
  create_ReadGet_Test_Sender_Impl (void);
}

#include /**/ "ace/post.h"

#endif /* ifndef */
