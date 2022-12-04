#include <wago/paramcom/parameter_service_frontend_proxy.hpp>
#include <iostream>
#include <thread>
#include <atomic>

int main()
{
    wago::paramcom::parameter_service_frontend_proxy proxy("myconnection");
    auto & frontend = proxy.get_frontend();

    std::cout << "Hi, there!" << std::endl;
    std::atomic<bool> shutdown_requested(false);
    std::thread context([&proxy, &shutdown_requested]() {
        while (!shutdown_requested) {
            proxy.run_once(1000);
        }
    });

    std::vector<wago::wda::parameter_instance_path> request{ {"Identity/Ordernumber"} };
    auto response = frontend.get_parameters_by_path(request);
    auto values = response.get();
    auto const & value = values[0];
    std::cout << (int) value.status << std::endl;
    std::cout << value.value->get_string() << std::endl;

    std::cout << "shutdown" << std::endl;
    shutdown_requested = true;
    context.join();
    return EXIT_SUCCESS;
}