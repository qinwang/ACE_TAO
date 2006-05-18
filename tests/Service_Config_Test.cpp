// -*- C++ -*-

//=============================================================================
/**
 *  @file    Service_Config_Test.cpp
 *
 *  $Id$
 *
 *  This is a simple test to make sure the Service_Configurator is
 *  working correctly.
 *
 *  @author David Levine <levine@cs.wustl.edu>
 *  @author Ossama Othman <ossama@uci.edu>
 */
//=============================================================================


#include "test_config.h"
#include "ace/OS_NS_stdio.h"
#include "ace/Log_Msg.h"
#include "ace/Object_Manager.h"
#include "ace/Service_Config.h"
#include "ace/Reactor.h"
#include "ace/Thread_Manager.h"
#include "ace/ARGV.h"

ACE_RCSID (tests,
           Service_Config_Test,
           "$Id$")

static const u_int VARIETIES = 3;

static u_int error = 0;

/**
 * @class Test_Singleton
 *
 * @brief Test the Singleton
 *
 * This should be a template class, with singleton instantiations.
 * But to avoid having to deal with compilers that want template
 * declarations in separate files, it's just a plain class.  The
 * instance argument differentiates the "singleton" instances.  It
 * also demonstrates the use of the param arg to the cleanup ()
 * function.
 */
class Test_Singleton
{
public:
  static Test_Singleton *instance (u_short variety);
  ~Test_Singleton (void);

private:
  u_short variety_;
  static u_short current_;

  Test_Singleton (u_short variety);

  friend class misspelled_verbase_friend_declaration_to_avoid_compiler_warning_with_private_ctor;
};

u_short Test_Singleton::current_ = 0;

extern "C" void
test_singleton_cleanup (void *object, void *param)
{
  // We can't reliably use ACE_Log_Msg in a cleanup hook.  Yet.
  ACE_UNUSED_ARG (param);
  /* ACE_DEBUG ((LM_DEBUG, "cleanup %d\n", (u_short) param)); */

  delete (Test_Singleton *) object;
}

Test_Singleton *
Test_Singleton::instance (u_short variety)
{
  static Test_Singleton *instances[VARIETIES] = { 0 };

  if (instances[variety] == 0)
    ACE_NEW_RETURN (instances[variety],
                    Test_Singleton (variety),
                    0);

  ACE_Object_Manager::at_exit (instances[variety],
                               test_singleton_cleanup,
                               reinterpret_cast<void *> (static_cast<size_t> (variety)));
  return instances[variety];
}

Test_Singleton::Test_Singleton (u_short variety)
  : variety_ (variety)
{
  if (variety_ != current_++)
    {
      ACE_DEBUG ((LM_ERROR,
                  ACE_TEXT ("ERROR: instance %u created out of order!\n"),
                 variety_));
      ++error;
    }
}

// We can't reliably use ACE_Log_Msg in a destructor that is called by
// ACE_Object_Manager.  Yet.

Test_Singleton::~Test_Singleton (void)
{
  /* ACE_DEBUG ((LM_DEBUG, ACE_TEXT ("Test_Singleton %u dtor\n"), variety_)); */

  if (variety_ != --current_)
    {
      ACE_OS::fprintf (stderr,
                       ACE_TEXT ("ERROR: instance %u destroyed out of order!\n"),
                       variety_);
      /* ACE_DEBUG ((LM_ERROR, ACE_TEXT ("ERROR: instance %u destroyed out of order!\n"),
                 variety_)); */
      ++error;
    }
}

void
testLoadingServiceConfFile (int argc, ACE_TCHAR *argv[])
{
  ACE_ARGV new_argv;

#if defined (ACE_USES_WCHAR)
  // When using full Unicode support, use the version of the Service
  // Configurator file appropriate to the platform.
  // For example, Windows Unicode uses UTF-16.
  //
  //          iconv(1) found on Linux and Solaris, for example, can
  //          be used to convert between encodings.
  //
  //          Byte ordering is also an issue, so we should be
  //          generating this file on-the-fly from the UTF-8 encoded
  //          file by using functions like iconv(1) or iconv(3).
#  if defined (ACE_WIN32)
  const ACE_TCHAR svc_conf[] =
    ACE_TEXT ("Service_Config_Test.UTF-16")
    ACE_TEXT (ACE_DEFAULT_SVC_CONF_EXT);
#  else
  const ACE_TCHAR svc_conf[] =
    ACE_TEXT ("Service_Config_Test.WCHAR_T")
    ACE_TEXT (ACE_DEFAULT_SVC_CONF_EXT);
#  endif /* ACE_WIN32 */
#else
    // ASCII (UTF-8) encoded Service Configurator file.
  const ACE_TCHAR svc_conf[] =
    ACE_TEXT ("Service_Config_Test")
    ACE_TEXT (ACE_DEFAULT_SVC_CONF_EXT);
#endif  /* ACE_USES_WCHAR */

  // Process the Service Configurator directives in this test's
  ACE_ASSERT (new_argv.add (argv) != -1
              && new_argv.add (ACE_TEXT ("-f")) != -1
              && new_argv.add (svc_conf) != -1);

  // We need this scope to make sure that the destructor for the
  // <ACE_Service_Config> gets called.
  ACE_Service_Config daemon;

  ACE_ASSERT (daemon.open (new_argv.argc (),
                           new_argv.argv ()) != -1 || errno == ENOENT);

  ACE_Time_Value tv (argc > 1 ? ACE_OS::atoi (argv[1]) : 2);

  ACE_ASSERT (ACE_Reactor::instance()->run_reactor_event_loop (tv) == 0);

  // Wait for all threads to complete.
  ACE_Thread_Manager::instance ()->wait ();
}


// @brief The size of a repository is pre-determined and can not be exceeded
void
testLimits (int , ACE_TCHAR *[])
{
  static ACE_TCHAR *svc_desc =
    ACE_TEXT ("dynamic Test_Object_1 Service_Object * ")
    ACE_TEXT ("  Service_Config_DLL:_make_Service_Config_DLL() \"2 3\"");

  ACE_Service_Gestalt one(1); // Room for just one ...
  if (0 != one.process_directive (svc_desc))
    {
      ++error;
      ACE_DEBUG ((LM_ERROR, ACE_TEXT("Unable to register the first service\n")));
    }

  if (-1 != one.process_directive (svc_desc))
    {
      ++error;
      ACE_DEBUG ((LM_ERROR, ACE_TEXT("Unexped to be able to add more\n")));
    }

  if (ENOSPC != errno)
    {
      ++error;
      ACE_DEBUG ((LM_ERROR,
                  ACE_TEXT("Expected error code %d (ENOSPC), but got %d\n"),
                  ENOSPC,
                  errno));
    }

  ACE_DEBUG ((LM_DEBUG, "Attempt to overfill the gestalt returned: %m\n"));
}


// @brief ??
void
testOrderlyInstantialtion (int , ACE_TCHAR *[])
{
  for (u_int i = 0; i < VARIETIES; ++i)
    {
      Test_Singleton *s = Test_Singleton::instance (i);

      if (s == 0)
        {
          ++error;
          ACE_ERROR ((LM_ERROR,
                      ACE_TEXT ("instance () allocate failed!\n")));
        }
    }
}

int
run_main (int argc, ACE_TCHAR *argv[])
{
  ACE_START_TEST (ACE_TEXT ("Service_Config_Test"));

  testOrderlyInstantialtion (argc, argv);

  testLoadingServiceConfFile (argc, argv);

  testLimits (argc, argv);

  ACE_END_TEST;
  return error == 0 ? 0 : 1;
}
