/* -*- C++ -*- */
// $Id$
// ============================================================================
//
// = LIBRARY
//    TAO
//
// = FILENAME
//    sequence.h
//
// = AUTHOR
//
//    Carlos O'Ryan and Aniruddha Gokhale
//
// ============================================================================

#if !defined (TAO_SEQUENCE_H)
#  define TAO_SEQUENCE_H

class TAO_Base_Sequence
{
  // = TITLE
  //   Base class for TAO sequences.
  //
  // = DESCRIPTION
  //   This class provides a common interface for all IDL sequences,
  //   hence the interpreted marshal engine can manipulate them in a
  //   type safe manner.
  //
public:
  friend class TAO_Marshal_Sequence;
  // We give access to TAO_Marshal_Sequence, this allows a safe yet
  // small footprint implementation of the marshal engine.

  virtual ~TAO_Base_Sequence (void);
  // destructor.

  CORBA::ULong maximum (void) const;
  // return the maximum length of the sequence

  void length (CORBA::ULong length);
  // set the length

  CORBA::ULong length (void) const;
  // return the current length

  virtual void _allocate_buffer (CORBA::ULong length) = 0;
  // Ensure that the buffer contains space for at least <length>
  // elements.  The constructor must be called for any new elements,
  // the old ones (if any) must be copied into the buffer using
  // operator= and then their destructors must be called.
  // Finally the old buffer must be released.

  virtual void _deallocate_buffer (void) = 0;
  // Releases the buffer and call the destructor for all the elements
  // in it; remember that there are <maximum> elements in the buffer.

  virtual int _bounded (void) const = 0;
  // Returns 1 if the sequence is bounded (hence it cannot be resized)
  // and 0 otherwise.

protected:
  TAO_Base_Sequence (void);
  // Default constructor.

  TAO_Base_Sequence (CORBA::ULong maximum,
		     CORBA::ULong length,
		     void* buffer,
		     CORBA::Boolean release = 0);
  // Constructor with control of ownership.

  TAO_Base_Sequence (CORBA::ULong maximum,
		     void* buffer);
  // Assume ownership and set length to 0.

  TAO_Base_Sequence (const TAO_Base_Sequence& rhs);
  TAO_Base_Sequence& operator=(const TAO_Base_Sequence& rhs);
  // Copy constructor and assignment operator are protected, the
  // derived classes must provided the right semantics for the buffer
  // copy, only the static fields are actually copy.

protected:
  CORBA::ULong maximum_;
  // The maximum number of elements the buffer can contain.

  CORBA::ULong length_;
  // The current number of elements in the buffer.

  void* buffer_;
  // The buffer with all the elements, casting must be done in derived
  // classes.

  CORBA::Boolean release_;
  // If true then the sequence should release the buffer when it is
  // destroyed.
};

class TAO_Unbounded_StringSequence : public TAO_Base_Sequence
{
  // =TITLE
  //   TAO_Unbounded_StringSequence
  // =DESCRIPTION
  //   Unbounded sequence for strings. This needs a special managed type
public:
  // special managed type for strings
  class TAO_StrMngType
  {
  public:
    friend TAO_Unbounded_StringSequence;
    TAO_StrMngType (const TAO_StrMngType &);
    // copy constructor

    TAO_StrMngType (char **buffer, CORBA::Boolean release);
    // constructor from address of an element

    ~TAO_StrMngType (void);
    // destructor

    TAO_StrMngType &operator= (const TAO_StrMngType&);
    // assignment from another managed type

    TAO_StrMngType &operator= (char *);
    // assignment from a char*

    TAO_StrMngType &operator= (const char *);
    // assignment from a constant char*

    operator const char*() const;
    // cast  (read-only)

    operator char *();
    // cast

    char &operator[] (CORBA::ULong index);
    // accessor

    const char &operator[] (CORBA::ULong index) const;
    // read-only accessor

    // in, inout, out, _retn
    const char *in (void) const;
    // returns the underlying string

    char *&inout (void);
    // returns a reference to the underlying string

    char *&out (void);
    // used for out parameters

    char *_retn (void);
    // gives up ownership

  private:
    char **ptr_;
    // address of string element from the parent's buffer

    CORBA::Boolean release_;
    // based on parent's release flag
  };

  TAO_Unbounded_StringSequence (void);
  // default constructor

  TAO_Unbounded_StringSequence (CORBA::ULong max);
  // constructor using max length

  TAO_Unbounded_StringSequence (CORBA::ULong max, CORBA::ULong length,
                   char **value, CORBA::Boolean release=0);
  // constructor from a data buffer. Buffer must be allocated using the
  // allocbuf method

  TAO_Unbounded_StringSequence (const TAO_Unbounded_StringSequence &);
  // copy constructor

  ~TAO_Unbounded_StringSequence (void);
  // destructor

  TAO_Unbounded_StringSequence &operator= (const TAO_Unbounded_StringSequence
                                           &);
  // assignment from another string sequence

  TAO_StrMngType operator[] (CORBA::ULong index);
  // accessor

  const TAO_StrMngType operator[] (CORBA::ULong index) const;
  // read-only accessor

  // =static operations

  static char **allocbuf (CORBA::ULong nelems);
  // allocate storage for elements of sequence

  static void freebuf (char **);
  // free the storage for elements of sequence

  static void freebuf (char **, CORBA::ULong);
  // string sequences require each string to be freed using CORBA::string_free
  // before the buffer is deallocated

  virtual void _allocate_buffer (CORBA::ULong length);
  // Ensure that the buffer contains space for at least <length>
  // elements.  The constructor must be called for any new elements,
  // the old ones (if any) must be copied into the buffer using
  // operator= and then their destructors must be called.
  // Finally the old buffer must be released.

  virtual void _deallocate_buffer (void);
  // Releases the buffer and call the destructor for all the elements
  // in it; remember that there are <maximum> elements in the buffer.

  virtual int _bounded (void) const;
  // Retuns 1 if the sequence is bounded (hence it cannot be resized)
  // and 0 otherwise.

};

#endif /* TAO_SEQUENCE_H */
