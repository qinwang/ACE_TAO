// ******  Code generated by the The ACE ORB (TAO) IDL Compiler *******
// TAO ORB and the TAO IDL Compiler have been developed by Washington 
// University Computer Science's Distributed Object Computing Group.
//
// Information on TAO is available at
//                 http://www.cs.wustl.edu/~schmidt/TAO.html

#if !defined (_TAO_IDL_RTECEVENTCHANNELADMINS_H_)
#define _TAO_IDL_RTECEVENTCHANNELADMINS_H_

#include "RtecEventCommS.h"
#include "RtecSchedulerS.h"
#include "RtecEventChannelAdminC.h"

class POA_RtecEventChannelAdmin
{
public:
  class ProxyPushConsumer;
  typedef ProxyPushConsumer *ProxyPushConsumer_ptr;
  class ProxyPushConsumer : public virtual RtecEventChannelAdmin::ProxyPushConsumer, public virtual POA_RtecEventComm::PushConsumer
  {
  protected:
    ProxyPushConsumer (const char *obj_name = 0);
    virtual ~ProxyPushConsumer (void);
  public:
    virtual void connect_push_supplier (RtecEventComm::PushSupplier_ptr push_supplier, const RtecEventChannelAdmin::SupplierQOS &qos,  CORBA::Environment &env) = 0; // pure virtual
    static void connect_push_supplier_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    static void _is_a_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

  };

  class ProxyPushSupplier;
  typedef ProxyPushSupplier *ProxyPushSupplier_ptr;
  class ProxyPushSupplier : public virtual RtecEventChannelAdmin::ProxyPushSupplier, public virtual POA_RtecEventComm::PushSupplier
  {
  protected:
    ProxyPushSupplier (const char *obj_name = 0);
    virtual ~ProxyPushSupplier (void);
  public:
    virtual void connect_push_consumer (RtecEventComm::PushConsumer_ptr push_consumer, const RtecEventChannelAdmin::ConsumerQOS &qos,  CORBA::Environment &env) = 0; // pure virtual
    static void connect_push_consumer_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    static void _is_a_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

  };

  class ConsumerAdmin;
  typedef ConsumerAdmin *ConsumerAdmin_ptr;
  class ConsumerAdmin : public virtual RtecEventChannelAdmin::ConsumerAdmin
  {
  protected:
    ConsumerAdmin (const char *obj_name = 0);
    virtual ~ConsumerAdmin (void);
  public:
    virtual RtecEventChannelAdmin::ProxyPushSupplier_ptr  obtain_push_supplier ( CORBA::Environment &env) = 0; // pure virtual
    static void obtain_push_supplier_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    static void _is_a_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

  };

  class SupplierAdmin;
  typedef SupplierAdmin *SupplierAdmin_ptr;
  class SupplierAdmin : public virtual RtecEventChannelAdmin::SupplierAdmin
  {
  protected:
    SupplierAdmin (const char *obj_name = 0);
    virtual ~SupplierAdmin (void);
  public:
    virtual RtecEventChannelAdmin::ProxyPushConsumer_ptr  obtain_push_consumer ( CORBA::Environment &env) = 0; // pure virtual
    static void obtain_push_consumer_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    static void _is_a_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

  };

  class EventChannel;
  typedef EventChannel *EventChannel_ptr;
  class EventChannel : public virtual RtecEventChannelAdmin::EventChannel
  {
  protected:
    EventChannel (const char *obj_name = 0);
    virtual ~EventChannel (void);
  public:
    virtual RtecEventChannelAdmin::ConsumerAdmin_ptr  for_consumers ( CORBA::Environment &env) = 0; // pure virtual
    static void for_consumers_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    virtual RtecEventChannelAdmin::SupplierAdmin_ptr  for_suppliers ( CORBA::Environment &env) = 0; // pure virtual
    static void for_suppliers_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    virtual void destroy ( CORBA::Environment &env) = 0; // pure virtual
    static void destroy_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

    static void _is_a_skel (CORBA::ServerRequest &req, CORBA::Object_ptr obj, CORBA::Environment &env);

  };

};


#if defined (__ACE_INLINE__)
#include "RtecEventChannelAdminS.i"
#endif // defined INLINE


#endif // if !defined
