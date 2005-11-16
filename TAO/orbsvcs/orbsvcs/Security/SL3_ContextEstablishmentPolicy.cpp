// $Id$

#include "SL3_ContextEstablishmentPolicy.h"


ACE_RCSID (Security,
           SL3_ContextEstablishmentPolicy,
           "$Id$")

TAO_BEGIN_VERSIONED_NAMESPACE_DECL

TAO::SL3::ContextEstablishmentPolicy::ContextEstablishmentPolicy (
  SecurityLevel3::CredsDirective             creds_directive,
  const SecurityLevel3::OwnCredentialsList & creds_list,
  SecurityLevel3::FeatureDirective           use_client_auth,
  SecurityLevel3::FeatureDirective           use_target_auth,
  SecurityLevel3::FeatureDirective           use_confidentiality,
  SecurityLevel3::FeatureDirective           use_integrity)
  : creds_directive_ (creds_directive),
    creds_list_ (creds_list),
    use_client_auth_ (use_client_auth),
    use_target_auth_ (use_target_auth),
    use_confidentiality_ (use_confidentiality),
    use_integrity_ (use_integrity)
{
}

TAO::SL3::ContextEstablishmentPolicy::~ContextEstablishmentPolicy (void)
{
}

SecurityLevel3::CredsDirective
TAO::SL3::ContextEstablishmentPolicy::creds_directive (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return this->creds_directive_;
}

SecurityLevel3::OwnCredentialsList *
TAO::SL3::ContextEstablishmentPolicy::creds_list (ACE_ENV_SINGLE_ARG_DECL)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  SecurityLevel3::OwnCredentialsList * creds = 0;

  ACE_NEW_THROW_EX (creds,
                    SecurityLevel3::OwnCredentialsList (this->creds_list_),
                    CORBA::NO_MEMORY ());
  ACE_CHECK_RETURN (creds);

  return creds;
}

SecurityLevel3::FeatureDirective
TAO::SL3::ContextEstablishmentPolicy::use_client_auth (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return this->use_client_auth_;
}

SecurityLevel3::FeatureDirective
TAO::SL3::ContextEstablishmentPolicy::use_target_auth (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return this->use_target_auth_;
}

SecurityLevel3::FeatureDirective
TAO::SL3::ContextEstablishmentPolicy::use_confidentiality (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return this->use_confidentiality_;
}

SecurityLevel3::FeatureDirective
TAO::SL3::ContextEstablishmentPolicy::use_integrity (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return this->use_integrity_;
}

CORBA::PolicyType
TAO::SL3::ContextEstablishmentPolicy::policy_type (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  return SecurityLevel3::ContextEstablishmentPolicyType;
}

CORBA::Policy_ptr
TAO::SL3::ContextEstablishmentPolicy::copy (ACE_ENV_SINGLE_ARG_DECL)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  CORBA::Policy_ptr p = CORBA::Policy::_nil ();
  ACE_NEW_THROW_EX (p,
                    TAO::SL3::ContextEstablishmentPolicy (
                      this->creds_directive_,
                      this->creds_list_,
                      this->use_client_auth_,
                      this->use_target_auth_,
                      this->use_confidentiality_,
                      this->use_integrity_),
                    CORBA::NO_MEMORY ());
  ACE_CHECK_RETURN (p);

  return p;
}

void
TAO::SL3::ContextEstablishmentPolicy::destroy (
    ACE_ENV_SINGLE_ARG_DECL_NOT_USED)
  ACE_THROW_SPEC ((CORBA::SystemException))
{
  this->creds_directive_     = SecurityLevel3::CD_Default;
  this->creds_list_.length (0);
  this->use_client_auth_     = SecurityLevel3::FD_UseDefault;
  this->use_target_auth_     = SecurityLevel3::FD_UseDefault;
  this->use_confidentiality_ = SecurityLevel3::FD_UseDefault;
  this->use_integrity_       = SecurityLevel3::FD_UseDefault;
}

TAO_END_VERSIONED_NAMESPACE_DECL
