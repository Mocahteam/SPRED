#pragma once

// GeiOfficePropPage.h : d�claration de la classe de page de propri�t�s CGeiOfficePropPage.


// CGeiOfficePropPage : consultez GeiOfficePropPage.cpp pour l'impl�mentation.

class CGeiOfficePropPage : public COlePropertyPage
{
	DECLARE_DYNCREATE(CGeiOfficePropPage)
	DECLARE_OLECREATE_EX(CGeiOfficePropPage)

// Constructeur
public:
	CGeiOfficePropPage();

// Donn�es de bo�te de dialogue
	enum { IDD = IDD_PROPPAGE_GEIOFFICE };

// Impl�mentation
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // Prise en charge DDX/DDV

// Tables des messages
protected:
	DECLARE_MESSAGE_MAP()
};

