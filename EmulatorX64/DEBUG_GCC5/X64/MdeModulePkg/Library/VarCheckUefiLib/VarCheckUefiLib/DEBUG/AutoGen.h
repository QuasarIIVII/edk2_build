/**
  DO NOT EDIT
  FILE auto-generated
  Module name:
    AutoGen.h
  Abstract:       Auto-generated AutoGen.h for building module or library.
**/

#ifndef _AUTOGENH_AC24A4C7_F845_4665_90E5_6431D6E28DC0
#define _AUTOGENH_AC24A4C7_F845_4665_90E5_6431D6E28DC0

#ifdef __cplusplus
extern "C" {
#endif

#include <Base.h>

extern GUID  gEfiCallerIdGuid;
extern GUID  gEdkiiDscPlatformGuid;
extern CHAR8 *gEfiCallerBaseName;

#define STACK_COOKIE_VALUE 0xB22BC4D6389C4962ULL

// Guids
extern GUID gEfiGlobalVariableGuid;
extern GUID gEfiImageSecurityDatabaseGuid;
extern GUID gEfiHardwareErrorVariableGuid;

// Definition of SkuId Array
extern UINT64 _gPcd_SkuId_Array[];

RETURN_STATUS
EFIAPI
VarCheckUefiLibNullClassConstructor (
  VOID
  );


#ifdef __cplusplus
}
#endif

#endif
