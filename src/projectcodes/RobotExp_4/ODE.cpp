#include "stdafx.h"
#include "ODE.h"
#include "SystemMemory.h"
#include "DataType.h"

#ifndef DRAWSTUFF_TEXTURE_PATH
#define DRAWSTUFF_TEXTURE_PATH "./../ode-0.13/drawstuff/textures"
#endif

#define GRAVITY 9.81
#define MAX_JOINT_NUM 2

#define DEG2RAD 0.0174533
#define RAD2DEG 57.2958

dsFunctions g_Fn;

static dWorldID g_World;
static dSpaceID g_Space;
static dJointGroupID g_Contactgroup;
static dGeomID g_Ground;


Object g_oObj[MAX_JOINT_NUM + 1];
static dJointID g_oJoint[MAX_JOINT_NUM + 1];

double g_tar_q[MAX_JOINT_NUM] = { 0.0, 0.0};
double g_cur_q[MAX_JOINT_NUM] = { 0.0, 0.0};

void InitDrawStuff() {

	g_Fn.version = DS_VERSION;
	g_Fn.start = &StartDrawStuff;
	g_Fn.step = &SimLoopDrawStuff;
	g_Fn.command = &CommandDrawStuff;
	g_Fn.stop = StopDrawStuff;
	g_Fn.path_to_textures = DRAWSTUFF_TEXTURE_PATH;
}


void InitODE() {

	//TO DO
	dInitODE();
	g_World = dWorldCreate();
	g_Space = dHashSpaceCreate(0);
	g_Contactgroup = dJointGroupCreate(0);
	g_Ground = dCreatePlane(g_Space, 0, 0, 1, 0);
	
	dWorldSetGravity(g_World,0 ,0, -9.8);	// gravity setting X,Y,Z
	dWorldSetERP(g_World,1.0);
	dWorldSetCFM(g_World,1e-5);

}



void RunODE(size_t width, size_t height) {
	//page 5
	//TO DO
	InitDrawStuff();
	InitODE();

	InitRobot();

	dsSimulationLoop(0,0,width,height,&g_Fn);
}



void ReleaseODE() {

	dJointGroupDestroy(g_Contactgroup);
	dSpaceDestroy(g_Space);
	dWorldDestroy(g_World);
	dCloseODE();
}



void StartDrawStuff() {

	//TO DO

}


void SimLoopDrawStuff(int pause) 
{
	//page 6
	//TO DO
	PControl();

	double dt = 2.1;
	dWorldStep(g_World,dt);

	dsSetColor(0., 0., 0.);
	dsDrawCapsuleD(dBodyGetPosition(g_oObj[] body),dBodyGetRotation(g_oObj[] body),length, radious);
}



void CommandDrawStuff(int cmd) {

	//TO DO

}



void StopDrawStuff() {

	//TO DO

}


void InitRobot()
{
	//body
	dMass mass;
	dMatrix3 R;

	//mass point
	dReal x[MAX_JOINT_NUM] = {0.0, 0.0};
	dReal y[MAX_JOINT_NUM] = {0.0, 0.0};
	dReal z[MAX_JOINT_NUM] = {0.5, 1.25};

	//link pose
	dReal ori_x[MAX_JOINT_NUM] = {0.0, 0.0};
	dReal ori_y[MAX_JOINT_NUM] = {0.0, 0.0};
	dReal ori_z[MAX_JOINT_NUM] = {1.0, 1.0};
	dReal ori_q[MAX_JOINT_NUM] = {0.0, 0.0};

	//link length
	dReal length[MAX_JOINT_NUM] = {1.0, 0.5};

	//mass of A
	dReal weight[MAX_JOINT_NUM] = {1.0,1.0};

	dReal r[MAX_JOINT_NUM];
	//creating body
	for (int i = 0; i < MAX_JOINT_NUM; i++)
	{
		/* code */
		g_oObj[i].body = dBodyCreate(g_World);
		dBodySetPosition(g_oObj[i].body,x[i],y[i],z[i]);
		dMassSetZero(&mass);
		dMassSetCapsuleTotal(&mass, weight[i], 1, r[i], length[i]);
		dBodySetMass(g_oObj[i].body,&mass);
		g_oObj[i].geom=dCreateCapsule(g_Space, r[i], length[i]);
		dGeomSetBody(g_oObj[i].geom, g_oObj[i].body);
		dRFromAxisAndAngle(R,ori_x[i],ori_y[i],ori_z[i],ori_q[i]);
		dBodySetRotation(g_oObj[i].body, R);
	}
	
	//TO DO


	
}

void PControl()
{

	//TO DO

}