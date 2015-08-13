#include <systemc.h>

// event listener, collect each r/w evnet callback from slave uvc part
// read event
// write event
using namespace std;

namespace XBUS {

  typedef struct xbus_event {
   sc_signal<sc_int<32> > a;
  } xbus_event;

}

#ifdef __cplusplus
extern "C" {
  void* dpi_xbus_create_event(); // as xbus_evnet*
  void  dpi_xbus_free_event();
}
#endif

