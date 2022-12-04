#ifndef WDA_PROXY_H
#define WDA_PROXY_H

#ifdef __cplusplus
extern "C"
{
#endif

struct wda_proxy;

struct wda_error
{
    int status;
    // ToDo: add more fields
};

extern struct wda_proxy * wda_proxy_create(char const * connection_name);
extern void wda_proxy_release(struct wda_proxy * proxy);

extern char * wda_proxy_read_str_sync(struct wda_proxy * proxy, char const * path, struct wda_error * error);
// ToDo: add some more methods

#ifdef __cplusplus
}
#endif

#endif
