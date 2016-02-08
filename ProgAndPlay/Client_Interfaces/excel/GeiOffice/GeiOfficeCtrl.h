#pragma once

// GeiOfficeCtrl.h : d�claration de la classe du contr�le ActiveX CGeiOfficeCtrl.


// CGeiOfficeCtrl : consultez GeiOfficeCtrl.cpp pour l'impl�mentation.

class CGeiOfficeCtrl : public COleControl
{
	DECLARE_DYNCREATE(CGeiOfficeCtrl)

// Constructeur
public:
	CGeiOfficeCtrl();

// Overrides
public:
	virtual void OnDraw(CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid);
	virtual void DoPropExchange(CPropExchange* pPX);
	virtual void OnResetState();

// Impl�mentation
protected:
	~CGeiOfficeCtrl();

	DECLARE_OLECREATE_EX(CGeiOfficeCtrl)    // Fabrique de classe et guid
	DECLARE_OLETYPELIB(CGeiOfficeCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CGeiOfficeCtrl)     // ID de page de propri�t�s
	DECLARE_OLECTLTYPE(CGeiOfficeCtrl)		// Nom de type et �tat divers

// Tables des messages
	DECLARE_MESSAGE_MAP()

// Tables de dispatch
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Tables d'�v�nements
	DECLARE_EVENT_MAP()

// ID de dispatch et d'�v�nement
public:
	enum {
		dispidOuvrir = 1L
	};
protected:
	LONG Ouvrir(void);
};

