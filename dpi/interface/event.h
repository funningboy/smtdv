#include <iostream>

using namespace std;

namespace TLM0 {

  typedef struct EVENT {
    long addr;
    long data;
  } EVENT;


}

#ifdef __cplusplus
extern "C" {
  void* dpi_tlm0_create_event(); // as tlm0_evnet*
  void* dpi_tlm0_assign_event(void* e, long addr, long data);
  void  dpi_tlm0_free_event(void* e);
}
#endif

