// $Id$

#include "Kokyu_EC.h"
#include <orbsvcs/Sched/Reconfig_Scheduler.h>
#include <orbsvcs/Runtime_Scheduler.h>
#include <orbsvcs/Event_Service_Constants.h>
#include <orbsvcs/Event_Utilities.h>
#include <orbsvcs/Scheduler_Factory.h>
#include <orbsvcs/Event/EC_Event_Channel.h>
#include <orbsvcs/Event/EC_Default_Factory.h>
#include <orbsvcs/Event/EC_Kokyu_Factory.h>
#include "ace/OS_NS_strings.h" //for ACE_OS::strcasecmp
#include "ace/OS_NS_sys_time.h" // for ACE_OS::gettimeofday
#include "ace/Reactor.h"

namespace {

  typedef TAO_Reconfig_Scheduler<TAO_RMS_FAIR_Reconfig_Sched_Strategy, TAO_SYNCH_MUTEX> RECONFIG_RMS_SCHED_TYPE;
  typedef TAO_Reconfig_Scheduler<TAO_MUF_FAIR_Reconfig_Sched_Strategy, TAO_SYNCH_MUTEX> RECONFIG_MUF_SCHED_TYPE;
  typedef TAO_Reconfig_Scheduler<TAO_EDF_FAIR_Reconfig_Sched_Strategy, TAO_SYNCH_MUTEX> RECONFIG_EDF_SCHED_TYPE;

  POA_RtecScheduler::Scheduler*
    create_scheduler(const char* schedule_discipline)
  {
    POA_RtecScheduler::Scheduler* sched_impl=0;
    if (ACE_OS::strcasecmp(schedule_discipline, "rms") == 0)
    {
      ACE_DEBUG ((LM_DEBUG, "Creating RMS scheduler\n"));
      ACE_NEW_RETURN (sched_impl,
        RECONFIG_RMS_SCHED_TYPE,
        0);
    }
    else if (ACE_OS::strcasecmp(schedule_discipline, "muf") == 0)
    {
      ACE_DEBUG ((LM_DEBUG, "Creating MUF scheduler\n"));
      ACE_NEW_RETURN (sched_impl,
        RECONFIG_MUF_SCHED_TYPE,
        0);
    }
    else if (ACE_OS::strcasecmp(schedule_discipline, "edf") == 0)
    {
      ACE_DEBUG ((LM_DEBUG, "Creating EDF scheduler\n"));
      ACE_NEW_RETURN (sched_impl,
        RECONFIG_EDF_SCHED_TYPE,
        0);
    }

    //@BT: Decided on which kind of scheduling to do, same as DT SCHEDULE SETUP
    //DSTRM_EVENT (MAIN_GROUP_FAM, SCHEDULE_SETUP, 1, strlen (policy), policy);
    ACE_DEBUG((LM_DEBUG,"Kokyu_EC thread %t SCHEDULE_SETUP at %u\n",ACE_OS::gettimeofday().msec()));
    return sched_impl;
  }
} //anonymous namespace

Kokyu_EC::Kokyu_EC(void)
{
}

Kokyu_EC::~Kokyu_EC(void)
{
  for(size_t i=0; i<suppliers_.size(); ++i) {
    delete suppliers_[i];
  }
  for(size_t i=0; i<consumers_.size(); ++i) {
    delete consumers_[i];
  }
  if (this->reactor_ != 0)
    {
      for(size_t i=0; i<timer_handles_.size(); ++i) {
        this->reactor_->cancel_timer(timer_handles_[i]);
      }
      for(size_t i=0; i<timeout_handlers_.size(); ++i) {
        delete timeout_handlers_[i];
      }
    }
}

int
Kokyu_EC::init(const char* schedule_discipline, PortableServer::POA_ptr poa, ACE_Reactor * reactor)
{
  ACE_TRY_NEW_ENV {

    scheduler_impl_ = create_scheduler(schedule_discipline);
    if (scheduler_impl_.in() == 0) return -1;

    scheduler_ = scheduler_impl_->_this();

    TAO_EC_Event_Channel_Attributes attrib(poa, poa);
    attrib.scheduler = scheduler_.in();

    TAO_EC_Event_Channel* ec;
    ACE_NEW_RETURN(ec, TAO_EC_Event_Channel(attrib), -1);
    ec_impl_ = ec;

    consumer_admin_ = ec_impl_->for_consumers(ACE_ENV_SINGLE_ARG_PARAMETER);
    ACE_TRY_CHECK;
    supplier_admin_ = ec_impl_->for_suppliers(ACE_ENV_SINGLE_ARG_PARAMETER);
    ACE_TRY_CHECK;

    this->reactor_ = reactor;
  }
  ACE_CATCHALL {
    return -1;
  }
  ACE_ENDTRY;
  return 0;
}


RtEventChannelAdmin::handle_t
Kokyu_EC::register_consumer (
        const char * entry_point,
        const RtEventChannelAdmin::SchedInfo & info,
        RtecEventComm::EventType type,
        RtecEventComm::PushConsumer_ptr consumer,
        RtecEventChannelAdmin::ProxyPushSupplier_out proxy_supplier
        ACE_ENV_ARG_DECL
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
        , RtecScheduler::UNKNOWN_TASK
        , RtecScheduler::INTERNAL
        , RtecScheduler::SYNCHRONIZATION_FAILURE
      ))
{
  RtecScheduler::handle_t consumer1_rt_info =
    scheduler_impl_->create (entry_point ACE_ENV_ARG_PARAMETER);
  ACE_TRY_CHECK;

  scheduler_impl_->set (consumer1_rt_info,
    info.criticality,
    info.wc_time,
    info.typical_time,
    info.cached_time,
    info.period,
    info.importance,
    info.quantum,
    info.threads,
    info.info_type
    ACE_ENV_ARG_PARAMETER);
  ACE_TRY_CHECK;

  ACE_ConsumerQOS_Factory consumer_qos1;

  if (type != ACE_ES_EVENT_INTERVAL_TIMEOUT)
    consumer_qos1.insert_type (type,  consumer1_rt_info);
  else
    consumer_qos1.insert_time (ACE_ES_EVENT_INTERVAL_TIMEOUT,
                               info.period, //in 100s of nanosec
                               consumer1_rt_info);


  proxy_supplier =
    consumer_admin_->obtain_push_supplier (ACE_ENV_SINGLE_ARG_PARAMETER);
  ACE_TRY_CHECK;

  proxy_supplier->connect_push_consumer (consumer,
    consumer_qos1.get_ConsumerQOS ()
    ACE_ENV_ARG_PARAMETER);
  ACE_TRY_CHECK;
  return consumer1_rt_info;
}

RtEventChannelAdmin::handle_t
Kokyu_EC::register_supplier (
        const char * entry_point,
        RtecEventComm::EventSourceID source,
        RtecEventComm::EventType type,
        RtecEventComm::PushSupplier_ptr supplier,
        RtecEventChannelAdmin::ProxyPushConsumer_out proxy_consumer
        ACE_ENV_ARG_DECL
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
        , RtecScheduler::UNKNOWN_TASK
        , RtecScheduler::INTERNAL
        , RtecScheduler::SYNCHRONIZATION_FAILURE
      ))
{
  RtecScheduler::handle_t supplier1_rt_info =
    scheduler_impl_->create (entry_point ACE_ENV_ARG_PARAMETER);
  ACE_TRY_CHECK;

  ACE_SupplierQOS_Factory supplier_qos1;
  supplier_qos1.insert (source,
    type,
    supplier1_rt_info,
    1 /* number of calls, but what does that mean? */);

  proxy_consumer =
    supplier_admin_->obtain_push_consumer (ACE_ENV_SINGLE_ARG_PARAMETER);
  ACE_TRY_CHECK;

  proxy_consumer->connect_push_supplier (supplier,
    supplier_qos1.get_SupplierQOS ()
    ACE_ENV_ARG_PARAMETER);
  ACE_TRY_CHECK;
  return supplier1_rt_info;
}

void
Kokyu_EC::add_dependency (
        RtEventChannelAdmin::handle_t handle,
        RtEventChannelAdmin::handle_t dependency,
        CORBA::Long number_of_calls,
        RtecScheduler::Dependency_Type_t dependency_type
        ACE_ENV_ARG_DECL
      )
      ACE_THROW_SPEC ((
        CORBA::SystemException
        , RtecScheduler::SYNCHRONIZATION_FAILURE
        , RtecScheduler::UNKNOWN_TASK
      ))
{
      scheduler_impl_->add_dependency (handle,
                                 dependency,
                                 number_of_calls,
                                 dependency_type
                                 ACE_ENV_ARG_PARAMETER);
}

void
Kokyu_EC::start (ACE_ENV_SINGLE_ARG_DECL)
      ACE_THROW_SPEC ((
        CORBA::SystemException
        , RtecScheduler::UNKNOWN_TASK
        , RtecScheduler::INTERNAL
        , RtecScheduler::SYNCHRONIZATION_FAILURE
      ))
{
      RtecScheduler::RT_Info_Set_var infos;
      RtecScheduler::Config_Info_Set_var configs;
      RtecScheduler::Dependency_Set_var dependencies;
      RtecScheduler::Scheduling_Anomaly_Set unsafe_anomalies;
      RtecScheduler::Scheduling_Anomaly_Set_var anomalies;

      int min_os_priority =
        ACE_Sched_Params::priority_min (ACE_SCHED_FIFO,
                                        ACE_SCOPE_THREAD);
      int max_os_priority =
        ACE_Sched_Params::priority_max (ACE_SCHED_FIFO,
                                        ACE_SCOPE_THREAD);
      scheduler_impl_->compute_scheduling (min_os_priority,
                                     max_os_priority,
                                     infos.out (),
                                     dependencies.out (),
                                     configs.out (),
                                     anomalies.out ()
                                     ACE_ENV_ARG_PARAMETER);
      ACE_TRY_CHECK;
      ec_impl_->activate (ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;

      //@BT: EC activated is roughly equivalent to having the DT scheduler ready to run
      //DSTRM_EVENT (MAIN_GROUP_FAM, SCHEDULER_STARTED, 1, 0, NULL);
      ACE_DEBUG((LM_DEBUG,"Kokyu_EC thread %t SCHEDULER_STARTED at %u\n",ACE_OS::gettimeofday().msec()));
}

RtecEventChannelAdmin::EventChannel_ptr
Kokyu_EC::event_channel (ACE_ENV_SINGLE_ARG_DECL)
      ACE_THROW_SPEC ((CORBA::SystemException))
{
  return ec_impl_->_this(ACE_ENV_SINGLE_ARG_PARAMETER);
}

RtecScheduler::Scheduler_ptr
Kokyu_EC::scheduler (ACE_ENV_SINGLE_ARG_DECL)
      ACE_THROW_SPEC ((CORBA::SystemException))
{
  return RtecScheduler::Scheduler::_duplicate(scheduler_.in());
}

///Takes ownership of Supplier and Timeout_Consumer
void
Kokyu_EC::add_supplier_with_timeout(
                                    Supplier * supplier_impl,
                                    const char * supp_entry_point,
                                    RtecEventComm::EventType supp_type,
                                    Supplier_Timeout_Handler * timeout_handler_impl,
                                    ACE_Time_Value phase,
                                    ACE_Time_Value period
                                    ACE_ENV_ARG_DECL
                                    )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  add_supplier(supplier_impl,supp_entry_point,supp_type ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;

  if (this->reactor_ != 0)
    {
      long timer_handle = this->reactor_->schedule_timer(timeout_handler_impl,
                                                         0, //arg
                                                         phase, //delay
                                                         period //period
                                                         );
      this->timer_handles_.push_back(timer_handle);
      this->timeout_handlers_.push_back(timeout_handler_impl);
    }
} //add_supplier_with_timeout()
/*
///Takes ownership of Supplier and Timeout_Consumer
void
Kokyu_EC::add_supplier_with_timeout(
                                    Supplier * supplier_impl,
                                    const char * supp_entry_point,
                                    RtecEventComm::EventType supp_type,
                                    Timeout_Consumer * timeout_consumer_impl,
                                    const char * timeout_entry_point,
                                    ACE_Time_Value period,
                                    RtecScheduler::Criticality_t crit,
                                    RtecScheduler::Importance_t imp
                                    ACE_ENV_ARG_DECL
                                    )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  add_supplier(supplier_impl,supp_entry_point,supp_type ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;
  add_timeout_consumer(supplier_impl,timeout_consumer_impl,timeout_entry_point,period,crit,imp ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;
}

///Takes ownership of Timeout_Consumer
void
Kokyu_EC::add_timeout_consumer(
                               Supplier * supplier_impl,
                               Timeout_Consumer * timeout_consumer_impl,
                               const char * timeout_entry_point,
                               ACE_Time_Value period,
                               RtecScheduler::Criticality_t crit,
                               RtecScheduler::Importance_t imp
                               ACE_ENV_ARG_DECL
                               )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  RtecEventChannelAdmin::ProxyPushSupplier_var timeout_supplier_proxy;
  RtecEventComm::PushConsumer_var safe_timeout_consumer;

  safe_timeout_consumer= timeout_consumer_impl->_this(ACE_ENV_SINGLE_ARG_PARAMETER);
  ACE_CHECK;

  RtEventChannelAdmin::SchedInfo info;
  info.criticality = crit;
  info.period = time_val_to_period (period);
  info.importance = imp;
  info.threads = 0;
  info.info_type = RtecScheduler::OPERATION;

  RtecScheduler::handle_t supplier_timeout_consumer_rt_info =
    this->register_consumer(timeout_entry_point,
                            info,
                            ACE_ES_EVENT_INTERVAL_TIMEOUT,
                            safe_timeout_consumer.in(),
                            timeout_supplier_proxy.out()
                            ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;
  //don't need to save supplier_timeout_consumer_rt_info because only used to set dependency here:

  this->add_dependency (supplier_timeout_consumer_rt_info,
                        supplier_impl->rt_info(),
                        1,
                        RtecBase::TWO_WAY_CALL
                        ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;

  this->timeout_consumers_.push_back(timeout_consumer_impl);
} //add_supplier_with_timeout()
*/
///Takes ownership of Supplier
void
Kokyu_EC::add_supplier(
                       Supplier * supplier_impl,
                       const char * entry_point,
                       RtecEventComm::EventType type
                       ACE_ENV_ARG_DECL
                       )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  RtecEventComm::EventSourceID supplier_id = supplier_impl->get_id();

  RtecEventChannelAdmin::ProxyPushConsumer_var consumer_proxy;
  RtecEventComm::PushSupplier_var supplier;

  supplier = supplier_impl->_this(ACE_ENV_SINGLE_ARG_PARAMETER);
  ACE_CHECK;

  RtecScheduler::handle_t supplier_rt_info =
    this->register_supplier(entry_point,
                            supplier_id,
                            type,
                            supplier.in(),
                            consumer_proxy.out()
                            ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;

  supplier_impl->set_consumer_proxy(consumer_proxy.in());
  supplier_impl->rt_info(supplier_rt_info);

  this->suppliers_.push_back(supplier_impl);
} //add_supplier()

///Takes ownership of Consumer and Supplier
void
Kokyu_EC::add_consumer_with_supplier(
                                     Consumer * consumer_impl,
                                     const char * cons_entry_point,
                                     ACE_Time_Value cons_period,
                                     RtecEventComm::EventType cons_type,
                                     RtecScheduler::Criticality_t cons_crit,
                                     RtecScheduler::Importance_t cons_imp,
                                     Supplier * supplier_impl,
                                     const char * supp_entry_point,
                                     RtecEventComm::EventType supp_type
                                     ACE_ENV_ARG_DECL
                                     )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  add_consumer(consumer_impl,cons_entry_point,cons_period,cons_type,cons_crit,cons_imp ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;
  add_supplier(supplier_impl,supp_entry_point,supp_type ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;

  this->add_dependency (consumer_impl->rt_info(),
                        supplier_impl->rt_info(),
                        1,
                        RtecBase::TWO_WAY_CALL
                        ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;
} //add_consumer_with_supplier()

///Takes ownership of Consumer
void
Kokyu_EC::add_consumer(
                       Consumer * consumer_impl,
                       const char * entry_point,
                       ACE_Time_Value period,
                       RtecEventComm::EventType cons_type,
                       RtecScheduler::Criticality_t crit,
                       RtecScheduler::Importance_t imp
                       ACE_ENV_ARG_DECL
                       )
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  RtecEventChannelAdmin::ProxyPushSupplier_var  proxy_supplier;

  //Specifying criticality is crucial since it propagates from
  //consumer to supplier.
  RtEventChannelAdmin::SchedInfo info;
  info.criticality = crit;
  info.period = time_val_to_period (period);
  info.importance = imp;
  info.threads = 0;
  info.info_type = RtecScheduler::OPERATION;

  RtecEventComm::PushConsumer_var consumer =
    consumer_impl->_this (ACE_ENV_SINGLE_ARG_PARAMETER);
  ACE_CHECK;

  RtecScheduler::handle_t consumer_rt_info =
    this->register_consumer(entry_point,
                            info,
                            cons_type,
                            consumer.in(),
                            proxy_supplier.out()
                            ACE_ENV_ARG_PARAMETER);
  ACE_CHECK;

  consumer_impl->rt_info(consumer_rt_info);

  this->consumers_.push_back(consumer_impl);
} //add_consumer()

void
Kokyu_EC::set_up_last_subtask (subtask_t subtask,
                               RtecEventComm::EventType in_type ACE_ENV_ARG_DECL)
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  Consumer * consumer_impl;
  ACE_NEW(consumer_impl,
          Consumer());

  consumer_impl->setWorkTime(subtask.exec);

  std::stringstream cons_entry;
  cons_entry << "consumer" << subtask.task_index << "_" << subtask.subtask_index;

  add_consumer(consumer_impl, //stores impl inside Kokyu_EC
               cons_entry.str().c_str(),
               subtask.period,
               in_type,
               RtecScheduler::VERY_LOW_CRITICALITY,
               RtecScheduler::VERY_LOW_IMPORTANCE
               ACE_ENV_ARG_PARAMETER
               );
  ACE_CHECK;

} //set_up_last_subtask()

void
Kokyu_EC::set_up_first_subtask (subtask_t subtask,
                                RtecEventComm::EventSourceID supp_id1, RtecEventComm::EventSourceID supp_id2,
                                RtecEventComm::EventType in_type, RtecEventComm::EventType out_type ACE_ENV_ARG_DECL)
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  Supplier *supplier_impl;
  Supplier_Timeout_Handler *timeout_handler_impl;
  ACE_NEW(supplier_impl,
          Supplier(supp_id1));
  ACE_NEW(timeout_handler_impl,
          Supplier_Timeout_Handler(supplier_impl));

  std::stringstream supp_entry;
  supp_entry << "supplier" << subtask.task_index << "_" << subtask.subtask_index;

  add_supplier_with_timeout(supplier_impl, //stores impl inside Kokyu_EC
                            supp_entry.str().c_str(),
                            in_type,
                            timeout_handler_impl, //stores impl inside Kokyu_EC
                            subtask.phase,
                            subtask.period
                            ACE_ENV_ARG_PARAMETER
                            );
  ACE_CHECK;

  Supplier *next_supplier_impl;
  ACE_NEW(next_supplier_impl,
          Supplier(supp_id2));
  Consumer * consumer_impl;
  ACE_NEW(consumer_impl,
          Consumer(next_supplier_impl));

  consumer_impl->setWorkTime(subtask.exec);

  std::stringstream cons_entry;
  cons_entry << "consumer" << subtask.task_index << "_" << subtask.subtask_index;

  std::stringstream next_entry;
  next_entry << "supplier" << subtask.task_index << "_" << (subtask.subtask_index+1);

  add_consumer_with_supplier(consumer_impl, //stores impl inside Kokyu_EC
                             cons_entry.str().c_str(),
                             subtask.period,
                             in_type,
                             RtecScheduler::VERY_LOW_CRITICALITY,
                             RtecScheduler::VERY_LOW_IMPORTANCE,
                             next_supplier_impl, //stores impl inside Kokyu_EC
                             next_entry.str().c_str(),
                             out_type
                             ACE_ENV_ARG_PARAMETER
                             );
  ACE_CHECK;

} //set_up_first_subtask

void
Kokyu_EC::set_up_middle_subtask (subtask_t subtask,
                                 RtecEventComm::EventSourceID supp_id,
                                 RtecEventComm::EventType in_type, RtecEventComm::EventType out_type ACE_ENV_ARG_DECL)
  ACE_THROW_SPEC ((
                   CORBA::SystemException
                   , RtecScheduler::UNKNOWN_TASK
                   , RtecScheduler::INTERNAL
                   , RtecScheduler::SYNCHRONIZATION_FAILURE
                   ))
{
  Supplier *next_supplier_impl;
  ACE_NEW(next_supplier_impl,
          Supplier(supp_id));
  Consumer * consumer_impl;
  ACE_NEW(consumer_impl,
          Consumer(next_supplier_impl));

  consumer_impl->setWorkTime(subtask.exec);

  std::stringstream cons_entry;
  cons_entry << "consumer" << subtask.task_index << "_" << subtask.subtask_index;

  std::stringstream next_entry;
  next_entry << "supplier" << subtask.task_index << "_" << (subtask.subtask_index+1);

  add_consumer_with_supplier(consumer_impl, //stores impl inside Kokyu_EC
                             cons_entry.str().c_str(),
                             subtask.period,
                             in_type,
                             RtecScheduler::VERY_LOW_CRITICALITY,
                             RtecScheduler::VERY_LOW_IMPORTANCE,
                             next_supplier_impl, //stores impl inside Kokyu_EC
                             next_entry.str().c_str(),
                             out_type
                             ACE_ENV_ARG_PARAMETER
                             );
  ACE_CHECK;

} //set_up_middle_subtask()
