/* -*- C++ -*- */

// Inserts an element onto the free list (if it isn't past the high water mark)

template <class T, class LOCK> ACE_INLINE T *
ACE_Locked_Simple_Free_List<T, LOCK>::remove (void)
{
  ACE_MT (ACE_GUARD_RETURN (LOCK, ace_mon, this->lock_, NULL));
  T *retv = this->head_;

  if (retv != 0)
    {
      this->head_ = retv->get_next ();
      this->size_--;
    }
  return retv;
}

template <class T, class LOCK> ACE_INLINE void
ACE_Locked_Simple_Free_List<T, LOCK>::add (T *mem)
{
  ACE_MT (ACE_GUARD (LOCK, ace_mon, this->lock_));
  mem->set_next (this->head_);
  this->head_ = mem;
  this->size_++;
}

template <class T, class LOCK> ACE_INLINE size_t
ACE_Locked_Simple_Free_List<T, LOCK>::size (void)
{
  return this->size_;
}

template <class T, class LOCK> ACE_INLINE void
ACE_Locked_Simple_Free_List<T, LOCK>::resize (size_t)
{
}

template <class T, class LOCK> ACE_INLINE void 
ACE_Locked_Free_List<T, LOCK>::add (T *element)
{
  ACE_MT (ACE_GUARD (LOCK, ace_mon, *this->mutex_));
  // Check to see that we not at the high water mark
  if (this->size_ >= this->hwm_)
    {
      element->set_next (this->free_list_);
      this->free_list_ = element;
      this->size_++;
    }
  else
    delete element;
}

  
// Takes a element off the freelist and returns it.  It creates <inc> new elements
// if the size is at the low water mark. 

template <class T, class LOCK> ACE_INLINE T *
ACE_Locked_Free_List<T, LOCK>::remove (void)
{
  ACE_MT (ACE_GUARD_RETURN (LOCK, ace_mon, *this->mutex_, 0));
  T *temp;

  // If we are at the low water mark, add some nodes
  if (this->size_ <= this->lwm_)
      this->alloc (this->inc_);

  // Remove a node
  temp = this->free_list_;
  this->free_list_ = this->free_list_->get_next ();
  this->size_--;
  
  return temp;
}


// Returns the current size of the free list

template <class T, class LOCK> ACE_INLINE size_t 
ACE_Locked_Free_List<T, LOCK>::size ()
{
  return this->size_;
}


// Resizes the free list to <newsize>

template <class T, class LOCK> ACE_INLINE void 
ACE_Locked_Free_List<T, LOCK>::resize (size_t newsize)
{
  ACE_MT (ACE_GUARD (LOCK, ace_mon, *this->mutex_));
  // Check to see if we grow or shrink
  if (newsize < this->size_)
    this->dealloc (this->size_ - newsize);
  else 
    this->alloc (newsize - this->size_);
}


