// $Id$
//
// ============================================================================
//
// = LIBRARY
//    sched
//
// = FILENAME
//    Scheduler_Generic.cpp
//
// = CREATION DATE
//    19 November 1997
//
// = AUTHOR
//    David Levine
//
// ============================================================================

#include "ace/Sched_Params.h"

#include "Scheduler_Generic.h"

#if ! defined (__ACE_INLINE__)
#include "Scheduler_Generic.i"
#endif /* __ACE_INLINE__ */


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// static functions
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

// Structure for storing the RT_Info information for each task, per mode.
struct Mode_Entry
{
  RtecScheduler::RT_Info *rt_info_;
  u_long start_time_; // microseconds
  u_long stop_time_;  // microseconds

  Mode_Entry() :
    rt_info_ (0),
    start_time_ (0),
    stop_time_ (0)
  {
  }

  Mode_Entry(RtecScheduler::RT_Info *const rt_info,
             const u_long start_time = 0,
             const u_long stop_time = 0) :
    rt_info_ (rt_info),
    start_time_ (start_time),
    stop_time_ (stop_time)
  {
  }

  ~Mode_Entry () {}

  Mode_Entry &operator= (const Mode_Entry &entry)
  {
    if (this != &entry)
      {
        rt_info_ = entry.rt_info_;
        start_time_ = entry.start_time_;
        stop_time_ = entry.stop_time_;
      }

    return *this;
  }
};


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// class Scheduler_Generic member functions
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

Scheduler_Generic::Scheduler_Generic () :
  Scheduler (),
  handles_ (0),
  // Set the minimum priority to that for the current platform.  This
  // shouldn't be necessary, but UPSingleProcessorOrb::initialize_reactors
  // creates threads before the Event Channel calls Scheduler::init ().
  minimum_priority_ (ACE_Sched_Params::priority_min (ACE_SCHED_FIFO,
                                                     ACE_SCOPE_THREAD)),
  increasing_priority_ (-1),
  task_entries_ ()
{
}


Scheduler_Generic::~Scheduler_Generic ()
{
  reset ();
}


void
Scheduler_Generic::reset ()
{
}

Scheduler::status_t
Scheduler_Generic::lookup_rt_info (handle_t handle,
                                   RT_Info*& rtinfo)
{
  if (handle < 0 || (size_t) handle > task_entries_.size ())
    {
      return ST_UNKNOWN_TASK;
    }
  RT_Info*** entry;
  ACE_Unbounded_Set_Iterator <RT_Info **> i (task_entries_);
  while (i.next (entry) != 0)
    {
      i.advance ();
      RT_Info** array = *entry;
      if (array[0]->handle == handle)
        {
          rtinfo = array[0];
          return SUCCEEDED;
        }
    }

  return ST_UNKNOWN_TASK;
}


Scheduler::status_t
Scheduler_Generic::register_task (RT_Info *rt_info [],
                                   const u_int number_of_modes,
                                   handle_t &handle)
{
  status_t ret;

  // try to store the new task's information . . .
  switch (task_entries_.insert (rt_info))
    {
      case 0 : // successfully inserted
        {
          rt_info [0]->handle = (handle = ++handles_);

          // assigned the same handle to the RT_Info for each of its modes
          for (u_int i = 1; i < number_of_modes; ++i)
            {
              if (rt_info [i] != 0)
                rt_info [i]->handle = handle;
            }

          if (number_of_modes > modes ())
            {
              modes (number_of_modes);
            }

          ret = SUCCEEDED;

          if (output_level () >= 5)
            {
              ACE_OS::printf ("registered task \"%s\" with RT_Info starting "
                                "at %X\n",
                              (const char*)rt_info[0]->entry_point,
                              (void *) rt_info[0]);
            }
        }
        break;

      case 1 : // the entry had already been inserted
        handle = 0;
        ret = ST_TASK_ALREADY_REGISTERED;
        break;

      default :
        // case -1 : insert failed, probably because virtual memory exhaused
        handle = 0;
        ret = ST_VIRTUAL_MEMORY_EXHAUSTED;
        break;
    }

  return ret;
}


void
Scheduler_Generic::init (const int minimum_priority,
                          const int maximum_priority,
                          const char *runtime_filename,
                          const char *rt_info_filename,
                          const char *timeline_filename)
{
  minimum_priority_ = minimum_priority;
  maximum_priority_ = maximum_priority;
  runtime_filename_ = runtime_filename;
  rt_info_filename_ = rt_info_filename;
  timeline_filename_ = timeline_filename;
}


Scheduler::status_t
Scheduler_Generic::schedule (void)
{
  ACE_Guard<LOCK> ace_mon (lock_);

  // here goes . . .

  increasing_priority_ = maximum_priority_ >= minimum_priority_;

  status_t status = ACE_Scheduler::SUCCEEDED;

  // store number of tasks, based on registrations
  tasks (task_entries_.size ());

  if (output_level () > 0)
    {
      print_schedule ();
    }

  return status;
}


int
Scheduler_Generic::priority (const handle_t handle,
                             OS_Thread_Priority &priority,
                             Sub_Priority &subpriority,
                             Preemption_Priority &preemption_prio,
                             const mode_t requested_mode) const
{
  ACE_UNUSED_ARG (handle);
  ACE_UNUSED_ARG (requested_mode);

  priority = minimum_priority_;
  subpriority = ACE_Scheduler_MIN_SUB_PRIORITY;
  preemption_prio = ACE_Scheduler_MAX_PREEMPTION_PRIORITY;

  if (output_level () >= 3)
    {
      ACE_OS::printf ("preemption_prio %d: min %d, pri %d, min_pri %d\n",
                      preemption_prio, minimum_priority_queue (),
                      priority, minimum_priority_);
    }

  return 0;
}


void
Scheduler_Generic::print_schedule ()
{
}

#if defined (ACE_HAS_EXPLICIT_TEMPLATE_INSTANTIATION)
template class ACE_Node<RtecScheduler::RT_Info **>;
template class ACE_Unbounded_Set<RtecScheduler::RT_Info **>;
template class ACE_Unbounded_Set_Iterator<RtecScheduler::RT_Info **>;
#elif defined(ACE_HAS_TEMPLATE_INSTANTIATION_PRAGMA)
#pragma instantiate ACE_Node<RtecScheduler::RT_Info **>
#pragma instantiate ACE_Unbounded_Set<RtecScheduler::RT_Info **>
#pragma instantiate ACE_Unbounded_Set_Iterator<RtecScheduler::RT_Info **>
#endif /* ACE_HAS_EXPLICIT_TEMPLATE_INSTANTIATION */


// EOF
