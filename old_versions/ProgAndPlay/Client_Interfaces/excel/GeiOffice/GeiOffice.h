#pragma once

// GeiOffice.h : fichier d'en-tête principal pour GeiOffice.DLL

#if !defined( __AFXCTL_H__ )
#error incluez 'afxctl.h' avant d'inclure ce fichier
#endif

#include "resource.h"       // symboles principaux


// CGeiOfficeApp : consultez GeiOffice.cpp pour l'implémentation.

class CGeiOfficeApp : public COleControlModule
{
public:
	BOOL InitInstance();
	int ExitInstance();
};

extern const GUID CDECL _tlid;
extern const WORD _wVerMajor;
extern const WORD _wVerMinor;

