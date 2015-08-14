
#include "XBUS_EVENT.h"
using namespace std;
using namespace XBUS;

#ifdef __cplusplus
extern "C" {

  void* dpi_xbus_create_event() {
    XBUS_EVENT* event = (XBUS_EVENT*) malloc(sizeof(XBUS_EVENT));
    assert(event!=NULL && "ERROR: create xbus event fail");
    return reinterpret_cast<void*>(event);
  }

  void* dpi_xbus_assign_event(void* e, long addr, long data) {
    XBUS_EVENT* event = reinterpret_cast<XBUS_EVENT*>(e);
    assert(event!=NULL && "ERROR: assign xbus event fail");
    event->addr = addr;
    event->data = data;
    return reinterpret_cast<void*>(event);
  }

  void dpi_xbus_free_event(void* e) {
    if(e) {
      XBUS_EVENT* event = reinterpret_cast<XBUS_EVENT*>(e);
      assert(event!=NULL && "ERROR: free xbus event fail");
      delete event;
    }
  }

  void dpi_xbus_emit_event(void* e) {
    XBUS_EVENT* event = reinterpret_cast<XBUS_EVENT*>(e);
    assert(event!=NULL && "ERROR: emit xbus event fail");
    listener.emit(e);
  }

}
#endif
