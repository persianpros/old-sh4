
#ifndef GLOBAL_H_
#define GLOBAL_H_

#ifndef bool
#define bool unsigned char
#define true 1
#define false 0
#endif

#include "map.h"

#define INPUT_PRESS 1
#define INPUT_RELEASE 0

typedef enum {Unknown, Ufs910_1W, Ufs910_14W, Ufs922, Tf7700, Hl101, Vip2, HdBox,
				Hs5101, Ufs912, Spark, Cuberevo, Adb_Box, Ipbox, Opti, Pingulux, Classic, Mce2005, TTUSBIR} eBoxType;
typedef enum {RemoteControl, FrontPanel} eKeyType;

typedef struct Context_s {
  void* /* RemoteControl_t */  *r; /* instance data */
  int                          fd; /* filedescriptor of fd */

} Context_t;

typedef struct {
  unsigned int delay;
  unsigned int period;

} tLongKeyPressSupport;

int getInternalCode(tButton * cButtons, const char cCode[3]);

int getInternalCodeHex(tButton * cButtons, const unsigned char cCode);

int printKeyMap(tButton * cButtons);

int checkTuxTxt(const int cCode);

void sendInputEvent(const int cCode);
void sendInputEventT(const unsigned int type, const int cCode);

int getEventDevice();

int selectRemote(Context_t  *context, eBoxType type);

void setInputEventRepeatRate(unsigned int delay, unsigned int period);

#endif
