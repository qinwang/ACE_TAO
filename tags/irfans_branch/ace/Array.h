/* -*- C++ -*- */
// $Id$

// ============================================================================
//
// = LIBRARY
//    ace
//
// = FILENAME
//    Array.h
//
// = AUTHOR
//    Doug Schmidt
//
// ============================================================================

#if !defined (ACE_ARRAY_H)
#define ACE_ARRAY_H

#include "ace/ACE.h"

// Forward declaration.
template <class T> class ACE_Array_Iterator;

template <class T>
class ACE_Array
{
public:
  // Define a "trait"
  typedef T TYPE;

  // = Exceptions.

  // = Initialization and termination methods.

  ACE_Array (size_t size);
  // Dynamically create an uninitialized array.

  ACE_Array (size_t size, const T &default_value);
  // Dynamically initialize the entire array to the <default_value>.

  ACE_Array (const ACE_Array<T> &s);
  // The copy constructor performs initialization by making an exact
  // copy of the contents of parameter <s>, i.e., *this == s will
  // return true.

  void operator= (const ACE_Array<T> &s);
  // Assignment operator performs an assignment by making an exact
  // copy of the contents of parameter <s>, i.e., *this == s will
  // return true.  Note that if the <max_size_> of <array_> is >= than
  // <s.max_size_> we can copy it without reallocating.  However, if
  // <max_size_> is < <s.max_size_> we must delete the <array_>,
  // reallocate a new <array_>, and then copy the contents of <s>.

  ~ACE_Array (void);
  // Clean up the array (e.g., delete dynamically allocated memory).

  // = Set/get methods.

  T &operator [] (size_t index);
  // Set item in the array at location <index>.  Doesn't
  // perform range checking.

  const T &operator [] (size_t index) const;
  // Get item in the array at location <index>.  Doesn't
  // perform range checking.

  int set (const T &new_item, size_t index);
  // Set an item in the array at location <index>.  Returns
  // -1 if <index> is not in range, else returns 0.

  int get (T &item, size_t index) const;
  // Get an item in the array at location <index>.  Returns -1 if
  // <index> is not in range, else returns 0.  Note that this function
  // copies the item.  If you want to avoid the copy, you can use
  // the const operator [], but then you'll be responsible for range checking.

  size_t size (void) const;
  // Returns the <cur_size_> of the array.

  int operator== (const ACE_Array<T> &s) const;
  // Compare this array with <s> for equality.  Two arrays are equal
  // if their size()'s are equal and all the elements from 0 .. size()
  // are equal.

  int operator!= (const ACE_Array<T> &s) const;
  // Compare this array with <s> for inequality such that <*this> !=
  // <s> is always the complement of the boolean return value of
  // <*this> == <s>.

private:
  int in_range (size_t index) const;
  // Returns 1 if <index> is within range, i.e., 0 >= <index> <
  // <cur_size_>, else returns 0.

  size_t max_size_;
  // Maximum size of the array, i.e., the total number of <T> elements
  // in <array_>.

  size_t cur_size_;
  // Current size of the array.  This starts out being == to
  // <max_size_>.  However, if we are assigned a smaller array, then
  // <cur_size_> will become less than <max_size_>.  The purpose of
  // keeping track of both sizes is to avoid reallocating memory if we
  // don't have to.

  T *array_;
  // Pointer to the array's storage buffer.

  friend class ACE_Array_Iterator<T>;
};

template <class T>
class ACE_Array_Iterator
  // = TITLE
  //     Implement an iterator over an ACE_Array.  This iterator is
  //     safe in the face of array element deletions.  But it is NOT
  //     safe if the array is resized (via the ACE_Array assignment
  //     operator) during iteration.  That would be very odd, and
  //     dangerous.
{
public:
  // = Initialization method.
  ACE_Array_Iterator (ACE_Array<T> &);

  // = Iteration methods.

  int next (T *&next_item);
  // Pass back the <next_item> that hasn't been seen in the Array.
  // Returns 0 when all items have been seen, else 1.

  int advance (void);
  // Move forward by one element in the Array.  Returns 0 when all the
  // items in the Array have been seen, else 1.

  int done (void) const;
  // Returns 1 when all items have been seen, else 0.

  void dump (void) const;
  // Dump the state of an object.

  ACE_ALLOC_HOOK_DECLARE;
  // Declare the dynamic allocation hooks.

private:
  u_int current_;
  // Pointer to the current item in the iteration.

  ACE_Array<T> &array_;
  // Pointer to the Array we're iterating over.
};

#if defined (__ACE_INLINE__)
#include "ace/Array.i"
#endif /* __ACE_INLINE__ */

#if defined (ACE_TEMPLATES_REQUIRE_SOURCE)
#include "ace/Array.cpp"
#endif /* ACE_TEMPLATES_REQUIRE_SOURCE */

#if defined (ACE_TEMPLATES_REQUIRE_PRAGMA)
#pragma implementation ("Array.cpp")
#endif /* ACE_TEMPLATES_REQUIRE_PRAGMA */

#endif /* ACE_ARRAY_H */
