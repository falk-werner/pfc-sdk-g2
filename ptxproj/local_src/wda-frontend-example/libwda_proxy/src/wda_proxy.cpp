#include "wda_proxy.h"

#include <wago/paramcom/parameter_service_frontend_proxy.hpp>
#include <cstring>
#include <thread>
#include <atomic>

extern "C"
{

struct wda_value
{
    std::shared_ptr<wago::wda::parameter_value> value;
};

struct wda_proxy
{
    wda_proxy(wda_proxy const &) = delete;
    wda_proxy& operator=(wda_proxy const &) = delete;
    wda_proxy(wda_proxy &&) = delete;
    wda_proxy& operator=(wda_proxy &&) = delete;
public:
    explicit wda_proxy(char const * name)
    : proxy(name)
    , frontend(proxy.get_frontend())
    , shutdown_requested(false)
    {
        context = std::thread([this](){
            while (!shutdown_requested) {
                proxy.run_once(1000);
            }
        });
    }

    ~wda_proxy()
    {
        shutdown_requested = true;
        context.join();
    }

    wago::wda::parameter_response read_sync(char const * path) 
    {
        std::vector<wago::wda::parameter_instance_path> requests{ {path} };
        auto future = frontend.get_parameters_by_path(requests);
        auto responses = future.get();
        return responses[0];
    }

private:
    wago::paramcom::parameter_service_frontend_proxy proxy;
    wago::wda::parameter_service_frontend_i &frontend;
    std::atomic<bool> shutdown_requested;
    std::thread context;
};

struct wda_proxy * wda_proxy_create(char const * connection_name)
{
    try {
        return new wda_proxy(connection_name);
    }
    catch (...) {
        return nullptr;
    }
}

void wda_proxy_release(struct wda_proxy * proxy)
{
    delete proxy;
}


char * wda_proxy_read_str_sync(struct wda_proxy * proxy, char const * path, struct wda_error * error)
{
    char * result = nullptr;

    try {
        auto response = proxy->read_sync(path);
            if (response.is_success()) {
                result = strdup(response.value->get_string().c_str());
            }
            else {
                if (nullptr != error) {
                    error->status = (int) response.status;
                }
            }
    }
    catch (...) {
        if (nullptr != error) {
            error->status = -1;
        }
    }

    return result;
}

void wda_value_release(struct wda_value * value)
{
    delete value;
}

char * wda_value_getstring(struct wda_value * value)
{
    try {
        return strdup(value->value->get_string().c_str());
    }
    catch (...) {
        return nullptr;
    }
}


}