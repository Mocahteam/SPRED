// GeiOfficeCtrl.cpp : impl�mentation de la classe du contr�le ActiveX CGeiOfficeCtrl.

#include "stdafx.h"
#include "GeiOffice.h"
#include "GeiOfficeCtrl.h"
#include "GeiOfficePropPage.h"
#include ".\geiofficectrl.h"

#include "GeiVC.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


IMPLEMENT_DYNCREATE(CGeiOfficeCtrl, COleControl)



// Table des messages

BEGIN_MESSAGE_MAP(CGeiOfficeCtrl, COleControl)
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()



// Table de dispatch

BEGIN_DISPATCH_MAP(CGeiOfficeCtrl, COleControl)
	DISP_FUNCTION_ID(CGeiOfficeCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
	DISP_FUNCTION_ID(CGeiOfficeCtrl, "Ouvrir", dispidOuvrir, Ouvrir, VT_I4, VTS_NONE)
END_DISPATCH_MAP()



// Table d'�v�nement

BEGIN_EVENT_MAP(CGeiOfficeCtrl, COleControl)
END_EVENT_MAP()



// Pages de propri�t�s

// TODO�: ajoutez autant de pages de propri�t�s que n�cessaire. N'oubliez pas d'augmenter le compteur�!
BEGIN_PROPPAGEIDS(CGeiOfficeCtrl, 1)
	PROPPAGEID(CGeiOfficePropPage::guid)
END_PROPPAGEIDS(CGeiOfficeCtrl)



// Initialisation de la fabrique de classe et du guid

IMPLEMENT_OLECREATE_EX(CGeiOfficeCtrl, "GEIOFFICE.GeiOfficeCtrl.1",
	0x5e5f0085, 0xdd52, 0x4bc5, 0xbc, 0x1e, 0x27, 0xc8, 0xd3, 0x2e, 0xa0, 0x74)



// ID et version de biblioth�que de types

IMPLEMENT_OLETYPELIB(CGeiOfficeCtrl, _tlid, _wVerMajor, _wVerMinor)



// ID d'interface

const IID BASED_CODE IID_DGeiOffice =
		{ 0x868D285D, 0x30C0, 0x4BEB, { 0x8C, 0x7F, 0x4F, 0xFF, 0x51, 0x5A, 0xE0, 0x6B } };
const IID BASED_CODE IID_DGeiOfficeEvents =
		{ 0x9D467E95, 0x6238, 0x4111, { 0x98, 0x61, 0xDF, 0xAD, 0x1E, 0x49, 0x0, 0xC8 } };



// Informations de type du contr�le

static const DWORD BASED_CODE _dwGeiOfficeOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CGeiOfficeCtrl, IDS_GEIOFFICE, _dwGeiOfficeOleMisc)



// CGeiOfficeCtrl::CGeiOfficeCtrlFactory::UpdateRegistry -
// Ajoute ou supprime les entr�es de la base de registres pour CGeiOfficeCtrl

BOOL CGeiOfficeCtrl::CGeiOfficeCtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO�: v�rifiez que votre contr�le suit les r�gles du mod�le de thread apartment.
	// Reportez-vous � MFC TechNote 64 pour plus d'informations.
	// Si votre contr�le ne se conforme pas aux r�gles du mod�le apartment, vous
	// devez modifier le code ci-dessous, en modifiant le 6� param�tre de
	// afxRegApartmentThreading en 0.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_GEIOFFICE,
			IDB_GEIOFFICE,
			afxRegApartmentThreading,
			_dwGeiOfficeOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}



// CGeiOfficeCtrl::CGeiOfficeCtrl - Constructeur

CGeiOfficeCtrl::CGeiOfficeCtrl()
{
	InitializeIIDs(&IID_DGeiOffice, &IID_DGeiOfficeEvents);
	// TODO�: initialisez ici les donn�es de l'instance de votre contr�le.
}



// CGeiOfficeCtrl::~CGeiOfficeCtrl - Destructeur

CGeiOfficeCtrl::~CGeiOfficeCtrl()
{
	// TODO�: nettoyez ici les donn�es de l'instance de votre contr�le.
}



// CGeiOfficeCtrl::OnDraw - Fonction de dessin

void CGeiOfficeCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	if (!pdc)
		return;

	// TODO�: remplacez le code suivant par votre code dessin.
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	pdc->Ellipse(rcBounds);
}



// CGeiOfficeCtrl::DoPropExchange - Prise en charge de la persistance

void CGeiOfficeCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO�: appelez les fonctions PX_ pour chaque propri�t� personnalis�e persistante.
}



// CGeiOfficeCtrl::OnResetState - R�initialise le contr�le � son �tat par d�faut

void CGeiOfficeCtrl::OnResetState()
{
	COleControl::OnResetState();  // R�initialise les valeurs par d�faut trouv�es dans DoPropExchange

	// TODO�: r�initialisez ici les autres valeurs d'�tat du contr�le.
}



// CGeiOfficeCtrl::AboutBox - Affiche une bo�te de dialogue "� propos de" � l'utilisateur

void CGeiOfficeCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_GEIOFFICE);
	dlgAbout.DoModal();
}



// Gestionnaires de messages CGeiOfficeCtrl

LONG CGeiOfficeCtrl::Ouvrir(void)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// TODO�: ajoutez ici le code de votre gestionnaire de dispatch

	return GEI_Open();
}
