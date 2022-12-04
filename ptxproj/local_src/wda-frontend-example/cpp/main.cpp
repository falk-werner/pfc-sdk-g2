#include <wago/paramcom/parameter_service_frontend_proxy.hpp>
#include <iostream>
#include <thread>
#include <atomic>

int main()
{
    wago::paramcom::parameter_service_frontend_proxy proxy("wda-cpp-example");
    auto & frontend = proxy.get_frontend();

    std::atomic<bool> shutdown_requested(false);
    std::thread context([&proxy, &shutdown_requested]() {
        while (!shutdown_requested) {
            proxy.run_once(1000);
        }
    });

    std::vector<wago::wda::parameter_instance_path> request{ {"Identity/Ordernumber"} };
    auto future = frontend.get_parameters_by_path(request);
    auto responses = future.get();
    auto const & response = responses.at(0);
    if (response.is_success()) {
        std::cout << "Ordernumber: " << response.value->get_string() << std::endl;
    }
    else {
        std::cerr << "failed to read: status=" << (int) response.status << std::endl;
    }

    shutdown_requested = true;
    context.join();
    return EXIT_SUCCESS;
}