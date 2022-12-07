#include "wda_proxy.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{
    int exit_code = EXIT_SUCCESS;

    struct wda_proxy * proxy = wda_proxy_create("wda-c-example");
    if (NULL == proxy)
    {
        fprintf(stderr, "error: failed to create proxy\n");
        return EXIT_FAILURE;
    }

    struct wda_error error;
    char * ordernumber = wda_proxy_read_str_sync(proxy, "Identity/Ordernumber", &error);
    if (NULL != ordernumber)
    {
        printf("Ordernumber: %s\n", ordernumber);
        free(ordernumber);
    }
    else
    {
        fprintf(stderr, "error: failed to read value: status=%d", error.status);
        exit_code = EXIT_FAILURE;     
    }

    wda_proxy_release(proxy);
    return exit_code;
}
