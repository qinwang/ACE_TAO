// @(#)cubit_i.cpp 05/14/97
// Copyright 1994-1995 by Sun Microsystems Inc.
// All Rights Reserved
//
// TEST:	hand-written Cubit Implementation
//
// Modified version of Cubit Example written by Sun Microsystems Inc.
// Modified by: Brian Mendel

#include "tao/corba.h"
#include "cubit_i.h"

Cubit_Factory_i::Cubit_Factory_i (const char *key, int numobjs)
  : POA_Cubit_Factory (key)
{
  // Create implementation object with user specified key.

  this->my_cubit_ = new Cubit_i_ptr [this->numobjs_];
  this->numobjs_ = numobjs;

  static char obj_str [MAXNAMELEN];

  for (int i = 0; i < this->numobjs_; i++)
    {
      ACE_OS::memset (obj_str, '\0', MAXNAMELEN);
      ACE_OS::sprintf (obj_str, "key%d", i);

      my_cubit_[i] = new Cubit_i (obj_str);

      if (my_cubit_[i] == 0)
        ACE_ERROR ((LM_ERROR,
                    " (%P|%t) Unable to create implementation object&d\n",
                    i));

    }
}

Cubit_Factory_i::~Cubit_Factory_i (void)
{
  delete [] this->my_cubit_;
}

Cubit_ptr
Cubit_Factory_i::make_cubit (const char *key, CORBA::Environment &env)
{
  Cubit_ptr cubit;

  for (size_t i = 0; i < this->numobjs_; i++)
    {
      char *obj_str;

      obj_str = this->my_cubit_[i]->_get_name (env);

      // Keys matched.
      if (!ACE_OS::strcmp (obj_str, key)) 
        return Cubit::_duplicate (this->my_cubit_ [i]);
    }

  return Cubit::_nil ();
}

Cubit_i::Cubit_i (const char *obj_name)
  : POA_Cubit (obj_name)
{
}

Cubit_i::~Cubit_i (void)
{
}

CORBA::Octet
Cubit_i::cube_octet (CORBA::Octet o,
                     CORBA::Environment &env)
{
  ACE_UNUSED_ARG (env);
  return o * o * o;
}

CORBA::Short
Cubit_i::cube_short (CORBA::Short s,
                     CORBA::Environment &env)
{
  ACE_UNUSED_ARG (env);
  return s * s * s;
}

CORBA::Long
Cubit_i::cube_long (CORBA::Long l,
                    CORBA::Environment &env)
{
  ACE_UNUSED_ARG (env);
  return l * l * l;
}

Cubit::Many
Cubit_i::cube_struct (const Cubit::Many &values,
                      CORBA::Environment &env)
{
  Cubit::Many temp;

  ACE_UNUSED_ARG (env);
  temp.o = values.o * values.o * values.o;
  temp.s = values.s * values.s * values.s;
  temp.l = values.l * values.l * values.l;

  return temp;
}

Cubit::oneof
Cubit_i::cube_union (const Cubit::oneof &values,
                     CORBA::Environment &env)
{
  Cubit::oneof temp;

  ACE_UNUSED_ARG (env);
  switch (values._d ())
    {
    case e_0th:
      temp.o (values.o () * values.o () * values.o ());
      break;
    case e_1st:
      temp.s (values.s () * values.s () * values.s ());
      break;
    case e_2nd:
      temp.l (values.l () * values.l () * values.l ());
      break;
    case e_3rd:
    default:
      temp._d (values._d ()); // set the discriminant
      // use the read/write accessor
      temp.cm ().o  = values.cm ().o * values.cm ().o * values.cm ().o;
      temp.cm ().s  = values.cm ().s * values.cm ().s * values.cm ().s;
      temp.cm ().l  = values.cm ().l * values.cm ().l * values.cm ().l;

    }
  return temp;
}

void Cubit_i::please_exit (CORBA::Environment &env)
{
  dmsg ("I've been asked to shut down...");
  TAO_ORB_Core_instance ()->orb ()->shutdown ();
  dexc (env, "please_exit, shutdown");
}
