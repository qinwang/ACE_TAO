// ******  Code generated by the The ACE ORB (TAO) IDL Compiler *******
// TAO ORB and the TAO IDL Compiler have been developed by Washington 
// University Computer Science's Distributed Object Computing Group.
//
// Information on TAO is available at
//                 http://www.cs.wustl.edu/~schmidt/TAO.html

#if !defined (_TAO_IDL_OBJKEYC_H_)
#define _TAO_IDL_OBJKEYC_H_

class TAO_Export TAO{
public:

#if !defined (_TAO__TAO_SEQ_OCTET_CH_)
#define _TAO__TAO_SEQ_OCTET_CH_

  // *************************************************************
  // class _tao_seq_Octet
  // *************************************************************
  
  class TAO_Export _tao_seq_Octet
  {
  public:
    _tao_seq_Octet (void); // default constructor
    _tao_seq_Octet (CORBA::ULong max);
    _tao_seq_Octet (CORBA::ULong max, CORBA::ULong length, 
    	CORBA::Octet *value, CORBA::Boolean release=CORBA::B_FALSE);
    _tao_seq_Octet(const _tao_seq_Octet &); // copy constructor
    ~_tao_seq_Octet (void);
    _tao_seq_Octet &operator= (const _tao_seq_Octet &);
    CORBA::ULong maximum (void) const;
    void length (CORBA::ULong);
    CORBA::ULong length (void) const;
    CORBA::Octet &operator[] (CORBA::ULong index);
    const CORBA::Octet &operator[] (CORBA::ULong index) const;
    static CORBA::Octet *allocbuf (CORBA::ULong nelems);
    static void freebuf (CORBA::Octet *);
  private:
    CORBA::ULong maximum_;
    CORBA::ULong length_;
    CORBA::Octet *buffer_;
    CORBA::Boolean release_;
  };
  typedef _tao_seq_Octet* _tao_seq_Octet_ptr;
  static CORBA::TypeCode_ptr _tc__tao_seq_Octet;


#endif // end #if !defined


#if !defined (_TAO__TAO_SEQ_OCTET___VAR_CH_)
#define _TAO__TAO_SEQ_OCTET___VAR_CH_

// *************************************************************
  // class TAO::_tao_seq_Octet_var
  // *************************************************************

  class TAO_Export _tao_seq_Octet_var
  {
  public:
    _tao_seq_Octet_var (void); // default constructor
    _tao_seq_Octet_var (_tao_seq_Octet *);
    _tao_seq_Octet_var (const _tao_seq_Octet_var &); // copy constructor
    ~_tao_seq_Octet_var (void); // destructor
    
    _tao_seq_Octet_var &operator= (_tao_seq_Octet *);
    _tao_seq_Octet_var &operator= (const _tao_seq_Octet_var &);
    _tao_seq_Octet *operator-> (void);
    const _tao_seq_Octet *operator-> (void) const;
    
    operator const _tao_seq_Octet &() const;
    operator _tao_seq_Octet &();
    operator _tao_seq_Octet &() const;
    CORBA::Octet &operator[] (CORBA::ULong index);
    // in, inout, out, _retn 
    const _tao_seq_Octet &in (void) const;
    _tao_seq_Octet &inout (void);
    _tao_seq_Octet *&out (void);
    _tao_seq_Octet *_retn (void);
    _tao_seq_Octet *ptr (void) const;

  private:
    _tao_seq_Octet *ptr_;
  };


#endif // end #if !defined


#if !defined (_TAO__TAO_SEQ_OCTET___OUT_CH_)
#define _TAO__TAO_SEQ_OCTET___OUT_CH_

  class TAO_Export _tao_seq_Octet_out
  {
  public:
    _tao_seq_Octet_out (_tao_seq_Octet *&);
    _tao_seq_Octet_out (_tao_seq_Octet_var &);
    _tao_seq_Octet_out (_tao_seq_Octet_out &);
    _tao_seq_Octet_out &operator= (_tao_seq_Octet_out &);
    _tao_seq_Octet_out &operator= (_tao_seq_Octet *);
    operator _tao_seq_Octet *&();
    _tao_seq_Octet *&ptr (void);
    _tao_seq_Octet *operator-> (void);
    CORBA::Octet &operator[] (CORBA::ULong index);
    
  private:
    _tao_seq_Octet *&ptr_;
    // assignment from T_var not allowed
    void operator= (const _tao_seq_Octet_var &);
  };


#endif // end #if !defined

  typedef ACE_NESTED_CLASS (TAO,_tao_seq_Octet) ObjectKey;
  typedef ObjectKey *ObjectKey_ptr; // cjc
  typedef ACE_NESTED_CLASS (TAO,_tao_seq_Octet_var) ObjectKey_var;
  typedef ACE_NESTED_CLASS (TAO,_tao_seq_Octet_out) ObjectKey_out;

  static CORBA::TypeCode_ptr _tc_ObjectKey;

};


#if defined (__ACE_INLINE__)
#include "objkeyC.i"
#endif // defined INLINE


#endif // if !defined
