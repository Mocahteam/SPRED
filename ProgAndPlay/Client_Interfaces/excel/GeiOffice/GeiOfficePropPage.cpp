// GeiOfficePropPage.cpp : implémentation de la classe de la page de propriétés CGeiOfficePropPage.

#include "stdafx.h"
#include "GeiOffice.h"
#include "GeiOfficePropPage.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


IMPLEMENT_DYNCREATE(CGeiOfficePropPage, COlePropertyPage)



// Table des messages

BEGIN_MESSAGE_MAP(CGeiOfficePropPage, COlePropertyPage)
END_MESSAGE_MAP()



// Initialisation de la fabrique de classe et du guid

IMPLEMENT_OLECREATE_EX(CGeiOfficePropPage, "GEIOFFICE.GeiOfficePropPage.1",
	0x336b8a24, 0x41fd, 0x4633, 0x96, 0xa6, 0x1, 0x45, 0xc0, 0xb9, 0x4c, 0x6a)



// CGeiOfficePropPage::CGeiOfficePropPageFactory::UpdateRegistry -
// Ajoute ou supprime des entrées de la base de registres pour CGeiOfficePropPage

BOOL CGeiOfficePropPage::CGeiOfficePropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_GEIOFFICE_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}



// CGeiOfficePropPage::CGeiOfficePropPage - Constructeur

CGeiOfficePropPage::CGeiOfficePropPage() :
	COlePropertyPage(IDD, IDS_GEIOFFICE_PPG_CAPTION)
{
}



// CGeiOfficePropPage::DoDataExchange - Transfère les données entre la page et les propriétés

void CGeiOfficePropPage::DoDataExchange(CDataExchange* pDX)
{
	DDP_PostProcessing(pDX);
}



// Gestionnaires de messages CGeiOfficePropPage
