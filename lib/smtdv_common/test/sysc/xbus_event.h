#include <systemc.h>

// event listener, collect each r/w evnet callback from slave uvc part
// read event
// write event
using namespace std;

namespace XBUS {

  typedef struct XBUS_EVENT {
    long addr;
    long data;
  } XBUS_EVENT;

}

#ifdef __cplusplus
extern "C" {
  void* dpi_xbus_create_event(); // as xbus_evnet*
  void* dpi_xbus_assign_event(void* e, long addr, long data);
  void  dpi_xbus_free_event(void* e);
}
#endif

