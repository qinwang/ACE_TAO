// $Id$

// ============================================================================
//
// = LIBRARY
//    ace
//
// = FILENAME
//    Hash_Map_Manager.cpp
//
// = AUTHOR
//    Doug Schmidt
//
// ============================================================================

#if !defined (ACE_HASH_MAP_MANAGER_C)
#define ACE_HASH_MAP_MANAGER_C

#include "ace/Hash_Map_Manager.h"
#include "ace/Service_Config.h"
#include "ace/Malloc.h"

template <class EXT_ID, class INT_ID>
ACE_Hash_Map_Entry<EXT_ID, INT_ID>::ACE_Hash_Map_Entry (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *next,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *prev)
  : next_ (next),
    prev_ (prev)
{
}

template <class EXT_ID, class INT_ID>
ACE_Hash_Map_Entry<EXT_ID, INT_ID>::ACE_Hash_Map_Entry (const EXT_ID &ext_id,
                                                        const INT_ID &int_id,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *next,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *prev)
  : ext_id_ (ext_id),
    int_id_ (int_id),
    next_ (next),
    prev_ (prev)
{
}

template <class EXT_ID, class INT_ID>
ACE_Hash_Map_Entry<EXT_ID, INT_ID>::~ACE_Hash_Map_Entry (void)
{
}

template <class EXT_ID, class INT_ID> void
ACE_Hash_Map_Entry<EXT_ID, INT_ID>::dump (void) const
{
  ACE_DEBUG ((LM_DEBUG, ACE_BEGIN_DUMP, this));
  ACE_DEBUG ((LM_DEBUG, "next_ = %d", this->next_));
  ACE_DEBUG ((LM_DEBUG, "prev_ = %d", this->prev_));
  ACE_DEBUG ((LM_DEBUG, ACE_END_DUMP));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> void
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::dump (void) const
{
  ACE_DEBUG ((LM_DEBUG, ACE_BEGIN_DUMP, this));
  ACE_DEBUG ((LM_DEBUG, "total_size_ = %d", this->total_size_));
  ACE_DEBUG ((LM_DEBUG, "\ncur_size_ = %d", this->cur_size_));
  this->allocator_->dump ();
  this->lock_.dump ();
  ACE_DEBUG ((LM_DEBUG, ACE_END_DUMP));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::create_buckets (size_t size)
{
  size_t bytes = size * sizeof (ACE_Hash_Map_Entry<EXT_ID, INT_ID>);
  void *ptr;

  ACE_ALLOCATOR_RETURN (ptr,
                        this->allocator_->malloc (bytes),
                        -1);

  this->table_ = (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *) ptr;

  this->total_size_ = size;

  // Initialize the hash table by creating sentinals that point to
  // themselves.
  for (size_t i = 0; i < this->total_size_; i++)
    new (&this->table_[i]) ACE_Hash_Map_Entry<EXT_ID, INT_ID> (&this->table_[i],
                                                               &this->table_[i]);

  return 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::open (size_t size,
                                                      ACE_Allocator *alloc)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  if (alloc == 0)
    alloc = ACE_Allocator::instance ();

  this->allocator_ = alloc;

  // This assertion is here to help track a situation that shouldn't
  // happen, but did with Sun C++ 4.1 (before a change to this class
  // was made: it used to have an enum that was supposed to be defined
  // to be ACE_DEFAULT_MAP_SIZE, but instead was defined to be 0.
  ACE_ASSERT (size != 0);

  return this->create_buckets (size);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::ACE_Hash_Map_Manager (size_t size,
                                                                      ACE_Allocator *alloc)
  : allocator_ (alloc),
    total_size_ (0),
    cur_size_ (0)
{
  if (this->open (size, alloc) == -1)
    ACE_ERROR ((LM_ERROR, "ACE_Hash_Map_Manager\n"));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::ACE_Hash_Map_Manager (ACE_Allocator *alloc)
  : allocator_ (alloc),
    total_size_ (0),
    cur_size_ (0)
{
  if (this->open (ACE_DEFAULT_MAP_SIZE, alloc) == -1)
    ACE_ERROR ((LM_ERROR, "ACE_Hash_Map_Manager\n"));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::close_i (void)
{
  if (this->table_ != 0)
    {
      // Iterate through the entire map calling the destuctor of each
      // <ACE_Hash_Map_Entry>.
      for (size_t i = 0; i < this->total_size_; i++)
        {
          for (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *temp_ptr = this->table_[i].next_;
               temp_ptr != &this->table_[i];
               )
            {
              ACE_Hash_Map_Entry<EXT_ID, INT_ID> *hold_ptr = temp_ptr;
              temp_ptr = temp_ptr->next_;

              // Explicitly call the destructor.
              hold_ptr->ACE_Hash_Map_Entry<EXT_ID, INT_ID>::~ACE_Hash_Map_Entry ();
              this->allocator_->free (hold_ptr);
            }

          // Now deal with the sentinel by explicitly calling the
          // destructor.
#ifdef HPUX_11
          (&table_[i])->ACE_Hash_Map_Entry<EXT_ID, INT_ID>::~ACE_Hash_Map_Entry ();
#else
          table_[i].ACE_Hash_Map_Entry<EXT_ID, INT_ID>::~ACE_Hash_Map_Entry ();
#endif
        }

      // Free table memory
      this->allocator_->free (this->table_);
      this->table_ = 0;
    }
  return 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::close (void)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->close_i ();
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::~ACE_Hash_Map_Manager (void)
{
  this->close ();
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> size_t
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::current_size (void)
{
  return this->cur_size_;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> size_t
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::total_size (void)
{
  return this->total_size_;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> u_long
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::hash (const EXT_ID &ext_id)
{
  return ext_id.hash ();
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::equal (const EXT_ID &id1,
                                                       const EXT_ID &id2)
{
  return id1 == id2;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::bind_i (const EXT_ID &ext_id,
                                                        const INT_ID &int_id,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  u_long loc;
  int result = this->shared_find (ext_id, entry, loc);

  if (result == -1)
    {
      void *ptr;
      // Not found.
      ACE_ALLOCATOR_RETURN (ptr,
                            this->allocator_->malloc (sizeof (ACE_Hash_Map_Entry<EXT_ID, INT_ID>)),
                            -1);

      this->table_[loc].next_ = entry =
        new (ptr) ACE_Hash_Map_Entry<EXT_ID, INT_ID> (ext_id,
                                                      int_id,
                                                      this->table_[loc].next_,
                                                      &this->table_[loc]);
      entry->next_->prev_ = entry;
      this->table_[loc].next_ = entry;

      this->cur_size_++;
      return 0;
    }
  else
    return 1;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::bind_i (const EXT_ID &ext_id,
                                                        const INT_ID &int_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *temp;

  return this->bind_i (ext_id, int_id, temp);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::bind (const EXT_ID &ext_id,
                                                      const INT_ID &int_id)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->bind_i (ext_id, int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::bind (const EXT_ID &ext_id,
                                                      const INT_ID &int_id,
                                                      ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->bind_i (ext_id, int_id, entry);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::trybind_i (const EXT_ID &ext_id,
                                                           INT_ID &int_id,
                                                           ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  u_long loc;
  int result = this->shared_find (ext_id, entry, loc);

  if (result == -1)
    {
      // Not found.
      void *ptr;
      ACE_ALLOCATOR_RETURN (ptr,
                            this->allocator_->malloc (sizeof (ACE_Hash_Map_Entry<EXT_ID, INT_ID>)),
                            -1);

      this->table_[loc].next_ = entry =
        new (ptr) ACE_Hash_Map_Entry<EXT_ID, INT_ID> (ext_id,
                                                      int_id,
                                                      this->table_[loc].next_,
                                                      &this->table_[loc]);

      this->cur_size_++;
      return 0;
    }
  else
    {
      entry->int_id_ = int_id;
      return 1;
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::trybind_i (const EXT_ID &ext_id,
                                                           INT_ID &int_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *temp;

  return this->trybind_i (ext_id, int_id, temp);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::trybind (const EXT_ID &ext_id,
                                                         INT_ID &int_id)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->trybind_i (ext_id, int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::trybind (const EXT_ID &ext_id,
                                                         INT_ID &int_id,
                                                         ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->trybind_i (ext_id, int_id, entry);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind_i (const EXT_ID &ext_id,
                                                          INT_ID &int_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *temp;

  u_long loc;
  int result = this->shared_find (ext_id, temp, loc);

  if (result == -1)
    {
      errno = ENOENT;
      return -1;
    }

  int_id = temp->int_id_;

  return this->unbind_i (temp);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind_i (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *entry)
{
  entry->next_->prev_ = entry->prev_;
  entry->prev_->next_ = entry->next_;

  // Explicitly call the destructor.
  entry->ACE_Hash_Map_Entry<EXT_ID, INT_ID>::~ACE_Hash_Map_Entry ();
  this->allocator_->free (entry);
  this->cur_size_--;
  return 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind_i (const EXT_ID &ext_id)
{
  INT_ID int_id;

  return this->unbind_i (ext_id, int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind (const EXT_ID &ext_id,
                                                        INT_ID &int_id)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->unbind_i (ext_id, int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind (const EXT_ID &ext_id)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->unbind_i (ext_id) == -1 ? -1 : 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::unbind (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *entry)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->unbind_i (entry) == -1 ? -1 : 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::shared_find (const EXT_ID &ext_id,
                                                             ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry,
                                                             u_long &loc)
{
  loc = this->hash (ext_id) % this->total_size_;

  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *temp = this->table_[loc].next_;

  while (temp != &this->table_[loc] && this->equal (temp->ext_id_, ext_id) == 0)
    temp = temp->next_;

  if (temp == &this->table_[loc])
    {
      errno = ENOENT;
      return -1;
    }
  else
    {
      entry = temp;
      return 0;
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find_i (const EXT_ID &ext_id,
                                                        INT_ID &int_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *entry;

  u_long dummy;
  if (this->shared_find (ext_id, entry, dummy) == -1)
    return -1;
  else
    {
      int_id = entry->int_id_;
      return 0;
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find_i (const EXT_ID &ext_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *entry;

  u_long dummy;
  return this->shared_find (ext_id, entry, dummy);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find (const EXT_ID &ext_id,
                                                      INT_ID &int_id)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->find_i (ext_id, int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find (const EXT_ID &ext_id)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->find_i (ext_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find_i (const EXT_ID &ext_id,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  u_long dummy;
  return this->shared_find (ext_id, entry, dummy);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::find (const EXT_ID &ext_id,
                                                      ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->find_i (ext_id, entry);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::rebind_i (const EXT_ID &ext_id,
                                                          const INT_ID &int_id,
                                                          EXT_ID &old_ext_id,
                                                          INT_ID &old_int_id,
                                                          ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  u_long dummy;
  if (this->shared_find (ext_id, entry, dummy) == -1)
    return this->bind_i (ext_id, int_id);
  else
    {
      old_ext_id = entry->ext_id_;
      old_int_id = entry->int_id_;
      entry->ext_id_ = ext_id;
      entry->int_id_ = int_id;
      return 1;
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::rebind_i (const EXT_ID &ext_id,
                                                          const INT_ID &int_id,
                                                          EXT_ID &old_ext_id,
                                                          INT_ID &old_int_id)
{
  ACE_Hash_Map_Entry<EXT_ID, INT_ID> *node;

  return this->rebind_i (ext_id,
                         int_id,
                         old_ext_id,
                         old_int_id,
                         node);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::rebind (const EXT_ID &ext_id,
                                                        const INT_ID &int_id,
                                                        EXT_ID &old_ext_id,
                                                        INT_ID &old_int_id)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->rebind_i (ext_id, int_id, old_ext_id, old_int_id);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK>::rebind (const EXT_ID &ext_id,
                                                        const INT_ID &int_id,
                                                        EXT_ID &old_ext_id,
                                                        INT_ID &old_int_id,
                                                        ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_WRITE_GUARD_RETURN (ACE_LOCK, ace_mon, this->lock_, -1);

  return this->rebind_i (ext_id, int_id, old_ext_id, old_int_id, entry);
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> void
ACE_Hash_Map_Iterator<EXT_ID, INT_ID, ACE_LOCK>::dump (void) const
{

  ACE_DEBUG ((LM_DEBUG, ACE_BEGIN_DUMP, this));
  ACE_DEBUG ((LM_DEBUG, "next_ = %d", this->next_));
  ACE_DEBUG ((LM_DEBUG, ACE_END_DUMP));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>
ACE_Hash_Map_Iterator<EXT_ID, INT_ID, ACE_LOCK>::ACE_Hash_Map_Iterator (ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK> &mm)
  : map_man_ (mm),
    index_ (0),
    next_ (0)
{
  if (this->map_man_.table_ != 0)
    {
      this->next_ = &this->map_man_.table_[this->index_];
      this->advance ();
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>  int
ACE_Hash_Map_Iterator<EXT_ID, INT_ID, ACE_LOCK>::next (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ != 0
      && this->index_ < this->map_man_.total_size_
      && this->next_ != &this->map_man_.table_[this->index_])
    {
      entry = this->next_;
      return 1;
    }
  else
    return 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>  int
ACE_Hash_Map_Iterator<EXT_ID, INT_ID, ACE_LOCK>::done (void) const
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ != 0
      && this->index_ < this->map_man_.total_size_
      && this->next_ != &this->map_man_.table_[this->index_])
    return 0;
  else
    return 1;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Iterator<EXT_ID, INT_ID, ACE_LOCK>::advance (void)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ == 0)
    return -1;

  if (this->next_->next_ != &this->map_man_.table_[this->index_])
    this->next_ = this->next_->next_;
  else
    while (++this->index_ < this->map_man_.total_size_)
      {
        this->next_ = &this->map_man_.table_[this->index_];
        if (this->next_->next_ != &this->map_man_.table_[this->index_])
          {
            this->next_ = this->map_man_.table_[this->index_].next_;
            break;
          }
      }

  return this->index_ < this->map_man_.total_size_
    && this->next_ != &this->map_man_.table_[this->index_];
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> void
ACE_Hash_Map_Reverse_Iterator<EXT_ID, INT_ID, ACE_LOCK>::dump (void) const
{

  ACE_DEBUG ((LM_DEBUG, ACE_BEGIN_DUMP, this));
  ACE_DEBUG ((LM_DEBUG, "next_ = %d", this->next_));
  ACE_DEBUG ((LM_DEBUG, ACE_END_DUMP));
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>
ACE_Hash_Map_Reverse_Iterator<EXT_ID, INT_ID, ACE_LOCK>::ACE_Hash_Map_Reverse_Iterator (ACE_Hash_Map_Manager<EXT_ID, INT_ID, ACE_LOCK> &mm)
  : map_man_ (mm),
    index_ (mm.total_size_ - 1),
    next_ (0)
{
  if (this->map_man_.table_ != 0)
    {
      this->next_ = &this->map_man_.table_[this->index_];
      this->advance ();
    }
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>  int
ACE_Hash_Map_Reverse_Iterator<EXT_ID, INT_ID, ACE_LOCK>::next (ACE_Hash_Map_Entry<EXT_ID, INT_ID> *&entry)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ != 0
      && this->index_ >= 0
      && this->next_ != &this->map_man_.table_[this->index_])
    {
      entry = this->next_;
      return 1;
    }
  else
    return 0;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK>  int
ACE_Hash_Map_Reverse_Iterator<EXT_ID, INT_ID, ACE_LOCK>::done (void) const
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ != 0
      && this->index_ >= 0
      && this->next_ != &this->map_man_.table_[this->index_])
    return 0;
  else
    return 1;
}

template <class EXT_ID, class INT_ID, class ACE_LOCK> int
ACE_Hash_Map_Reverse_Iterator<EXT_ID, INT_ID, ACE_LOCK>::advance (void)
{
  ACE_READ_GUARD_RETURN (ACE_LOCK, ace_mon, this->map_man_.lock_, -1);

  if (this->map_man_.table_ == 0)
    return -1;

  if (this->next_->prev_ != &this->map_man_.table_[this->index_])
    this->next_ = this->next_->prev_;
  else
    while (--this->index_ >= 0)
      {
        this->next_ = &this->map_man_.table_[this->index_];
        if (this->next_->prev_ != &this->map_man_.table_[this->index_])
          {
            this->next_ = this->map_man_.table_[this->index_].prev_;
            break;
          }
      }

  return this->index_ >= 0
    && this->next_ != &this->map_man_.table_[this->index_];
}

#endif /* ACE_HASH_MAP_MANAGER_C */
