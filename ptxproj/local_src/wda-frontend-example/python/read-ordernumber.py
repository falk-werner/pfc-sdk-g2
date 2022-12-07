#!/usr/bin/env python3

from ctypes import *

cdll.LoadLibrary("libwda_proxy.so")
libwda_proxy = CDLL("libwda_proxy.so")
libwda_proxy.wda_proxy_read_str_sync.restype = c_char_p

class WdaProxy:
    def __init__(self):
        self.proxy = libwda_proxy.wda_proxy_create(b"wda-python-example")
    
    def __del__(self):
        libwda_proxy.wda_proxy_release(self.proxy)
    
    def read_str_sync(self, path):
        value = libwda_proxy.wda_proxy_read_str_sync(self.proxy, path.encode(), 0)
        if 0 == value:
            raise Exception("failed to read")
        return value.decode()

proxy = WdaProxy()
order_number = proxy.read_str_sync("Identity/Ordernumber")
print("Ordernubmer: %s" % (order_number))
