#ifndef LIBPARAMCOM_C_HPP
#define LIBPARAMCOM_C_HPP

#ifdef __cplusplus
extern "C"
{
#endif

struct wda_proxy;
struct wda_value;

struct wda_error
{
    int status;
    // ToDo: add more fields
};

extern struct wda_proxy * wda_proxy_create(char const * connection_name);
extern void wda_proxy_release(struct wda_proxy * proxy);

extern struct wda_value * wda_proxy_read_sync(struct wda_proxy * proxy, char const * path, struct wda_error * error);

extern void wda_value_release(struct wda_value * value);
extern char * wda_value_getstring(struct wda_value * value);
// ToDo: add some more getters

#ifdef __cplusplus
}
#endif

#endif
