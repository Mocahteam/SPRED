// GeiOffice.cpp : implémentation de CGeiOfficeApp et inscription de DLL.

#include "stdafx.h"
#include "GeiOffice.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


CGeiOfficeApp NEAR theApp;

const GUID CDECL BASED_CODE _tlid =
		{ 0xF643F63A, 0x704E, 0x4424, { 0xB3, 0x70, 0xE, 0xA9, 0xC9, 0x75, 0xD3, 0xDD } };
const WORD _wVerMajor = 1;
const WORD _wVerMinor = 0;



// CGeiOfficeApp::InitInstance - Initialisation de la DLL

BOOL CGeiOfficeApp::InitInstance()
{
	BOOL bInit = COleControlModule::InitInstance();

	if (bInit)
	{
		// TODO : ajoutez ici votre propre code d'initialisation de module.
	}

	return bInit;
}



// CGeiOfficeApp::ExitInstance - Fin de la DLL

int CGeiOfficeApp::ExitInstance()
{
	// TODO : ajoutez ici votre propre code d'arrêt de module.

	return COleControlModule::ExitInstance();
}



// DllRegisterServer - Ajoute des entrées à la base de registres

STDAPI DllRegisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleRegisterTypeLib(AfxGetInstanceHandle(), _tlid))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(TRUE))
		return ResultFromScode(SELFREG_E_CLASS);

	return NOERROR;
}



// DllUnregisterServer - Supprime les entrées de la base de registres

STDAPI DllUnregisterServer(void)
{
	AFX_MANAGE_STATE(_afxModuleAddrThis);

	if (!AfxOleUnregisterTypeLib(_tlid, _wVerMajor, _wVerMinor))
		return ResultFromScode(SELFREG_E_TYPELIB);

	if (!COleObjectFactoryEx::UpdateRegistryAll(FALSE))
		return ResultFromScode(SELFREG_E_CLASS);

	return NOERROR;
}
