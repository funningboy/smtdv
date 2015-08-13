
#include "xbus_event.h"
using namespace std;
using namespace XBUS;

#ifdef __cplusplus
extern "C" {

  void* dpi_xbus_create_event() {
    xbus_event* event = (xbus_event*) malloc(sizeof(xbus_event));
    assert(event!=NULL && "ERROR: create xbus event fail");
    return reinterpret_cast<void*>(event);
  }

}
#endif
