// $Id$

#include "ace/SString.h"
#include "ace/Get_Opt.h"
#include "ace/Sched_Params.h"
#include "ace/Thread.h"
#include "ace/OS_NS_sys_time.h"
#include "ace/OS_NS_stdlib.h" //for rand()
#include "ace/Select_Reactor_Base.h" //for ACE_Select_Reactor_Impl::DEFAULT_SIZE
#include "ace/Map.h"
#include "ace/Vector_T.h"

#include "orbsvcs/Event/EC_Gateway_IIOP_Factory.h"
#include "orbsvcs/Event/EC_Gateway_Sched.h"
#include "orbsvcs/Event/EC_Kokyu_Factory.h"
#include "orbsvcs/Time_Utilities.h"
#include "orbsvcs/Event_Service_Constants.h"
#include "orbsvcs/Scheduler_Factory.h"
#include "tao/ORB_Core.h"

#include "Kokyu_EC.h"
#include "Consumer.h"
#include "Supplier.h"
#include "Service_Handler.h"
#include "Dynamic_Supplier.h"

#ifdef ACE_HAS_DSUI
#include <dsui.h>
#include "federated_config.h"
#include "federated_dsui_families.h"
#endif //ACE_HAS_DSUI

namespace
{
  int mode_switch = -1; //default to random switching
  ACE_CString sched_type = "rms";
  ACE_CString ior_output_filename;
  FILE * ior_output_file;

  typedef ACE_Vector<const char*> Filename_Array;
  Filename_Array ior_input_files;
}

class Mode_Handler: public Service_Handler
{
public:
  //Switches Supplier from NORMAL mode to FAULT_TOLERANT after
  //switch_at_event handle_service_start()s. If switch_at_event = -1, then switching happens randomly.
  Mode_Handler(long switch_at_event)
    : switch_(switch_at_event)
  {
  }

  virtual ~Mode_Handler(void)
  {
  }

  ///Takes ownership of the Timeout_Handler ONLY.
  void init (Supplier *supplier)
  {
    this->supplier_ = supplier;
  }

  virtual void handle_service_start(ACE_ENV_SINGLE_ARG_DECL)
    ACE_THROW_SPEC ((
                     CORBA::SystemException
                     , RtecScheduler::UNKNOWN_TASK
                     , RtecScheduler::INTERNAL
                     , RtecScheduler::SYNCHRONIZATION_FAILURE
                     ))
  {
    if (this->switch_ >= 0)
      {
        //switch to FAULT_TOLERANT after a certain number of Task servicings
        if (this->switch_ == 0)
          {
            ACE_DEBUG((LM_DEBUG,"Mode_Handler (%P|%t) handle_service_start() START\n"));

            this->supplier_->mode(Supplier::FAULT_TOLERANT);

            ACE_DEBUG((LM_DEBUG,"Mode_Handler (%P|%t) handle_service_start() END\n"));
          }
        else
          {
            this->switch_--;
          }
      }
    else
      {
        //randomly choose mode
        if (rand() > RAND_MAX/2.0)
          {
            this->supplier_->mode(Supplier::FAULT_TOLERANT);
          }
        else
          {
            this->supplier_->mode(Supplier::NORMAL);
          }
      }
  }

  virtual void handle_service_stop(ACE_ENV_SINGLE_ARG_DECL)
  {
    ACE_DEBUG((LM_DEBUG,"Mode_Handler (%P|%t) handle_service_stop() START\n"));
    ACE_DEBUG((LM_DEBUG,"Mode_Handler (%P|%t) handle_service_stop() END\n"));
  }

private:
  int switch_;

  Supplier * supplier_;
}; //class Mode_Handler

class Supplier_EC : public Kokyu_EC
{
  //need to handle multiple gateways!
  typedef ACE_Map_Manager<const char*,TAO_EC_Gateway_Sched*,ACE_Thread_Mutex> Gateway_Map;
  Gateway_Map gateways;

  Service_Handler *handler_;
public:
  Supplier_EC()
  {
    this->gateways.open();
  } //Supplier_EC()

  ~Supplier_EC(void)
  {
    //TODO: close down gateways

    //now delete them and their IOR strings
    Gateway_Map::iterator iter = this->gateways.begin();
    Gateway_Map::iterator done = this->gateways.end();
    while(iter != done)
      {
        Gateway_Map::ENTRY entry = *iter;

        Gateway_Map::KEY key = entry.ext_id_;
        Gateway_Map::VALUE val = entry.int_id_;
        //we can delete as long as we don't unbind
        //don't delete keys since we didn't allocate them
        delete key;
        delete val;

        ++iter;
      }
    this->gateways.unbind_all();

    this->gateways.close();
  } //~Supplier_EC()

  void init_gateway(CORBA::ORB_ptr orb,
                    PortableServer::POA_ptr poa,
                    const char* consumer_ec_ior)
  {
    if (this->gateways.find(consumer_ec_ior) == 0)
      {
        //Already a gateway for that EC
        ACE_DEBUG((LM_DEBUG,"Supplier_EC (%P|%t) init_gateway(): Tried to create already-existing gateway for %s\n",
                   consumer_ec_ior));
        return;
      }

      CORBA::Object_var obj;
      RtEventChannelAdmin::RtSchedEventChannel_var supplier_ec, consumer_ec;
      ACE_CHECK;

      obj = orb->string_to_object(consumer_ec_ior ACE_ENV_ARG_PARAMETER);
      ACE_CHECK;

      //WARNING: if consumer_ec_ior is not a readable file, obj is null!
      consumer_ec = RtEventChannelAdmin::RtSchedEventChannel::_narrow(obj.in()
                                                                      ACE_ENV_ARG_PARAMETER);
      ACE_CHECK;

      RtecEventChannelAdmin::EventChannel_var supplier_event_channel =
        this->event_channel(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_CHECK;

      RtecEventChannelAdmin::EventChannel_var consumer_event_channel =
        consumer_ec->event_channel(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_CHECK;

      RtecScheduler::Scheduler_var supplier_scheduler =
        this->scheduler(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_CHECK;

      RtecScheduler::Scheduler_var consumer_scheduler =
        consumer_ec->scheduler(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_CHECK;

      TAO_EC_Gateway_Sched *gateway;
      ACE_NEW(gateway,
              TAO_EC_Gateway_Sched() );

      gateway->init(supplier_event_channel.in(),
                    consumer_event_channel.in(),
                    supplier_scheduler.in(),
                    consumer_scheduler.in(),
                    "gateway1", consumer_ec_ior
                    ACE_ENV_ARG_PARAMETER);

      this->gateways.bind(consumer_ec_ior,gateway);

      ACE_CHECK;
            PortableServer::ObjectId_var gateway_oid =
         poa->activate_object(gateway ACE_ENV_ARG_PARAMETER);
      ACE_CHECK;

      CORBA::Object_var gateway_obj =
         poa->id_to_reference(gateway_oid.in() ACE_ENV_ARG_PARAMETER);
      ACE_CHECK;

       RtecEventChannelAdmin::Observer_var obs =
         RtecEventChannelAdmin::Observer::_narrow(gateway_obj.in() ACE_ENV_ARG_PARAMETER);
      ACE_CHECK;

      RtecEventChannelAdmin::Observer_Handle local_ec_obs_handle =
         consumer_event_channel->append_observer (obs.in () ACE_ENV_ARG_PARAMETER);
      ACE_UNUSED_ARG(local_ec_obs_handle);
      ACE_CHECK;

      consumer_ec->start(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_CHECK;
  }

  virtual void start (ACE_ENV_SINGLE_ARG_DECL)
      ACE_THROW_SPEC ((
        CORBA::SystemException
        , RtecScheduler::UNKNOWN_TASK
        , RtecScheduler::INTERNAL
        , RtecScheduler::SYNCHRONIZATION_FAILURE
      ))
  {
    RtecEventComm::EventType supp1_1_normal_type = ACE_ES_EVENT_UNDEFINED;
    RtecEventComm::EventType supp1_1_ft_type = ACE_ES_EVENT_UNDEFINED+1;
    Kokyu_EC::EventType_Vector supp1_1_types(2);
    supp1_1_types.push_back(supp1_1_normal_type);
    supp1_1_types.push_back(supp1_1_ft_type);
    Kokyu_EC::EventType_Vector cons1_1_types(2);
    cons1_1_types.push_back(supp1_1_normal_type);
    cons1_1_types.push_back(supp1_1_ft_type);

    Mode_Handler *mode_handler;
    ACE_NEW(mode_handler,
            Mode_Handler(mode_switch)); //mode switch immediately
    Supplier *supplier_impl1_1;
    Timeout_Consumer *timeout_consumer_impl1_1;
    ACE_NEW(supplier_impl1_1,
            Supplier(1,supp1_1_normal_type,supp1_1_ft_type,mode_handler));
    mode_handler->init(supplier_impl1_1);
    this->handler_ = mode_handler;
    ACE_NEW(timeout_consumer_impl1_1,
            Timeout_Consumer(supplier_impl1_1));
    ACE_Time_Value tv(0,200000); //period
    add_supplier_with_timeout(supplier_impl1_1,
                              "supplier1_1",
                              supp1_1_types,
                              timeout_consumer_impl1_1,
                              "supplier1_1_timeout_consumer",
                              tv,
                              RtecScheduler::VERY_LOW_CRITICALITY,
                              RtecScheduler::VERY_LOW_IMPORTANCE
                              ACE_ENV_ARG_PARAMETER
                              );
    ACE_CHECK;

    RtecEventComm::EventType supp1_2_normal_type1 = ACE_ES_EVENT_UNDEFINED+2;
    RtecEventComm::EventType supp1_2_normal_type2 = ACE_ES_EVENT_UNDEFINED+3;
    RtecEventComm::EventType supp1_2_ft_type1 = ACE_ES_EVENT_UNDEFINED+4;
    RtecEventComm::EventType supp1_2_ft_type2 = ACE_ES_EVENT_UNDEFINED+5;
    Kokyu_EC::EventType_Vector supp1_2_types(4);
    supp1_2_types.push_back(supp1_2_normal_type1);
    supp1_2_types.push_back(supp1_2_normal_type2);
    supp1_2_types.push_back(supp1_2_ft_type1);
    supp1_2_types.push_back(supp1_2_ft_type2);

    Supplier *supplier_impl1_2;
    /*
    ACE_NEW(supplier_impl1_2,
            Supplier(2,supp1_2_normal_type1,supp1_2_ft_type1));
    */
    ACE_NEW(supplier_impl1_2,
            Dynamic_Supplier(2,
                             supp1_2_normal_type1,supp1_2_normal_type2,
                             supp1_2_ft_type1,supp1_2_ft_type2));

    Consumer * consumer_impl1_1;
    ACE_NEW(consumer_impl1_1,
            Consumer(supp1_1_normal_type,supp1_1_ft_type,supplier_impl1_2));

    tv.set(0,50000);
    consumer_impl1_1->setWorkTime(tv);
    //consumer's rate will get propagated from the supplier.
    //so no need to specify a period here.
    tv.set(0,200000); //Period
    add_consumer_with_supplier(consumer_impl1_1, //deleted in consumer
                               "consumer1_1",
                               tv,
                               cons1_1_types,
                               RtecScheduler::VERY_LOW_CRITICALITY,
                               RtecScheduler::VERY_LOW_IMPORTANCE,
                               supplier_impl1_2,
                               "supplier1_2",
                               supp1_2_types
                               ACE_ENV_ARG_PARAMETER
                               );
    ACE_CHECK;

    EventType_Vector types(4);
    for(RtecEventComm::EventType type = ACE_ES_EVENT_UNDEFINED+2;
        type <= ACE_ES_EVENT_UNDEFINED+9; type++)
      {
        types.push_back(type);
      }

    add_dummy_supplier(types);
    ACE_CHECK;
    /*
    //DEBUG: print out schedule
    RtecScheduler::Scheduler_ptr scheduler = this->scheduler(ACE_ENV_SINGLE_ARG_PARAMETER);
    //RtecEventChannelAdmin::EventChannel_ptr event_channel = this->event_channel(ACE_ENV_SINGLE_ARG_DECL);

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

    scheduler->compute_scheduling (min_os_priority,
                                   max_os_priority,
                                   infos.out (),
                                   dependencies.out (),
                                   configs.out (),
                                   anomalies.out ()
                                   ACE_ENV_ARG_PARAMETER);
    ACE_TRY_CHECK;

    std::stringstream sched_out;
    ACE_CString ior_prefix(ior_output_filename.c_str(),ior_output_filename.length()-4); //cut off '.ior'
    sched_out << "schedule_" << ior_prefix.c_str() << ".out";

    ACE_DEBUG((LM_DEBUG,"Supplier_EC writing schedule to %s\n",sched_out.str().c_str()));

    ACE_Scheduler_Factory::dump_schedule (infos.in (),
                                          dependencies.in (),
                                          configs.in (),
                                          anomalies.in (),
                                          sched_out.str().c_str());
    *///END DEBUG
    Kokyu_EC::start(ACE_ENV_SINGLE_ARG_PARAMETER);
    ACE_CHECK;
  } //start()
};

int parse_args (int argc, char *argv[]);

int
main (int argc, char* argv[])
{
  srand(42);

  //TAO_EC_Default_Factory::init_svcs ();
  TAO_EC_Kokyu_Factory::init_svcs ();
  TAO_EC_Gateway_IIOP_Factory::init_svcs ();

  ACE_DECLARE_NEW_CORBA_ENV;
  ACE_TRY
    {
#ifdef ACE_HAS_DSUI
      ds_control ds_cntl("Dynamic_Test_Supplier","supplier_enabled.dsui");
#endif //ACE_HAS_DSUI

      // ORB initialization boiler plate...
      CORBA::ORB_var orb =
        CORBA::ORB_init (argc, argv, "" ACE_ENV_ARG_PARAMETER);
      ACE_TRY_CHECK;

      if (parse_args (argc, argv) == -1)
        {
          return 1;
        }

      CORBA::Object_var object =
        orb->resolve_initial_references ("RootPOA" ACE_ENV_ARG_PARAMETER);
      ACE_TRY_CHECK;
      PortableServer::POA_var poa =
        PortableServer::POA::_narrow (object.in () ACE_ENV_ARG_PARAMETER);
      ACE_TRY_CHECK;
      PortableServer::POAManager_var poa_manager =
        poa->the_POAManager (ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;
      poa_manager->activate (ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;

      //spawn thread to run the reactor event loop
      Reactor_Task rt;
      rt.initialize();

      // ****************************************************************

      Supplier_EC supplier_ec;
      if (supplier_ec.init(sched_type.c_str(), poa.in()) == -1)
        {
          ACE_ERROR_RETURN((LM_ERROR, "Unable to initialize Kokyu_EC"), 1);
        }

      for(size_t i=0; i<ior_input_files.size(); ++i)
        {
          Filename_Array::TYPE filename = ior_input_files[i];
          supplier_ec.init_gateway(orb.in(),
                                   poa.in(),
                                   filename
                                   ACE_ENV_ARG_PARAMETER);
          ACE_TRY_CHECK;
        }

      // ****************************************************************
      RtEventChannelAdmin::RtSchedEventChannel_var supplier_ec_ior =
        supplier_ec._this(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;

      CORBA::String_var ior = orb->object_to_string(supplier_ec_ior.in()
                                                    ACE_ENV_ARG_PARAMETER);

      ACE_OS::fprintf(ior_output_file, ior.in());
      ACE_OS::fclose(ior_output_file);


      ACE_hthread_t thr_handle;
      ACE_Thread::self (thr_handle);

      int prio = ACE_Sched_Params::priority_max (ACE_SCHED_FIFO);
      ACE_OS::thr_setprio (thr_handle, prio);

      supplier_ec.start(ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;

      //@BT: Timeouts start when orb starts, similar to starting the DT worker thread
      //DSTRM_EVENT (MAIN_GROUP_FAM, WORKER_ACTIVATED, 1, 0, NULL);
      ACE_DEBUG((LM_DEBUG,"Supplier_EC thread %t WORKER_ACTIVATED at %u\n",ACE_OS::gettimeofday().msec()));
      DSTRM_EVENT (MAIN_GROUP_FAM, WORKER_ACTIVATED, 0, 0, NULL);
      //DSTRM_EVENT (WORKER_GROUP_FAM, WORKER_STARTED, m_id, 0, NULL);
      ACE_DEBUG((LM_DEBUG,"Supplier_EC thread %t WORKER_STARTED at %u\n",ACE_OS::gettimeofday().msec()));
      DSTRM_EVENT (WORKER_GROUP_FAM, WORKER_STARTED, 0, 0, NULL);

#ifdef ACE_HAS_DSUI
      //@BT
      //DSTRM_EVENT(MAIN_GROUP_FAM, START,1,0,NULL);
      ACE_Time_Value now(ACE_OS::gettimeofday());
      ACE_OS::printf("Supplier_EC START at %isec %iusec\n",now.sec(),now.usec());
      DSTRM_EVENT(MAIN_GROUP_FAM, START,0,0,NULL);
#endif //ACE_HAS_DSUI

      rt.activate(); //need thread creation flags? or priority?
      ACE_Time_Value stop_time(300,0);
      orb->run (stop_time ACE_ENV_ARG_PARAMETER);
      //orb->run (ACE_ENV_SINGLE_ARG_PARAMETER);
      ACE_TRY_CHECK;

#ifdef ACE_HAS_DSUI
      //@BT
      //DSTRM_EVENT(MAIN_GROUP_FAM, STOP, 1, 0, NULL);
      ACE_DEBUG((LM_DEBUG,"Supplier_EC thread %t STOP at %u\n",ACE_OS::gettimeofday().msec()));
      DSTRM_EVENT(MAIN_GROUP_FAM, STOP, 1, 0, NULL);
#endif //ACE_HAS_DSUI

      // ****************************************************************

      // We should do a lot of cleanup (disconnect from the EC,
      // deactivate all the objects with the POA, etc.) but this is
      // just a simple demo so we are going to be lazy.

    }
  ACE_CATCHANY
    {
      ACE_PRINT_EXCEPTION (ACE_ANY_EXCEPTION, "Supplier_EC");
      return 1;
    }
  ACE_ENDTRY;

  return 0;
}

// ****************************************************************

int parse_args (int argc, char *argv[])
{
  ACE_Get_Opt get_opts (argc, argv, "s:o:i:m:");
  int c;
  //these used for handling '-i':
  const char* input_file;
  size_t len;
  char *filename;

  while ((c = get_opts ()) != -1)
    switch (c)
      {
      case 'o':
        ior_output_filename = get_opts.opt_arg();
        ior_output_file = ACE_OS::fopen (ior_output_filename.c_str(), "w");
        if (ior_output_file == 0)
          {
            ACE_ERROR_RETURN ((LM_ERROR,
                               "Unable to open %s for writing: %p\n",
                               get_opts.opt_arg ()), -1);
          }
        break;
      case 'i':
        input_file = get_opts.opt_arg();
        len = ACE_OS::strlen("file://")+ACE_OS::strlen(input_file)+1;
        filename = new char[len];
        sprintf(filename,"file://%s",input_file);
        ACE_DEBUG((LM_DEBUG,"Adding consumer IOR %s\n",filename));
        ior_input_files.push_back(filename);
        break;
      case 's':
        sched_type = ACE_TEXT_ALWAYS_CHAR(get_opts.opt_arg ());
        break;
      case 'm':
        mode_switch = ACE_OS::atoi(get_opts.opt_arg());
        ACE_DEBUG((LM_DEBUG,"Setting mode switch to %i\n",mode_switch));
        break;

      case '?':
      default:
        ACE_ERROR_RETURN ((LM_ERROR,
                           "Usage:  %s -s <rms|muf|edf>"
                           " [-o iorfile]"
                           " [-i consumer_ec_ior]"
                           " [-m mode]"
                           "\n"
                           "For multiple consumers, specify -i multiple times\n"
                           "Mode is number of iterations before going to FT mode;"
                             "-1 randomly switches modes\n",
                           argv [0]),
                          -1);
      }
  if (ior_output_file == 0)
    {
      ior_output_filename = "supplier_ec.ior";
      ior_output_file = ACE_OS::fopen (ior_output_filename.c_str(), "w");
    }
  if (ior_input_files.size() == 0)
    {
      ior_input_files.push_back(strdup("file://consumer_supplier_ec.ior"));
    }
  // Indicates sucessful parsing of the command line
  return 0;
}
