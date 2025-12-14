// Just redirect camera heap allocations to system heap

#include <linux/slab.h>
#include "ion.h"

struct ion_heap *ion_camera_heap_create(struct ion_platform_heap *data)
{
    // Simply create a system heap with camera heap type
    struct ion_heap *heap;
    
    heap = ion_system_heap_create(data);
    if (IS_ERR(heap))
        return heap;
    
    // Override the type to camera heap
    heap->type = (enum ion_heap_type)ION_HEAP_TYPE_CAMERA;
    
    return heap;
}
