// -*- C++ -*-

//=============================================================================
/**
 *  @file   AMI_Primary_Replication_Strategy.h
 *
 *  $Id$
 *
 *  @author Huang-Ming Huang <hh1@cse.wustl.edu>
 */
//=============================================================================

#ifndef AMI_PRIMARY_REPLICATION_STRATEGY_H
#define AMI_PRIMARY_REPLICATION_STRATEGY_H

#include "UpdateableHandler.h"
#include "Replication_Strategy.h"
#include "orbsvcs/FtRtecEventChannelAdminC.h"
#include "ace/Task.h"

#if !defined (ACE_LACKS_PRAGMA_ONCE)
# pragma once
#endif /* ACE_LACKS_PRAGMA_ONCE */

/**
 * @class  AMI_Primary_Replication_Strategy.
 *
 * @brief Used by primary replicas when AMI calls are used for replicating requests.
 */

class AMI_Primary_Replication_Strategy : public Replication_Strategy
                               , public ACE_Task_Base
{
public:
  /**
   * @param mt Specifies whether multithreaded ORB is used. 
   */
  AMI_Primary_Replication_Strategy(bool mt);
  virtual ~AMI_Primary_Replication_Strategy();
  virtual int init();
  virtual void replicate_request(const FTRT::State& state,
                                 RollbackOperation rollback,
                                 const FtRtecEventChannelAdmin::ObjectId& oid
                                 ACE_ENV_ARG_DECL);
  virtual void add_member(const FTRT::ManagerInfo & info,
                          CORBA::ULong object_group_ref_version
                          ACE_ENV_ARG_DECL);
  virtual int  acquire_read (void);
  virtual int  acquire_write (void);
  virtual int  release (void);
  PortableServer::POA_ptr poa() { return poa_.in(); }
  CORBA::ORB_ptr orb() { return orb_.in();}
private:
  virtual int svc (void);
  CORBA::ORB_var orb_;
  PortableServer::POA_var root_poa_;
  PortableServer::POA_var poa_;
  PortableServer::POAManager_var mgr_;
  bool running_;
  UpdateableHandler handler_;
  ACE_RW_Thread_Mutex* mutex_;
};

#endif // AMI_PRIMARY_REPLICATION_STRATEGY_H
