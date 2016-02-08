

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 6.00.0361 */
/* at Wed Jan 07 18:38:14 2009
 */
/* Compiler settings for .\GeiOffice.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#pragma warning( disable: 4049 )  /* more than 64k source lines */


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__


#ifndef __GeiOfficeidl_h__
#define __GeiOfficeidl_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef ___DGeiOffice_FWD_DEFINED__
#define ___DGeiOffice_FWD_DEFINED__
typedef interface _DGeiOffice _DGeiOffice;
#endif 	/* ___DGeiOffice_FWD_DEFINED__ */


#ifndef ___DGeiOfficeEvents_FWD_DEFINED__
#define ___DGeiOfficeEvents_FWD_DEFINED__
typedef interface _DGeiOfficeEvents _DGeiOfficeEvents;
#endif 	/* ___DGeiOfficeEvents_FWD_DEFINED__ */


#ifndef __GeiOffice_FWD_DEFINED__
#define __GeiOffice_FWD_DEFINED__

#ifdef __cplusplus
typedef class GeiOffice GeiOffice;
#else
typedef struct GeiOffice GeiOffice;
#endif /* __cplusplus */

#endif 	/* __GeiOffice_FWD_DEFINED__ */


#ifdef __cplusplus
extern "C"{
#endif 

void * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void * ); 


#ifndef __GeiOfficeLib_LIBRARY_DEFINED__
#define __GeiOfficeLib_LIBRARY_DEFINED__

/* library GeiOfficeLib */
/* [control][helpstring][helpfile][version][uuid] */ 


EXTERN_C const IID LIBID_GeiOfficeLib;

#ifndef ___DGeiOffice_DISPINTERFACE_DEFINED__
#define ___DGeiOffice_DISPINTERFACE_DEFINED__

/* dispinterface _DGeiOffice */
/* [helpstring][uuid] */ 


EXTERN_C const IID DIID__DGeiOffice;

#if defined(__cplusplus) && !defined(CINTERFACE)

    MIDL_INTERFACE("868D285D-30C0-4BEB-8C7F-4FFF515AE06B")
    _DGeiOffice : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct _DGeiOfficeVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            _DGeiOffice * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            _DGeiOffice * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            _DGeiOffice * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            _DGeiOffice * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            _DGeiOffice * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            _DGeiOffice * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            _DGeiOffice * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        END_INTERFACE
    } _DGeiOfficeVtbl;

    interface _DGeiOffice
    {
        CONST_VTBL struct _DGeiOfficeVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define _DGeiOffice_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define _DGeiOffice_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define _DGeiOffice_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define _DGeiOffice_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define _DGeiOffice_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define _DGeiOffice_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define _DGeiOffice_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* ___DGeiOffice_DISPINTERFACE_DEFINED__ */


#ifndef ___DGeiOfficeEvents_DISPINTERFACE_DEFINED__
#define ___DGeiOfficeEvents_DISPINTERFACE_DEFINED__

/* dispinterface _DGeiOfficeEvents */
/* [helpstring][uuid] */ 


EXTERN_C const IID DIID__DGeiOfficeEvents;

#if defined(__cplusplus) && !defined(CINTERFACE)

    MIDL_INTERFACE("9D467E95-6238-4111-9861-DFAD1E4900C8")
    _DGeiOfficeEvents : public IDispatch
    {
    };
    
#else 	/* C style interface */

    typedef struct _DGeiOfficeEventsVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            _DGeiOfficeEvents * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            _DGeiOfficeEvents * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            _DGeiOfficeEvents * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfoCount )( 
            _DGeiOfficeEvents * This,
            /* [out] */ UINT *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetTypeInfo )( 
            _DGeiOfficeEvents * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo **ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE *GetIDsOfNames )( 
            _DGeiOfficeEvents * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE *Invoke )( 
            _DGeiOfficeEvents * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS *pDispParams,
            /* [out] */ VARIANT *pVarResult,
            /* [out] */ EXCEPINFO *pExcepInfo,
            /* [out] */ UINT *puArgErr);
        
        END_INTERFACE
    } _DGeiOfficeEventsVtbl;

    interface _DGeiOfficeEvents
    {
        CONST_VTBL struct _DGeiOfficeEventsVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define _DGeiOfficeEvents_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define _DGeiOfficeEvents_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define _DGeiOfficeEvents_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define _DGeiOfficeEvents_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define _DGeiOfficeEvents_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define _DGeiOfficeEvents_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define _DGeiOfficeEvents_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)

#endif /* COBJMACROS */


#endif 	/* C style interface */


#endif 	/* ___DGeiOfficeEvents_DISPINTERFACE_DEFINED__ */


EXTERN_C const CLSID CLSID_GeiOffice;

#ifdef __cplusplus

class DECLSPEC_UUID("5E5F0085-DD52-4BC5-BC1E-27C8D32EA074")
GeiOffice;
#endif
#endif /* __GeiOfficeLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


