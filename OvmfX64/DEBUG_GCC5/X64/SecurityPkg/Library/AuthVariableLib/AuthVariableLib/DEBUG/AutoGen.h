/**
  DO NOT EDIT
  FILE auto-generated
  Module name:
    AutoGen.h
  Abstract:       Auto-generated AutoGen.h for building module or library.
**/

#ifndef _AUTOGENH_B23CF5FB_6FCC_4422_B145_D855DBC05457
#define _AUTOGENH_B23CF5FB_6FCC_4422_B145_D855DBC05457

#ifdef __cplusplus
extern "C" {
#endif

#include <PiDxe.h>
#include <Library/PcdLib.h>

extern GUID  gEfiCallerIdGuid;
extern GUID  gEdkiiDscPlatformGuid;
extern CHAR8 *gEfiCallerBaseName;

#define STACK_COOKIE_VALUE 0xFDEAA6D9C9D0899EULL

// Guids
extern EFI_GUID gEfiGlobalVariableGuid;
extern EFI_GUID gEfiImageSecurityDatabaseGuid;
extern EFI_GUID gEfiSecureBootEnableDisableGuid;
extern EFI_GUID gEfiCustomModeEnableGuid;
extern EFI_GUID gEfiCertDbGuid;
extern EFI_GUID gEfiVendorKeysNvGuid;
extern EFI_GUID gEfiAuthenticatedVariableGuid;
extern EFI_GUID gEfiCertTypeRsa2048Sha256Guid;
extern EFI_GUID gEfiCertPkcs7Guid;
extern EFI_GUID gEfiCertX509Guid;
extern EFI_GUID gEfiMdeModulePkgTokenSpaceGuid;

// Definition of SkuId Array
extern UINT64 _gPcd_SkuId_Array[];

// PCD definitions
#define _PCD_TOKEN_PcdRequireSelfSignedPk  0U
extern const BOOLEAN _gPcd_FixedAtBuild_PcdRequireSelfSignedPk;
#define _PCD_GET_MODE_BOOL_PcdRequireSelfSignedPk  _gPcd_FixedAtBuild_PcdRequireSelfSignedPk
//#define _PCD_SET_MODE_BOOL_PcdRequireSelfSignedPk  ASSERT(FALSE)  // It is not allowed to set value for a FIXED_AT_BUILD PCD


#ifdef __cplusplus
}
#endif

#endif
