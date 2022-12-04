#include "paramcom_c.h"

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

    struct wda_value * read_sync(char const * path, wda_error * error) noexcept
    {
        struct wda_value * result = nullptr;

        try {
            std::vector<wago::wda::parameter_instance_path> requests{ {path} };
            auto future = frontend.get_parameters_by_path(requests);
            auto responses = future.get();
            auto const & response = responses[0];
            if (response.is_success()) {
                result = new wda_value{response.value};
            }
            else {
                if (nullptr != error) {
                    error->status = (int) response.status;
                }
            }
        }
        catch (...) {
            if (nullptr != error) {
                error->status = 1; // general_error
            }
        }

        return result;
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


struct wda_value * wda_proxy_read_sync(struct wda_proxy * proxy, char const * path, struct wda_error * error)
{
    return proxy->read_sync(path, error);
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