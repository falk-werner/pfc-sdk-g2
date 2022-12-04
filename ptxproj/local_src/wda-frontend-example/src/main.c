#include "paramcom_c.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{
    struct wda_proxy * proxy = wda_proxy_create("wda_example_c");
    if (NULL == proxy)
    {
        fprintf(stderr, "error: failed to create proxy\n");
        return EXIT_FAILURE;
    }

    struct wda_error error;
    struct wda_value * value = wda_proxy_read_sync(proxy, "Identity/Ordernumber", &error);
    if (NULL != value)
    {
        char * ordernumber = wda_value_getstring(value);
        printf("Ordernumber: %s\n", ordernumber);
        free(ordernumber);
        wda_value_release(value);
    }
    else
    {
        fprintf(stderr, "error: failed to read value: status=%d", error.status);        
    }

    wda_proxy_release(proxy);
    return EXIT_SUCCESS;
}