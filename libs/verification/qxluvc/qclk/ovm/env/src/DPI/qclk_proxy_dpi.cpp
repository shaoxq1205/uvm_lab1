
#include <string> 
#include <stdio.h>
#include "svdpi.h"

#ifndef PALLADIUM
#include "XlBitVecCaster.h"
#include "XlSvBridgeSync.h"

using namespace XlVip;
#endif 

using std::string;


extern "C" {

#ifdef PALLADIUM
  static svScope hdlScope_clock[256];
  static int hdlScope_handle=0;
#endif

//---------------------------------------------------------
// Exported DPI-C functions from the Verilog hardware
//------------------------------------------------
void v_setClockPeriod(int hi, int lo);
void v_enableClockGating();
void v_disableClockGating();
void v_setClockGateHi();
void v_setClockGateLo();
void v_setClockGateZ();

//------------------------------------------------------------
//   dpii_initialize_component_handle 
//------------------------------------------------------------   
#ifndef PALLADIUM
void dpii_initialize_component_handle( const char *hdlPath, 
				svBitVecVal *handle)
{
  printf ("void dpii_initialize_component_handle(const char *hdlPath, svBitVecVAl *handle)\n");  
  printf ("hdlPath = %s \n", hdlPath);

  svScope hdlScope = svGetScopeFromName( hdlPath );

  if( hdlScope == NULL ){
    fprintf( stdout,
            "ERROR: ClkRsetDriver: Scope binding at %s failed.\n",
            hdlPath );
    return;
  }

  svSetScope( hdlScope );
  XlBitVecCaster handleCaster( (void *)hdlScope );

  handle[0] = handleCaster[0];
  handle[1] = handleCaster[1];
}

//------------------------------------------------------------
//   dpii_set_clock_period
//------------------------------------------------------------   

void dpii_set_clock_period(const svBitVecVal *handle, int hi, int lo)
{
  printf ("void setClockPeriod(int hi, int lo)\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_setClockPeriod(hi, lo);
}

//------------------------------------------------------------
//   dpii_enable_clock_gating
//------------------------------------------------------------   

void dpii_enable_clock_gating(const svBitVecVal *handle)
{

  printf ("void enableClockGating()\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_enableClockGating();

}

//------------------------------------------------------------
//   dpii_disable_clock_gating
//------------------------------------------------------------   

void dpii_disable_clock_gating(const svBitVecVal *handle)
{
  printf ("void disableClockGating()\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_disableClockGating();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_hi
//------------------------------------------------------------   

void dpii_set_clock_gate_hi(const svBitVecVal *handle)
{
  printf ("void setClockGateHi()\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_setClockGateHi();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_lo
//------------------------------------------------------------   

void dpii_set_clock_gate_lo(const svBitVecVal *handle)
{
  printf ("void setClockGateLo()\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_setClockGateLo();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_z
//------------------------------------------------------------   

void dpii_set_clock_gate_z(const svBitVecVal *handle)
{
  printf ("void setClockGateZ()\n");
  XlBitVecCaster   me(handle);
  svSetScope((svScope) (void *) me);
  v_setClockGateZ();
}
#else

//------------------------------------------------------------
//   dpii_initialize_component_handle 
//------------------------------------------------------------   

int dpii_initialize_component_handle( const char *hdlPath )
{
  int handle = hdlScope_handle++;
  hdlScope_handle++;

  hdlScope_clock[handle] = svGetScopeFromName( hdlPath );
  printf ("Pd_clock_driver:: hdlPath = %s SvScope=%d \n", hdlPath,hdlScope_clock[handle]);

  if( hdlScope_clock[handle] == NULL ){
    fprintf( stdout,
            "ERROR: ClkRsetDriver: Scope binding at %s failed.\n",
            hdlPath );
    return -1;
  }
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  return handle;
}

//------------------------------------------------------------
//   dpii_set_clock_period
//------------------------------------------------------------   

void dpii_set_clock_period(int handle, int hi, int lo)
{
  printf ("void setClockPeriod(int hi, int lo)\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_setClockPeriod(hi, lo);
}

//------------------------------------------------------------
//   dpii_enable_clock_gating
//------------------------------------------------------------   

void dpii_enable_clock_gating(int handle)
{

  printf ("void enableClockGating()\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_enableClockGating();

}

//------------------------------------------------------------
//   dpii_disable_clock_gating
//------------------------------------------------------------   

void dpii_disable_clock_gating(int handle)
{
  printf ("void disableClockGating()\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_disableClockGating();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_hi
//------------------------------------------------------------   

void dpii_set_clock_gate_hi(int handle)
{
  printf ("void setClockGateHi()\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_setClockGateHi();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_lo
//------------------------------------------------------------   

void dpii_set_clock_gate_lo(int handle)
{
  printf ("void setClockGateLo()\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_setClockGateLo();
}

//------------------------------------------------------------
//   dpii_set_clock_gate_z
//------------------------------------------------------------   

void dpii_set_clock_gate_z(int handle)
{
  printf ("void setClockGateZ()\n");
  svScope temp_scope = hdlScope_clock[handle];
  svSetScope( temp_scope );
  v_setClockGateZ();
}
#endif

};
