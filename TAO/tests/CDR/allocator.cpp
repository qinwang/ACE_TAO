// $Id$

// ============================================================================
//
// = LIBRARY
//    TAO/tests/CDR
//
// = FILENAME
//    allocator.cpp
//
// = DESCRIPTION
//   Compares the performance of a TSS allocator, with no locks, to
//   the global allocator (with locks) even in the abscence of
//   contention.
//   The idea behind this test is to measure the predictability of
//   each allocator, specially under the light of potential
//   fragmentation in the main allocator.
//
// = AUTHORS
//   Carlos O'Ryan
//
// ============================================================================

#include "ace/Get_Opt.h"
#include "ace/High_Res_Timer.h"

#include "tao/corba.h"

ACE_RCSID(CDR, allocator, "$Id$")

#define DEFAULT_BUFFER_SIZE 512

class Application_Simulator
{
  // = DESCRIPTION
  //   Tries to simulate the behavior of an application: it randomly
  //   acquires and releases memory, of variable sizes.
  //   The intention is to produce some level of fragmentation in main 
  //   memory.
  
public:
  Application_Simulator (int max_fragments,
                    int max_fragment_size);
  // Constructor, limits the amount of fragmentation and memory this
  // class takes.

  ~Application_Simulator (void);
  // Destructor, releases any memory left behind.

  void upcall (ACE_RANDR_TYPE& seed);
  // Simulate an upcall. The class allocates some memory and then
  // releases some memory too, the amount of memory allocated and the
  // number of allocations is random.

private:
  char** buffers_;
  // The allocated buffers.

  int max_fragments_;
  // The size of the <buffers_> array.

  int max_fragment_size_;
  // The maximum size of any element of <buffers_>
};

int
main (int argc, char *argv[])
{
  CORBA::ORB_var orb =
    CORBA::ORB_init (argc, argv);

  int tss = 0;
  int iterations = 500;
  int repeat = 100;
  int max_fragments = 2048;
  int max_fragment_size = 1024;
  int max_arguments = 16;
  int max_argument_size = 1024;
  ACE_RANDR_TYPE seed = time(0);

  ACE_Get_Opt get_opt (argc, argv, "tn:f:m:s:a:b:r:");
  int opt;

  while ((opt = get_opt ()) != EOF)
    {
      switch (opt)
        {
        case 't':
          tss = 1;
          break;
        case 'n':
          iterations = ACE_OS::atoi (get_opt.optarg);
          break;
        case 'r':
          repeat = ACE_OS::atoi (get_opt.optarg);
          break;
        case 'f':
          max_fragments = ACE_OS::atoi (get_opt.optarg);
          break;
        case 'm':
          max_fragment_size = ACE_OS::atoi (get_opt.optarg);
          break;
        case 's':
          seed = ACE_OS::atoi (get_opt.optarg);
          break;
        case 'a':
          max_arguments = ACE_OS::atoi (get_opt.optarg);
          break;
        case 'b':
          max_argument_size = ACE_OS::atoi (get_opt.optarg);
          break;
        case '?':
        default:
          ACE_DEBUG ((LM_DEBUG,
                      "Usage: %s "
                      "-n iterations "
                      "-n repeat "
                      "-f max_fragments "
                      "-m max_fragment_size "
                      "-s seed "
                      "-a max_arguments "
                      "-b max_argument_size "
                      "\n",
                      argv[0]));
          return -1;
        }
    }

  ACE_DEBUG ((LM_DEBUG, "SEED = %d\n", seed));

  ACE_Allocator* buffer_allocator = 
    ACE_Allocator::instance ();
  ACE_Allocator* dblock_allocator = 
    ACE_Allocator::instance ();
  if (tss)
    {
      buffer_allocator = 
        TAO_ORB_Core_instance ()->output_cdr_buffer_allocator ();
      dblock_allocator = 
        TAO_ORB_Core_instance ()->output_cdr_dblock_allocator ();
    }

  Application_Simulator simulator (max_fragments,
                                   max_fragment_size);
  char* argument_buffer;
  ACE_NEW_RETURN (argument_buffer, char[max_argument_size], 1);

  int* argument_sizes;
  ACE_NEW_RETURN (argument_sizes, int[max_arguments], 1);
    
  int n = ACE_OS::rand_r (seed) % max_arguments + 1;
  for (int k = 0; k < n; ++k)
    argument_sizes[k] = ACE_OS::rand_r (seed) % max_argument_size + 1;

  for (int i = 0; i < iterations; ++i)
    {
      simulator.upcall (seed);

      // @@ TODO this is the place to put the other allocators.
      ACE_High_Res_Timer cdr_encoding;
      for (int j = 0; j < repeat; ++j)
        {
          cdr_encoding.start_incr ();

          char buffer[DEFAULT_BUFFER_SIZE];
          ACE_OutputCDR cdr (buffer, sizeof(buffer),
                             TAO_ENCAP_BYTE_ORDER,
                             buffer_allocator,
                             dblock_allocator);

          for (int k = 0; k < n; ++k)
            {
              cdr.write_char_array (argument_buffer,
                                    argument_sizes[k]);
            }

          cdr_encoding.stop_incr ();
        }

      ACE_Time_Value tv;
      cdr_encoding.elapsed_time_incr (tv);
      ACE_hrtime_t usecs = tv.sec ();
      usecs *= ACE_static_cast (ACE_UINT32, ACE_ONE_SECOND_IN_USECS);
      usecs += tv.usec ();
      double average = ACE_U64_TO_U32(usecs) / repeat;
      ACE_OS::printf ("AVE: %d %f\n",
                      i, average);

    }
  return 0;
}

Application_Simulator::Application_Simulator (int max_fragments,
                                    int max_fragment_size)
  :  max_fragments_ (max_fragments),
     max_fragment_size_ (max_fragment_size)
{
  ACE_NEW (buffers_, char*[this->max_fragments_]);
  for (char** i = this->buffers_;
       i != this->buffers_ + this->max_fragments_;
       ++i)
    *i = 0;
}

Application_Simulator::~Application_Simulator (void)
{
  for (char** i = this->buffers_;
       i != this->buffers_ + this->max_fragments_;
       ++i)
    {
      if (*i != 0)
        {
          delete[] *i;
          *i = 0;
        }
    }
  delete[] this->buffers_;
  this->buffers_ = 0;
}

void
Application_Simulator::upcall (ACE_RANDR_TYPE& seed)
{
  for (char** i = this->buffers_;
       i != this->buffers_ + this->max_fragments_;
       ++i)
    {
      if (*i != 0)
        {
          if (ACE_OS::rand_r (seed) % 10000 < 5000)
            {
              delete[] *i;
              *i = 0;
            }
        }
      else
        {
          if (ACE_OS::rand_r (seed) % 10000 < 5000)
            {
              int size = ACE_OS::rand_r (seed) %
                this->max_fragment_size_ + 1;
              ACE_NEW (*i, char[size]);
            }
        }
    }
}
