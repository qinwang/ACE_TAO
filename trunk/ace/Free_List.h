/* -*- C++ -*- */

// ============================================================================
//
// = LIBRARY
//    ace
// 
// = FILENAME
//    Free_List.h
//
// = AUTHOR
//    Darrell Brunsch (brunsch@cs.wustl.edu)
// 
// ============================================================================

#if !defined(ACE_FREE_LIST_H)
#define ACE_FREE_LIST_H

#include "ace/OS.h"
#include "ace/Synch_T.h"

template <class T>
class ACE_Free_List  
  // = TITLE
  //      Implements a free list
  //
  // = DESCRIPTION
  //      This class maintains a free list of nodes of type T.
{
public:
  virtual ~ACE_Free_List (void);
  // Destructor - removes all the elements from the free_list

  virtual void add (T *element) = 0;
  // Inserts an element onto the free list (if it isn't past the high water mark)
  
  virtual T *remove (void) = 0;
  // Takes a element off the freelist and returns it.  It creates <inc> new elements
  // if the size is at or below the low water mark. 
  
  virtual size_t size () = 0;
  // Returns the current size of the free list

  virtual void resize (size_t newsize) = 0;
  // Resizes the free list to <newsize>
};

template <class T, class LOCK>
class ACE_Locked_Simple_Free_List : public ACE_Free_List<T>
// = TITLE
//      Implement a simple free list
//
// = DESCRIPTION
//      This class maintains a free list.  It is different from
//      ACE_Locked_Free_List in that it does not allocate or
//      deallocate elements in free lists when there are too many/few
//      of them.  It also depends on the type T having get_next () and
//      set_next () method.  
{
public:
  ACE_Locked_Simple_Free_List ();
  // Create a Memory free list
  
  virtual T *remove ();
  // get next element in the free list.  Return NULL if the list is empty

  virtual void add (T *);
  // insert an element into the free list

  virtual ~ACE_Locked_Simple_Free_List ();
  // Destructor - does *not* delete elements it holds

  virtual size_t size ();
  // Returns the current size of the free list

  virtual void resize (size_t) { }
  // This operation doesn't have any meaning here

private:
  size_t size_ ;
  // Maintian the current size of the free list

  LOCK lock_;
  // Integrity keeper

  T *head_;
  // Free list head;
};

template <class T, class LOCK>
class ACE_Locked_Free_List : public ACE_Free_List<T> 
  // = TITLE
  //      Implements a free list
  //
  // = DESCRIPTION
  //      This class maintains a free list of nodes of type T.  It depends on
  //      the type T having a get_next () and set_next () method.  It maintains
  //      a mutex so the freelist can be used in a multithreaded program .
{
public:
  ACE_Locked_Free_List (size_t prealloc = ACE_DEFAULT_FREE_LIST_PREALLOC, 
                        size_t lwm = ACE_DEFAULT_FREE_LIST_LWM, 
                        size_t hwm = ACE_DEFAULT_FREE_LIST_HWM, 
                        size_t inc = ACE_DEFAULT_FREE_LIST_INC,
                        LOCK *mutex = 0);
  // Default constructor that takes in a preallocation number (<prealloc>), a 
  // low and high water mark (<lwm> and <hwm>) and an increment value (<inc>)

  virtual ~ACE_Locked_Free_List (void);
  // Destructor - removes all the elements from the free_list

  virtual void add (T *element);
  // Inserts an element onto the free list (if it isn't past the high water mark)
  
  virtual T *remove (void);
  // Takes a element off the freelist and returns it.  It creates <inc> new elements
  // if the size is at or below the low water mark. 
  
  virtual size_t size ();
  // Returns the current size of the free list

  virtual void resize (size_t newsize);
  // Resizes the free list to <newsize>

  LOCK &get_mutex (void); 
  // Returns a reference to the mutex
  
  void set_mutex (LOCK &mutex);
  // Sets the mutex to <mutex>

protected:
  virtual void alloc (size_t n);
  // Allocates <n> extra nodes for the freelist

  virtual void dealloc (size_t n);
  // Removes and frees <n> nodes from the freelist

  T *free_list_;
  // Pointer to the first node in the freelist

  size_t lwm_;
  // Low water mark

  size_t hwm_;
  // High water mark

  size_t inc_;
  // Increment value

  size_t size_;
  // Keeps track of the size of the list

  LOCK *mutex_; 
  // Synchronization variable for <ACE_Timer_Queue>.

  int delete_mutex_;
  // flag to remember ownership of the mutex

private:
  // = Don't allow these operations for now.
  ACE_Locked_Free_List (const ACE_Locked_Free_List<T, LOCK> &);
  void operator= (const ACE_Locked_Free_List<T, LOCK> &);
};

#if defined (__ACE_INLINE__)
#include "ace/Free_List.i"
#endif /* __ACE_INLINE__ */

#if defined (ACE_TEMPLATES_REQUIRE_SOURCE)
#include "ace/Free_List.cpp"
#endif /* ACE_TEMPLATES_REQUIRE_SOURCE */

#if defined (ACE_TEMPLATES_REQUIRE_PRAGMA)
#pragma implementation ("Free_List.cpp")
#endif /* ACE_TEMPLATES_REQUIRE_PRAGMA */

#endif /* ACE_FREE_LIST_H */
