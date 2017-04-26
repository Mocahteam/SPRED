#pragma once

// GeiOfficePropPage.h : déclaration de la classe de page de propriétés CGeiOfficePropPage.


// CGeiOfficePropPage : consultez GeiOfficePropPage.cpp pour l'implémentation.

class CGeiOfficePropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CGeiOfficePropPage)
	DECLARE_OLECREATE_EX(CGeiOfficePropPage)

// Constructeur
public:
	CGeiOfficePropPage();

// Données de boîte de dialogue
	enum { IDD = IDD_PROPPAGE_GEIOFFICE };

// Implémentation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // Prise en charge DDX/DDV

// Tables des messages
protected:
	DECLARE_MESSAGE_MAP()
};

