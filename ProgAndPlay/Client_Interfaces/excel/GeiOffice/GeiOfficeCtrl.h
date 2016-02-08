#pragma once

// GeiOfficeCtrl.h : déclaration de la classe du contrôle ActiveX CGeiOfficeCtrl.


// CGeiOfficeCtrl : consultez GeiOfficeCtrl.cpp pour l'implémentation.

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

// Implémentation
protected:
	~CGeiOfficeCtrl();

	DECLARE_OLECREATE_EX(CGeiOfficeCtrl)    // Fabrique de classe et guid
	DECLARE_OLETYPELIB(CGeiOfficeCtrl)      // GetTypeInfo
	DECLARE_PROPPAGEIDS(CGeiOfficeCtrl)     // ID de page de propriétés
	DECLARE_OLECTLTYPE(CGeiOfficeCtrl)		// Nom de type et état divers

// Tables des messages
	DECLARE_MESSAGE_MAP()

// Tables de dispatch
	DECLARE_DISPATCH_MAP()

	afx_msg void AboutBox();

// Tables d'événements
	DECLARE_EVENT_MAP()

// ID de dispatch et d'événement
public:
	enum {
		dispidOuvrir = 1L
	};
protected:
	LONG Ouvrir(void);
};

