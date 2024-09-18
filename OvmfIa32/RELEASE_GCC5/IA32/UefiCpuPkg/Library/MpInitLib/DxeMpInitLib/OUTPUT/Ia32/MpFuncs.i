;------------------------------------------------------------------------------ ;
; Copyright (c) 2015 - 2024, Intel Corporation. All rights reserved.<BR>
; SPDX-License-Identifier: BSD-2-Clause-Patent
;
; Module Name:
;
;   MpFuncs.nasm
;
; Abstract:
;
;   This is the assembly code for MP support
;
;-------------------------------------------------------------------------------


/**********************
*  MpEqu.inc --START  *
**********************/
;------------------------------------------------------------------------------ ;
; Copyright (c) 2015 - 2023, Intel Corporation. All rights reserved.<BR>
; SPDX-License-Identifier: BSD-2-Clause-Patent
;
; Module Name:
;
;   MpEqu.inc
;
; Abstract:
;
;   This is the equates file for Multiple Processor support
;
;-------------------------------------------------------------------------------

/*********************
*  Nasm.inc --START  *
*********************/
;------------------------------------------------------------------------------
;
; Copyright (c) 2019 - 2022, Intel Corporation. All rights reserved.<BR>
; SPDX-License-Identifier: BSD-2-Clause-Patent
;
; Abstract:
;
;   This file provides macro definitions for NASM files.
;
;------------------------------------------------------------------------------

; NASM provides built-in macros STRUC and ENDSTRUC for structure definition.
; For example, to define a structure called mytype containing a longword,
; a word, a byte and a string of bytes, you might code
;
; struc   mytype
;
;  mt_long:      resd    1
;  mt_word:      resw    1
;  mt_byte:      resb    1
;  mt_str:       resb    32
;
; endstruc
;
; Below macros are help to map the C types and the RESB family of pseudo-instructions.
; So that the above structure definition can be coded as
;
; struc   mytype
;
;  mt_long:      CTYPE_UINT32    1
;  mt_word:      CTYPE_UINT16    1
;  mt_byte:      CTYPE_UINT8     1
;  mt_str:       CTYPE_CHAR8     32
;
; endstruc
%define CTYPE_UINT64    resq
%define CTYPE_INT64     resq
%define CTYPE_UINT32    resd
%define CTYPE_INT32     resd
%define CTYPE_UINT16    resw
%define CTYPE_INT16     resw
%define CTYPE_BOOLEAN   resb
%define CTYPE_UINT8     resb
%define CTYPE_CHAR8     resb
%define CTYPE_INT8      resb

%define CTYPE_UINTN     resd
%define CTYPE_INTN      resd

/*******************
*  Nasm.inc --END  *
*******************/


CPU_SWITCH_STATE_IDLE         equ        0
CPU_SWITCH_STATE_STORED       equ        1
CPU_SWITCH_STATE_LOADED       equ        2

;
; Equivalent NASM structure of MP_ASSEMBLY_ADDRESS_MAP
;
struc MP_ASSEMBLY_ADDRESS_MAP
  .RendezvousFunnelAddress            CTYPE_UINTN 1
  .ModeEntryOffset                    CTYPE_UINTN 1
  .RendezvousFunnelSize               CTYPE_UINTN 1
  .RelocateApLoopFuncAddressGeneric   CTYPE_UINTN 1
  .RelocateApLoopFuncSizeGeneric      CTYPE_UINTN 1
  .RelocateApLoopFuncAddressAmdSev    CTYPE_UINTN 1
  .RelocateApLoopFuncSizeAmdSev       CTYPE_UINTN 1
  .ModeTransitionOffset               CTYPE_UINTN 1
  .SwitchToRealNoNxOffset             CTYPE_UINTN 1
  .SwitchToRealPM16ModeOffset         CTYPE_UINTN 1
  .SwitchToRealPM16ModeSize           CTYPE_UINTN 1
endstruc

;
; Equivalent NASM structure of IA32_DESCRIPTOR
;
struc IA32_DESCRIPTOR
  .Limit                         CTYPE_UINT16 1
  .Base                          CTYPE_UINTN  1
endstruc

;
; Equivalent NASM structure of CPU_EXCHANGE_ROLE_INFO
;
struc CPU_EXCHANGE_ROLE_INFO
  ; State is defined as UINT8 in C header file
  ; Define it as UINTN here to guarantee the fields that follow State
  ; is naturally aligned. The structure layout doesn't change.
  .State                         CTYPE_UINTN 1
  .StackPointer                  CTYPE_UINTN 1
  .Gdtr                          CTYPE_UINT8 IA32_DESCRIPTOR_size
  .Idtr                          CTYPE_UINT8 IA32_DESCRIPTOR_size
endstruc

;
; Equivalent NASM structure of CPU_INFO_IN_HOB
;
struc CPU_INFO_IN_HOB
  .InitialApicId                 CTYPE_UINT32 1
  .ApicId                        CTYPE_UINT32 1
  .Health                        CTYPE_UINT32 1
  .ApTopOfStack                  CTYPE_UINT64 1
endstruc

;
; Equivalent NASM structure of MP_CPU_EXCHANGE_INFO
; Assembly routines should refrain from directly interacting with
; the internal details of CPU_MP_DATA.
;
struc MP_CPU_EXCHANGE_INFO
  .StackStart:                   CTYPE_UINTN 1
  .StackSize:                    CTYPE_UINTN 1
  .CFunction:                    CTYPE_UINTN 1
  .GdtrProfile:                  CTYPE_UINT8 IA32_DESCRIPTOR_size
  .IdtrProfile:                  CTYPE_UINT8 IA32_DESCRIPTOR_size
  .BufferStart:                  CTYPE_UINTN 1
  .ModeOffset:                   CTYPE_UINTN 1
  .ApIndex:                      CTYPE_UINTN 1
  .CodeSegment:                  CTYPE_UINTN 1
  .DataSegment:                  CTYPE_UINTN 1
  .EnableExecuteDisable:         CTYPE_UINTN 1
  .Cr3:                          CTYPE_UINTN 1
  .InitFlag:                     CTYPE_UINTN 1
  .CpuInfo:                      CTYPE_UINTN 1
  .NumApsExecuting:              CTYPE_UINTN 1
  .CpuMpData:                    CTYPE_UINTN 1
  .InitializeFloatingPointUnits: CTYPE_UINTN 1
  .ModeTransitionMemory:         CTYPE_UINT32 1
  .ModeTransitionSegment:        CTYPE_UINT16 1
  .ModeHighMemory:               CTYPE_UINT32 1
  .ModeHighSegment:              CTYPE_UINT16 1
  .Enable5LevelPaging:           CTYPE_BOOLEAN 1
  .SevEsIsEnabled:               CTYPE_BOOLEAN 1
  .SevSnpIsEnabled               CTYPE_BOOLEAN 1
  .GhcbBase:                     CTYPE_UINTN 1
  .ExtTopoAvail:                 CTYPE_BOOLEAN 1
endstruc

MP_CPU_EXCHANGE_INFO_OFFSET equ (Flat32Start - RendezvousFunnelProcStart)
%define MP_CPU_EXCHANGE_INFO_FIELD(Field) (MP_CPU_EXCHANGE_INFO_OFFSET + MP_CPU_EXCHANGE_INFO. %+ Field)

/********************
*  MpEqu.inc --END  *
********************/

extern ASM_PFX(InitializeFloatingPointUnits)

SECTION .text

;-------------------------------------------------------------------------------------
;RendezvousFunnelProc  procedure follows. All APs execute their procedure. This
;procedure serializes all the AP processors through an Init sequence. It must be
;noted that APs arrive here very raw...ie: real mode, no stack.
;ALSO THIS PROCEDURE IS EXECUTED BY APs ONLY ON 16 BIT MODE. HENCE THIS PROC
;IS IN MACHINE CODE.
;-------------------------------------------------------------------------------------
RendezvousFunnelProcStart:
; At this point CS = 0x(vv00) and ip= 0x0.
BITS 16
    mov        ebp, eax                        ; save BIST information

    mov        ax, cs
    mov        ds, ax
    mov        es, ax
    mov        ss, ax
    xor        ax, ax
    mov        fs, ax
    mov        gs, ax

    mov        si,  MP_CPU_EXCHANGE_INFO_FIELD (BufferStart)
    mov        ebx, [si]

    mov        si,  MP_CPU_EXCHANGE_INFO_FIELD (DataSegment)
    mov        edx, [si]

    ;
    ; Get start address of 32-bit code in low memory (<1MB)
    ;
    mov        edi, MP_CPU_EXCHANGE_INFO_FIELD (ModeTransitionMemory)

    mov        si, MP_CPU_EXCHANGE_INFO_FIELD (GdtrProfile)
o32 lgdt       [cs:si]

    mov        si, MP_CPU_EXCHANGE_INFO_FIELD (IdtrProfile)
o32 lidt       [cs:si]

    ;
    ; Switch to protected mode
    ;
    mov        eax, cr0                        ; Get control register 0
    or         eax, 000000003h                 ; Set PE bit (bit #0) & MP
    mov        cr0, eax

    ; Switch to 32-bit code in executable memory (>1MB)
o32 jmp far    [cs:di]

;
; Following code may be copied to memory with type of EfiBootServicesCode.
; This is required at DXE phase if NX is enabled for EfiBootServicesCode of
; memory.
;
BITS 32
Flat32Start:                                   ; protected mode entry point
    mov        ds, dx
    mov        es, dx
    mov        fs, dx
    mov        gs, dx
    mov        ss, dx

    mov        esi, ebx

    mov         edi, esi
    add         edi, MP_CPU_EXCHANGE_INFO_FIELD (EnableExecuteDisable)
    cmp         byte [edi], 0
    jz          SkipEnableExecuteDisable

    ;
    ; Enable IA32 PAE execute disable
    ;

    mov         ecx, 0xc0000080
    rdmsr
    bts         eax, 11
    wrmsr

    mov         edi, esi
    add         edi, MP_CPU_EXCHANGE_INFO_FIELD (Cr3)
    mov         eax, dword [edi]
    mov         cr3, eax

    mov         eax, cr4
    bts         eax, 5
    mov         cr4, eax

    mov         eax, cr0
    bts         eax, 31
    mov         cr0, eax

SkipEnableExecuteDisable:
    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (InitFlag)
    cmp        dword [edi], 1       ; 1 == ApInitConfig
    jnz        GetApicId

    ; Increment the number of APs executing here as early as possible
    ; This is decremented in C code when AP is finished executing
    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (NumApsExecuting)
    lock inc   dword [edi]

    ; AP init
    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (ApIndex)
    mov        ebx, 1
    lock xadd  dword [edi], ebx                 ; EBX = ApIndex++
    inc        ebx                              ; EBX is CpuNumber

    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (StackSize)
    mov        eax, [edi]
    mov        ecx, ebx
    inc        ecx
    mul        ecx                               ; EAX = StackSize * (CpuNumber + 1)
    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (StackStart)
    add        eax, [edi]
    mov        esp, eax
    jmp        CProcedureInvoke

GetApicId:
    mov        eax, 0
    cpuid
    cmp        eax, 0bh
    jb         NoX2Apic             ; CPUID level below CPUID_EXTENDED_TOPOLOGY

    mov        eax, 0bh
    xor        ecx, ecx
    cpuid
    test       ebx, 0ffffh
    jz         NoX2Apic             ; CPUID.0BH:EBX[15:0] is zero

    ; Processor is x2APIC capable; 32-bit x2APIC ID is already in EDX
    jmp        GetProcessorNumber

NoX2Apic:
    ; Processor is not x2APIC capable, so get 8-bit APIC ID
    mov        eax, 1
    cpuid
    shr        ebx, 24
    mov        edx, ebx

GetProcessorNumber:
    ;
    ; Get processor number for this AP
    ; Note that BSP may become an AP due to SwitchBsp()
    ;
    xor         ebx, ebx
    lea         eax, [esi + MP_CPU_EXCHANGE_INFO_FIELD (CpuInfo)]
    mov         edi, [eax]

GetNextProcNumber:
    cmp         dword [edi + CPU_INFO_IN_HOB.InitialApicId], edx ; APIC ID match?
    jz          ProgramStack
    add         edi, CPU_INFO_IN_HOB_size
    inc         ebx
    jmp         GetNextProcNumber

ProgramStack:
    mov         esp, dword [edi + CPU_INFO_IN_HOB.ApTopOfStack]

CProcedureInvoke:
    ;
    ; Reserve 4 bytes for CpuMpData.
    ; When the AP wakes up again via INIT-SIPI-SIPI, push 0 will cause the existing CpuMpData to be overwritten with 0.
    ; CpuMpData is filled in via InitializeApData() during the first time INIT-SIPI-SIPI,
    ; while overwirrten may occurs when under ApInHltLoop but InitFlag is not set to ApInitConfig.
    ; Therefore reservation is implemented by sub esp instead of push 0.
    ;
    sub        esp, 4
    push       ebp               ; push BIST data at top of AP stack
    xor        ebp, ebp          ; clear ebp for call stack trace
    push       ebp
    mov        ebp, esp

    mov        eax, ASM_PFX(InitializeFloatingPointUnits)
    call       eax               ; Call assembly function to initialize FPU per UEFI spec

    push       ebx               ; Push ApIndex
    mov        eax, esi
    add        eax, MP_CPU_EXCHANGE_INFO_FIELD (CpuMpData)
    push       dword [eax]       ; push address of CpuMpData

    mov        edi, esi
    add        edi, MP_CPU_EXCHANGE_INFO_FIELD (CFunction)
    mov        eax, [edi]

    call       eax               ; Invoke C function

    jmp        $                 ; Never reach here

;-------------------------------------------------------------------------------------
;SwitchToRealProc procedure follows.
;NOT USED IN 32 BIT MODE.
;-------------------------------------------------------------------------------------
SwitchToRealProcStart:
    jmp        $                 ; Never reach here
SwitchToRealProcEnd:

RendezvousFunnelProcEnd:

;-------------------------------------------------------------------------------------
;  AsmRelocateApLoopGeneric (MwaitSupport, ApTargetCState, PmCodeSegment, TopOfApStack, CountTofinish, Pm16CodeSegment, SevEsAPJumpTable, WakeupBuffer);
;
;  The last three parameters (Pm16CodeSegment, SevEsAPJumpTable and WakeupBuffer) are
;  specific to SEV-ES support and are not applicable on IA32.
;-------------------------------------------------------------------------------------
AsmRelocateApLoopGenericStart:
    mov        eax, cr0
    btr        eax, 31             ; Clear CR0.PG
    mov        cr0, eax            ; Disable paging since the page table might be unavailiable

    mov        eax, esp
    mov        esp, [eax + 12]     ; TopOfApStack
    push       dword [eax]         ; push return address for stack trace
    push       ebp
    mov        ebp, esp
    mov        ebx, [eax + 8]      ; ApTargetCState
    mov        ecx, [eax + 4]      ; MwaitSupport
    mov        eax, [eax + 16]     ; CountTofinish
    lock dec   dword [eax]         ; (*CountTofinish)--
    cmp        cl,  1              ; Check mwait-monitor support
    jnz        HltLoopGeneric
MwaitLoopGeneric:
    cli
    mov        eax, esp
    xor        ecx, ecx
    xor        edx, edx
    monitor
    mov        eax, ebx            ; Mwait Cx, Target C-State per eax[7:4]
    shl        eax, 4
    mwait
    jmp        MwaitLoopGeneric
HltLoopGeneric:
    cli
    hlt
    jmp        HltLoopGeneric
AsmRelocateApLoopGenericEnd:

;-------------------------------------------------------------------------------------
;  AsmGetAddressMap (&AddressMap);
;-------------------------------------------------------------------------------------
global ASM_PFX(AsmGetAddressMap)
ASM_PFX(AsmGetAddressMap):
    pushad
    mov        ebp,esp

    mov        ebx,  [ebp + 24h]
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.RendezvousFunnelAddress], RendezvousFunnelProcStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.ModeEntryOffset], Flat32Start - RendezvousFunnelProcStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.RendezvousFunnelSize], RendezvousFunnelProcEnd - RendezvousFunnelProcStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.RelocateApLoopFuncAddressGeneric], AsmRelocateApLoopGenericStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.RelocateApLoopFuncSizeGeneric], AsmRelocateApLoopGenericEnd - AsmRelocateApLoopGenericStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.ModeTransitionOffset], Flat32Start - RendezvousFunnelProcStart
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.SwitchToRealNoNxOffset], SwitchToRealProcStart - Flat32Start
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.SwitchToRealPM16ModeOffset], 0
    mov        dword [ebx + MP_ASSEMBLY_ADDRESS_MAP.SwitchToRealPM16ModeSize], 0

    popad
    ret

;-------------------------------------------------------------------------------------
;AsmExchangeRole procedure follows. This procedure executed by current BSP, that is
;about to become an AP. It switches it'stack with the current AP.
;AsmExchangeRole (IN   CPU_EXCHANGE_INFO    *MyInfo, IN   CPU_EXCHANGE_INFO    *OthersInfo);
;-------------------------------------------------------------------------------------
global ASM_PFX(AsmExchangeRole)
ASM_PFX(AsmExchangeRole):
    ; DO NOT call other functions in this function, since 2 CPU may use 1 stack
    ; at the same time. If 1 CPU try to call a function, stack will be corrupted.
    pushad
    mov        ebp,esp

    ; esi contains MyInfo pointer
    mov        esi, [ebp + 24h]

    ; edi contains OthersInfo pointer
    mov        edi, [ebp + 28h]

    ;Store EFLAGS to stack
    pushfd

    ; Store the its StackPointer
    mov        [esi + CPU_EXCHANGE_ROLE_INFO.StackPointer],esp

    ; update its switch state to STORED
    mov        byte [esi + CPU_EXCHANGE_ROLE_INFO.State], CPU_SWITCH_STATE_STORED

WaitForOtherStored:
    ; wait until the other CPU finish storing its state
    cmp        byte [edi + CPU_EXCHANGE_ROLE_INFO.State], CPU_SWITCH_STATE_STORED
    jz         OtherStored
    pause
    jmp        WaitForOtherStored

OtherStored:
    ; load its future StackPointer
    mov        esp, [edi + CPU_EXCHANGE_ROLE_INFO.StackPointer]

    ; update the other CPU's switch state to LOADED
    mov        byte [edi + CPU_EXCHANGE_ROLE_INFO.State], CPU_SWITCH_STATE_LOADED

WaitForOtherLoaded:
    ; wait until the other CPU finish loading new state,
    ; otherwise the data in stack may corrupt
    cmp        byte [esi + CPU_EXCHANGE_ROLE_INFO.State], CPU_SWITCH_STATE_LOADED
    jz         OtherLoaded
    pause
    jmp        WaitForOtherLoaded

OtherLoaded:
    ; since the other CPU already get the data it want, leave this procedure
    popfd

    popad
    ret
