// ============================================================================
//
// = LIBRARY
//    CORBA Marshal Visibroker Benchmark
// 
// = FILENAME
//    visi_marshal_server.h
//
// = AUTHOR
//    Aniruddha Gokhale
// 
// ============================================================================

#if !defined(_VISI_MARSHAL_SERVER_H_)
#define _VISI_MARSHAL_SERVER_H_

// benchmark library includes
#include "benchmark/marshal_options.h"
#include "benchmark/marshal_results.h"
#include "benchmark/marshal_proxy.h"

// implementation classes
#include "visi_marshal_impl.h"

// include VisiBroker specific include files
#include "marshalS.h"  // generated by IDL compiler
#include "pmcext.h"    // VisiBroker extensions

class Visi_Marshal_Server_Proxy : public CORBA_Marshal_Proxy
{
public:
  Visi_Marshal_Server_Proxy (void);
  // constructor

  ~Visi_Marshal_Server_Proxy (void);
  // destructor

  virtual int run (CORBA_Marshal_Proxy::OPTIONS &options,
		   CORBA_Marshal_Proxy::RESULTS &results);
  // do the actual work
private:
  CORBA::ORB_ptr orb_;
  // underlying orb;

  CORBA::BOA_ptr boa_;
  // underlying boa;

  Marshal_SSI_Impl *ssi_;
  Marshal_DSI_Impl *dsi_;
  // the implementation (SSI or DSI)
};


#if defined (__ACE_INLINE__)
#include "visi_marshal_server.i"
#endif /* __ACE_INLINE__ */

#endif
