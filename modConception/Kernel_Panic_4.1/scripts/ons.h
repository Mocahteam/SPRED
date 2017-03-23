
#ifndef MAX_ID
#define MAX_ID 70
#endif
#ifndef MY_ID
#define MY_ID 71
#endif
#ifndef UNIT_TEAM
#define UNIT_TEAM 72
#endif
#ifndef UNIT_BUILD_PERCENT_LEFT
#define UNIT_BUILD_PERCENT_LEFT 73
#endif
#ifndef UNIT_ALLIED
#define UNIT_ALLIED 74
#endif
#ifndef PRINT
#define PRINT 81
#endif


#ifndef LUA0 // Whether the lua call worked
#define LUA0 110
#endif
#ifndef LUA1 // First argument returned
#define LUA1 111
#endif
#ifndef LUA2 // Second argument returned
#define LUA2 112
#endif
#ifndef LUA3 // Third argument returned
#define LUA3 113
#endif
#ifndef LUA4 // Fourth argument returned
#define LUA4 114
#endif
#ifndef LUA5 // Fifth argument returned
#define LUA5 115
#endif
#ifndef LUA6 // Sixth argument returned
#define LUA6 116
#endif
#ifndef LUA7 // Seventh argument returned
#define LUA7 117
#endif
#ifndef LUA8 // Eighth argument returned
#define LUA8 118
#endif
#ifndef LUA9 // Ninth argument returned
#define LUA9 119
#endif

static-var onsmode;
static-var UnitExists,Shielded,GreenShield,RedShield,SourceFound,SourceID;

// Dummy function used just so Scriptor can compile.
// In reality it's the LUA function which will be called.
lua_GetWhetherONSMode()
{
	return(0);
}

// Dummy function used just so Scriptor can compile.
// In reality it's the LUA function which will be called.
lua_GetONSInfo()
{
	return(0);
}

// Dummy function used just so Scriptor can compile.
// In reality it's the LUA function which will be called.
lua_GetBeamSource()
{
	return(0);
}

ManageONS()//this function checks if any socket, window or port is present
{
	var d,increment,angle;
	onsmode=0;
	UnitExists=0;
	Shielded=0;
	GreenShield=0;
	RedShield=0;
	SourceFound=0;
	SourceID=0;
	sleep 1;
	sleep 1;
	sleep 1;
	call-script lua_GetWhetherONSMode();
	onsmode=get LUA1;
	while(TRUE)
	{
		call-script lua_GetONSInfo();
		UnitExists=get LUA1;
		Shielded=get LUA2;
		GreenShield=get LUA3;
		RedShield=get LUA4;
		SourceFound=get LUA5;
		SourceID=get LUA6;
		#if 0 /* Now arcs are drawn in LUA */
		if(SourceFound)
		{
			move shoulder to y-axis 2*get UNIT_HEIGHT(get MY_ID) now;
			turn shoulder to y-axis get XZ_ATAN(get PIECE_XZ(0) - get UNIT_XZ(SourceID)) now;
			turn shoulder to x-axis 0 - get ATAN(get UNIT_Y(SourceID) + ((3*get UNIT_HEIGHT(SourceID))) - get PIECE_Y(shoulder),get XZ_HYPOT(get PIECE_XZ(shoulder) -  get UNIT_XZ(SourceID))) now;
			d=get HYPOT(get XZ_HYPOT(get PIECE_XZ(shoulder) -  get UNIT_XZ(SourceID)),get UNIT_Y(SourceID) + ((3*get UNIT_HEIGHT(SourceID))) - get PIECE_Y(shoulder));
			move arm to z-axis d/2 now;
			move arm to y-axis 0 - (d/2) now;
			move hand to y-axis (d/200)*141 now;
			// We're getting near the max with distance, so division must come before multiplication
			// or else the 32 bits signed integer overflow, and wreck the script
			increment=(5242880)/(d/65536);
			angle=(<-45>);//+rand(0 - increment,increment);
			while(angle<=(<45>))
			{
				turn arm to x-axis angle now;
				turn hand to x-axis increment/2 now;
				emit-sfx 1024 from hand;
				//turn hand to x-axis 32768 - increment/2 now;
				//emit-sfx 1024 from hand;
				angle=angle+increment;
			}
		}
		/* ARMORED state not used anymore, damage now nullified via LUA */
		//set ARMORED to Shielded;
		#endif
		sleep 2000;
	}
}


AimFromWeapon2(p)
{
	p=0;
}

AimWeapon2(h,p)
{
	return GreenShield;
}

QueryWeapon2(p)
{
	p=0;
}

FireWeapon2()
{
	return;
}

AimFromWeapon3(p)
{
	p=0;
}

AimWeapon3(h,p)
{
	return RedShield;
}

QueryWeapon3(p)
{
	p=0;
}

FireWeapon3()
{
	return;
}











