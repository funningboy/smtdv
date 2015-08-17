
#include "EVENT.h"
using namespace std;
using namespace tlm0;

#ifdef __cplusplus
extern "C" {

  void* dpi_tlm0_create_event() {
    EVENT* event = (EVENT*) malloc(sizeof(EVENT));
    assert(event!=NULL && "ERROR: create tlm0 event fail");
    return reinterpret_cast<void*>(event);
  }

  void* dpi_tlm0_assign_event(void* e, long addr, long data) {
    EVENT* event = reinterpret_cast<EVENT*>(e);
    assert(event!=NULL && "ERROR: assign tlm0 event fail");
    event->addr = addr;
    event->data = data;
    return reinterpret_cast<void*>(event);
  }

  void dpi_tlm0_free_event(void* e) {
    if(e) {
      EVENT* event = reinterpret_cast<EVENT*>(e);
      assert(event!=NULL && "ERROR: free tlm0 event fail");
      delete event;
    }
  }

  void dpi_tlm0_emit_event(void* e) {
    EVENT* event = reinterpret_cast<EVENT*>(e);
    assert(event!=NULL && "ERROR: emit tlm0 event fail");
    listener.emit(e);
  }

}
#
